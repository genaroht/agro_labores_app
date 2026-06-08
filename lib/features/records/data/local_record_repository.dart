import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';

class RecordFormSaveData {
  const RecordFormSaveData({
    required this.recordDate,
    required this.weekNumber,
    required this.departmentId,
    required this.createdByUserId,
    required this.userCode,
    required this.operatorId,
    required this.operatorNameSnapshot,
    required this.cropId,
    required this.cropNameSnapshot,
    required this.taskId,
    required this.taskNameSnapshot,
    required this.taskDetail,
    required this.lot,
    required this.network,
    required this.scheduledWage,
    required this.realWage,
    required this.ha,
    required this.ratio,
    required this.diningRoom,
    required this.observation,
    required this.extraFields,
    required this.selectedLocations,
  });

  final DateTime recordDate;
  final int weekNumber;
  final String departmentId;
  final String createdByUserId;
  final String userCode;

  final String? operatorId;
  final String? operatorNameSnapshot;

  final String? cropId;
  final String? cropNameSnapshot;

  final String? taskId;
  final String? taskNameSnapshot;
  final String? taskDetail;

  final String? lot;
  final String? network;

  final double? scheduledWage;
  final double? realWage;
  final double ha;
  final double? ratio;

  final String? diningRoom;
  final String? observation;

  final Map<String, dynamic> extraFields;
  final List<LocationEntry> selectedLocations;
}

class LocalRecordRepository {
  const LocalRecordRepository(this._database);

  final AppDatabase _database;

  Future<void> ensureDemoFormConfig() async {
    await _database.seedDemoData();

    await _database.transaction(() async {
      await _database
          .into(_database.operators)
          .insertOnConflictUpdate(
            OperatorsCompanion.insert(
              id: 'op_002',
              code: 'OP002',
              fullName: 'Operario Demo 02',
              departmentId: const Value('dep_cosecha_arandano'),
            ),
          );

      await _database
          .into(_database.operators)
          .insertOnConflictUpdate(
            OperatorsCompanion.insert(
              id: 'op_003',
              code: 'OP003',
              fullName: 'Operario Demo 03',
              departmentId: const Value('dep_palto_fondo_01'),
            ),
          );

      await _database
          .into(_database.tasks)
          .insertOnConflictUpdate(
            TasksCompanion.insert(
              id: 'task_raleo',
              departmentId: const Value('dep_labores_arandano'),
              name: 'Raleo',
              defaultDetail: const Value('Raleo manual'),
            ),
          );

      await _database
          .into(_database.tasks)
          .insertOnConflictUpdate(
            TasksCompanion.insert(
              id: 'task_seleccion_cosecha',
              departmentId: const Value('dep_cosecha_arandano'),
              name: 'Selección de fruta',
              defaultDetail: const Value('Selección en cosecha'),
            ),
          );

      await _database
          .into(_database.tasks)
          .insertOnConflictUpdate(
            TasksCompanion.insert(
              id: 'task_mantenimiento_palto',
              departmentId: const Value('dep_palto_fondo_01'),
              name: 'Mantenimiento',
              defaultDetail: const Value('Mantenimiento de campo'),
            ),
          );

      await _seedLaboresArandanoFields();
      await _seedCosechaArandanoFields();
      await _seedPaltoFields();
    });
  }

  Future<void> _seedLaboresArandanoFields() async {
    final fields = [
      _DemoField('lab_fecha', 'recordDate', 'Fecha', 'date', true, 1),
      _DemoField('lab_operario', 'operatorId', 'Operario', 'operator', true, 2),
      _DemoField('lab_cultivo', 'cropId', 'Cultivo', 'crop', true, 3),
      _DemoField('lab_labor', 'taskId', 'Labor', 'task', true, 4),
      _DemoField(
        'lab_detalle',
        'taskDetail',
        'Detalle de labor',
        'text',
        false,
        5,
      ),
      _DemoField(
        'lab_jp',
        'scheduledWage',
        'Jornal programado',
        'number',
        false,
        6,
      ),
      _DemoField('lab_jr', 'realWage', 'Jornal real', 'number', true, 7),
      _DemoField('lab_comedor', 'diningRoom', 'Comedor', 'text', false, 8),
      _DemoField(
        'lab_obs',
        'observation',
        'Observación',
        'multiline',
        false,
        9,
      ),
    ];

    await _insertFields('dep_labores_arandano', fields);
  }

  Future<void> _seedCosechaArandanoFields() async {
    final fields = [
      _DemoField('cos_fecha', 'recordDate', 'Fecha', 'date', true, 1),
      _DemoField('cos_operario', 'operatorId', 'Operario', 'operator', true, 2),
      _DemoField('cos_cultivo', 'cropId', 'Cultivo', 'crop', true, 3),
      _DemoField('cos_labor', 'taskId', 'Labor', 'task', true, 4),
      _DemoField(
        'cos_jabas',
        'cantidadJabas',
        'Cantidad de jabas',
        'number',
        true,
        5,
      ),
      _DemoField('cos_jr', 'realWage', 'Jornal real', 'number', true, 6),
      _DemoField('cos_comedor', 'diningRoom', 'Comedor', 'text', false, 7),
      _DemoField(
        'cos_obs',
        'observation',
        'Observación',
        'multiline',
        false,
        8,
      ),
    ];

    await _insertFields('dep_cosecha_arandano', fields);
  }

  Future<void> _seedPaltoFields() async {
    final fields = [
      _DemoField('pal_fecha', 'recordDate', 'Fecha', 'date', true, 1),
      _DemoField('pal_operario', 'operatorId', 'Operario', 'operator', true, 2),
      _DemoField('pal_cultivo', 'cropId', 'Cultivo', 'crop', true, 3),
      _DemoField('pal_labor', 'taskId', 'Labor', 'task', true, 4),
      _DemoField('pal_jr', 'realWage', 'Jornal real', 'number', true, 5),
      _DemoField(
        'pal_obs',
        'observation',
        'Observación',
        'multiline',
        false,
        6,
      ),
    ];

    await _insertFields('dep_palto_fondo_01', fields);
  }

  Future<void> _insertFields(
    String departmentId,
    List<_DemoField> fields,
  ) async {
    for (final field in fields) {
      await _database
          .into(_database.formFieldConfigs)
          .insertOnConflictUpdate(
            FormFieldConfigsCompanion.insert(
              id: '${departmentId}_${field.id}',
              departmentId: departmentId,
              fieldKey: field.fieldKey,
              label: field.label,
              fieldType: field.fieldType,
              isRequired: Value(field.isRequired),
              isVisible: const Value(true),
              sortOrder: Value(field.sortOrder),
            ),
          );
    }
  }

  Future<List<FormFieldConfig>> getFieldsForDepartment(String departmentId) {
    return (_database.select(_database.formFieldConfigs)
          ..where(
            (tbl) =>
                tbl.departmentId.equals(departmentId) &
                tbl.isVisible.equals(true) &
                tbl.deletedAt.isNull(),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
        .get();
  }

  Future<List<FarmOperator>> getOperatorsForDepartment(String departmentId) {
    return (_database.select(_database.operators)
          ..where(
            (tbl) =>
                tbl.isActive.equals(true) &
                tbl.deletedAt.isNull() &
                (tbl.departmentId.equals(departmentId) |
                    tbl.departmentId.isNull()),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.fullName)]))
        .get();
  }

  Future<List<Crop>> getCrops() {
    return _database.getActiveCrops();
  }

  Future<List<FarmTask>> getTasksForDepartment(String departmentId) {
    return _database.getActiveTasksByDepartment(departmentId);
  }

  Future<List<LocationEntry>> getLocationsForCrop(String cropId) {
    return _database.getLocationsByCrop(cropId);
  }

  Future<List<FarmRecordLocation>> getRecordLocations(String recordId) {
    return (_database.select(_database.recordLocations)
          ..where(
            (tbl) => tbl.recordId.equals(recordId) & tbl.deletedAt.isNull(),
          )
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.lotSnapshot),
            (tbl) => OrderingTerm.asc(tbl.networkSnapshot),
            (tbl) => OrderingTerm.asc(tbl.sectorSnapshot),
          ]))
        .get();
  }

  Future<List<FarmRecord>> getRecordsForDepartment({
    required String departmentId,
    required String userId,
    required bool isAdmin,
  }) {
    final query = _database.select(_database.records)
      ..where(
        (tbl) =>
            tbl.departmentId.equals(departmentId) &
            tbl.isActive.equals(true) &
            tbl.deletedAt.isNull(),
      )
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.recordDate),
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ]);

    if (!isAdmin) {
      query.where((tbl) => tbl.createdByUserId.equals(userId));
    }

    return query.get();
  }

  Future<FarmRecord?> getRecordById(String recordId) {
    return (_database.select(_database.records)
          ..where((tbl) => tbl.id.equals(recordId) & tbl.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<void> createRecord(RecordFormSaveData data) async {
    final now = DateTime.now();
    final recordId = 'record_${now.microsecondsSinceEpoch}';

    final extraFieldsJson = data.extraFields.isEmpty
        ? null
        : jsonEncode(data.extraFields);

    await _database.transaction(() async {
      await _database
          .into(_database.records)
          .insert(
            RecordsCompanion.insert(
              id: recordId,
              recordDate: data.recordDate,
              weekNumber: data.weekNumber,
              departmentId: data.departmentId,
              createdByUserId: data.createdByUserId,
              userCode: data.userCode,
              operatorId: Value<String?>(data.operatorId),
              operatorNameSnapshot: Value<String?>(data.operatorNameSnapshot),
              cropId: Value<String?>(data.cropId),
              cropNameSnapshot: Value<String?>(data.cropNameSnapshot),
              taskId: Value<String?>(data.taskId),
              taskNameSnapshot: Value<String?>(data.taskNameSnapshot),
              taskDetail: Value<String?>(data.taskDetail),
              lot: Value<String?>(data.lot),
              network: Value<String?>(data.network),
              scheduledWage: Value<double?>(data.scheduledWage),
              realWage: Value<double?>(data.realWage),
              ha: Value<double>(data.ha),
              ratio: Value<double?>(data.ratio),
              diningRoom: Value<String?>(data.diningRoom),
              observation: Value<String?>(data.observation),
              extraFieldsJson: Value<String?>(extraFieldsJson),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatuses.pending),
            ),
          );

      await _insertRecordLocations(recordId: recordId, data: data, now: now);
    });
  }

  Future<void> updateRecord({
    required String recordId,
    required RecordFormSaveData data,
    required String currentUserId,
    required bool isAdmin,
  }) async {
    final existing = await getRecordById(recordId);

    if (existing == null) {
      throw Exception('El registro no existe.');
    }

    if (!isAdmin && existing.createdByUserId != currentUserId) {
      throw Exception('No puede editar registros de otro usuario.');
    }

    final now = DateTime.now();
    final extraFieldsJson = data.extraFields.isEmpty
        ? null
        : jsonEncode(data.extraFields);

    await _database.transaction(() async {
      await (_database.update(
        _database.records,
      )..where((tbl) => tbl.id.equals(recordId))).write(
        RecordsCompanion(
          recordDate: Value(data.recordDate),
          weekNumber: Value(data.weekNumber),
          departmentId: Value(data.departmentId),
          userCode: Value(data.userCode),
          operatorId: Value<String?>(data.operatorId),
          operatorNameSnapshot: Value<String?>(data.operatorNameSnapshot),
          cropId: Value<String?>(data.cropId),
          cropNameSnapshot: Value<String?>(data.cropNameSnapshot),
          taskId: Value<String?>(data.taskId),
          taskNameSnapshot: Value<String?>(data.taskNameSnapshot),
          taskDetail: Value<String?>(data.taskDetail),
          lot: Value<String?>(data.lot),
          network: Value<String?>(data.network),
          scheduledWage: Value<double?>(data.scheduledWage),
          realWage: Value<double?>(data.realWage),
          ha: Value<double>(data.ha),
          ratio: Value<double?>(data.ratio),
          diningRoom: Value<String?>(data.diningRoom),
          observation: Value<String?>(data.observation),
          extraFieldsJson: Value<String?>(extraFieldsJson),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatuses.pending),
        ),
      );

      await (_database.update(_database.recordLocations)..where(
            (tbl) => tbl.recordId.equals(recordId) & tbl.deletedAt.isNull(),
          ))
          .write(
            RecordLocationsCompanion(
              deletedAt: Value<DateTime?>(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatuses.pending),
            ),
          );

      await _insertRecordLocations(recordId: recordId, data: data, now: now);
    });
  }

  Future<void> _insertRecordLocations({
    required String recordId,
    required RecordFormSaveData data,
    required DateTime now,
  }) async {
    for (var index = 0; index < data.selectedLocations.length; index++) {
      final location = data.selectedLocations[index];

      await _database
          .into(_database.recordLocations)
          .insert(
            RecordLocationsCompanion.insert(
              id: 'record_location_${recordId}_${index}_${now.microsecondsSinceEpoch}',
              recordId: recordId,
              locationId: location.id,
              cropNameSnapshot: data.cropNameSnapshot ?? '',
              lotSnapshot: location.lot,
              networkSnapshot: location.network,
              sectorSnapshot: location.sector,
              haSnapshot: location.ha,
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatuses.pending),
            ),
          );
    }
  }

  Future<void> deleteRecordAsAdmin({
    required String recordId,
    required bool isAdmin,
  }) async {
    if (!isAdmin) {
      throw Exception('Solo el administrador puede eliminar registros.');
    }

    await (_database.update(
      _database.records,
    )..where((tbl) => tbl.id.equals(recordId))).write(
      RecordsCompanion(
        isActive: const Value(false),
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatuses.pending),
      ),
    );
  }
}

class _DemoField {
  const _DemoField(
    this.id,
    this.fieldKey,
    this.label,
    this.fieldType,
    this.isRequired,
    this.sortOrder,
  );

  final String id;
  final String fieldKey;
  final String label;
  final String fieldType;
  final bool isRequired;
  final int sortOrder;
}

final localRecordRepositoryProvider = Provider<LocalRecordRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return LocalRecordRepository(database);
});
