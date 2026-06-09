import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_environment.dart';
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
    required this.diningRoomId,
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

  final String? diningRoomId;
  final String? diningRoom;
  final String? observation;

  final Map<String, dynamic> extraFields;
  final List<LocationEntry> selectedLocations;
}

class LocalRecordRepository {
  const LocalRecordRepository(this._database);

  final AppDatabase _database;

  Future<void> ensureDevelopmentFormConfig() async {
    if (!AppEnvironment.enableDevelopmentSeed) {
      return;
    }

    await _database.seedDevelopmentData();

    await _database.transaction(() async {
      await _database
          .into(_database.operators)
          .insertOnConflictUpdate(
            OperatorsCompanion.insert(
              id: 'op_002',
              code: '000102',
              fullName: 'Operario 02',
              departmentId: const Value('dep_cosecha_arandano'),
              positionId: const Value('position_operario'),
            ),
          );

      await _database
          .into(_database.operators)
          .insertOnConflictUpdate(
            OperatorsCompanion.insert(
              id: 'op_003',
              code: '000103',
              fullName: 'Operario 03',
              departmentId: const Value('dep_palto_fondo_01'),
              positionId: const Value('position_operario'),
            ),
          );

      await _database
          .into(_database.tasks)
          .insertOnConflictUpdate(
            TasksCompanion.insert(
              id: 'task_raleo',
              departmentId: const Value('dep_labores_arandano'),
              cropId: const Value('crop_arandano'),
              code: const Value('AR-LAB-001'),
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
              cropId: const Value('crop_arandano'),
              code: const Value('AR-COS-001'),
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
              cropId: const Value('crop_palto'),
              code: const Value('PA-F1-001'),
              name: 'Mantenimiento',
              defaultDetail: const Value('Mantenimiento de campo'),
            ),
          );

      await _database
          .into(_database.tasks)
          .insertOnConflictUpdate(
            TasksCompanion.insert(
              id: 'task_control_roedores_palto_2',
              departmentId: const Value('dep_palto_fondo_02'),
              cropId: const Value('crop_palto'),
              code: const Value('PA-F2-001'),
              name: 'Control de Roedores',
              defaultDetail: const Value('Control de Roedores'),
            ),
          );

      await _database
          .into(_database.tasks)
          .insertOnConflictUpdate(
            TasksCompanion.insert(
              id: 'task_amarre_palto_2',
              departmentId: const Value('dep_palto_fondo_02'),
              cropId: const Value('crop_palto'),
              code: const Value('PA-F2-002'),
              name: 'Amarre de Ramas Orillas y Troncales',
              defaultDetail: const Value('Amarre de Ramas Orillas y Troncales'),
            ),
          );

      await _seedLaboresArandanoFields();
      await _seedCosechaArandanoFields();
      await _seedPaltoFields('dep_palto_fondo_01');
      await _seedPaltoFields('dep_palto_fondo_02');
    });
  }

  Future<void> _seedLaboresArandanoFields() async {
    final fields = [
      _DevelopmentField(
        'lab_fecha',
        'recordDate',
        'Fecha de programación',
        'date',
        true,
        1,
      ),
      _DevelopmentField(
        'lab_operario',
        'operatorId',
        'Líder',
        'operator',
        true,
        2,
      ),
      _DevelopmentField('lab_cultivo', 'cropId', 'Cultivo', 'crop', true, 3),
      _DevelopmentField('lab_labor', 'taskId', 'Labor', 'task', true, 4),
      _DevelopmentField(
        'lab_detalle',
        'taskDetail',
        'Detalle de labor',
        'text',
        false,
        5,
      ),
      _DevelopmentField(
        'lab_jp',
        'scheduledWage',
        'Jornal programado',
        'number',
        false,
        6,
      ),
      _DevelopmentField(
        'lab_jr',
        'realWage',
        'Jornal real',
        'number',
        false,
        7,
      ),
      _DevelopmentField(
        'lab_comedor',
        'diningRoom',
        'Comedor',
        'text',
        false,
        8,
      ),
      _DevelopmentField(
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
      _DevelopmentField('cos_fecha', 'recordDate', 'Fecha', 'date', true, 1),
      _DevelopmentField(
        'cos_operario',
        'operatorId',
        'Operario',
        'operator',
        true,
        2,
      ),
      _DevelopmentField('cos_cultivo', 'cropId', 'Cultivo', 'crop', true, 3),
      _DevelopmentField('cos_labor', 'taskId', 'Labor', 'task', true, 4),
      _DevelopmentField(
        'cos_jabas',
        'cantidadJabas',
        'Cantidad de jabas',
        'number',
        true,
        5,
      ),
      _DevelopmentField('cos_jr', 'realWage', 'Jornal real', 'number', true, 6),
      _DevelopmentField(
        'cos_comedor',
        'diningRoom',
        'Comedor',
        'text',
        false,
        7,
      ),
      _DevelopmentField(
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

  Future<void> _seedPaltoFields(String departmentId) async {
    final fields = [
      _DevelopmentField(
        'pal_fecha',
        'recordDate',
        'Fecha de programación',
        'date',
        true,
        1,
      ),
      _DevelopmentField(
        'pal_operario',
        'operatorId',
        'Líder',
        'operator',
        true,
        2,
      ),
      _DevelopmentField('pal_cultivo', 'cropId', 'Cultivo', 'crop', true, 3),
      _DevelopmentField('pal_labor', 'taskId', 'Labor', 'task', true, 4),
      _DevelopmentField(
        'pal_jp',
        'scheduledWage',
        'Jornal programado',
        'number',
        true,
        5,
      ),
      _DevelopmentField(
        'pal_jr',
        'realWage',
        'Jornal real',
        'number',
        false,
        6,
      ),
      _DevelopmentField(
        'pal_obs',
        'observation',
        'Observación',
        'multiline',
        false,
        7,
      ),
    ];

    await _insertFields(departmentId, fields);
  }

  Future<void> _insertFields(
    String departmentId,
    List<_DevelopmentField> fields,
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

  Future<List<Department>> getDepartments() {
    return (_database.select(_database.departments)
          ..where((tbl) => tbl.deletedAt.isNull() & tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
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

  Future<List<FarmOperator>> getLeaderOperatorsForDepartment(
    String departmentId,
  ) async {
    final operators = await getOperatorsForDepartment(departmentId);
    final positions =
        await (_database.select(_database.positions)..where(
              (tbl) => tbl.deletedAt.isNull() & tbl.isActive.equals(true),
            ))
            .get();

    final leaderPositionIds = positions
        .where((position) {
          final normalizedName = _normalizeText(position.name);
          final normalizedId = _normalizeText(position.id);

          return position.canBeLeader ||
              normalizedName == 'lider' ||
              normalizedId.contains('lider');
        })
        .map((position) => position.id)
        .toSet();

    return operators
        .where((operator) => leaderPositionIds.contains(operator.positionId))
        .toList();
  }

  Future<Department?> getDepartmentById(String departmentId) {
    return (_database.select(_database.departments)..where(
          (tbl) =>
              tbl.id.equals(departmentId) &
              tbl.deletedAt.isNull() &
              tbl.isActive.equals(true),
        ))
        .getSingleOrNull();
  }

  Future<Crop?> getCropById(String cropId) {
    return (_database.select(_database.crops)..where(
          (tbl) =>
              tbl.id.equals(cropId) &
              tbl.deletedAt.isNull() &
              tbl.isActive.equals(true),
        ))
        .getSingleOrNull();
  }

  Future<List<DiningRoom>> getDiningRoomsForCropLotNetwork({
    required String cropId,
    required String lot,
    required String network,
  }) {
    return _database.getActiveDiningRoomsByCropLotNetwork(
      cropId: cropId,
      lot: lot,
      network: network,
    );
  }

  Future<DiningRoom?> getDiningRoomById(String diningRoomId) {
    return (_database.select(_database.diningRooms)..where(
          (tbl) =>
              tbl.id.equals(diningRoomId) &
              tbl.deletedAt.isNull() &
              tbl.isActive.equals(true),
        ))
        .getSingleOrNull();
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

  Future<FarmOperator?> getOperatorById(String operatorId) {
    return (_database.select(_database.operators)
          ..where((tbl) => tbl.id.equals(operatorId) & tbl.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<_RecordSaveSnapshots> _resolveRecordSaveSnapshots(
    RecordFormSaveData data,
  ) async {
    FarmOperator? leader;
    FarmTask? task;

    final operatorId = data.operatorId;
    final taskId = data.taskId;

    if (operatorId != null && operatorId.trim().isNotEmpty) {
      leader = await getOperatorById(operatorId);
    }

    if (taskId != null && taskId.trim().isNotEmpty) {
      task =
          await (_database.select(
                _database.tasks,
              )..where((tbl) => tbl.id.equals(taskId) & tbl.deletedAt.isNull()))
              .getSingleOrNull();
    }

    return _RecordSaveSnapshots(
      leaderCodeSnapshot: leader?.code,
      leaderNameSnapshot: data.operatorNameSnapshot ?? leader?.fullName,
      taskCodeSnapshot: task?.code,
    );
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

  Future<Map<String, List<FarmRecordLocation>>> getRecordLocationsForRecords(
    List<String> recordIds,
  ) async {
    if (recordIds.isEmpty) {
      return {};
    }

    final rows =
        await (_database.select(_database.recordLocations)
              ..where(
                (tbl) => tbl.recordId.isIn(recordIds) & tbl.deletedAt.isNull(),
              )
              ..orderBy([
                (tbl) => OrderingTerm.asc(tbl.recordId),
                (tbl) => OrderingTerm.asc(tbl.lotSnapshot),
                (tbl) => OrderingTerm.asc(tbl.networkSnapshot),
                (tbl) => OrderingTerm.asc(tbl.sectorSnapshot),
              ]))
            .get();

    final grouped = <String, List<FarmRecordLocation>>{};

    for (final row in rows) {
      grouped.putIfAbsent(row.recordId, () => []).add(row);
    }

    return grouped;
  }

  Future<Map<String, FarmOperator>> getOperatorsByIds(
    Iterable<String> operatorIds,
  ) async {
    final ids = operatorIds
        .where((id) => id.trim().isNotEmpty)
        .toSet()
        .toList();

    if (ids.isEmpty) {
      return {};
    }

    final rows = await (_database.select(
      _database.operators,
    )..where((tbl) => tbl.id.isIn(ids) & tbl.deletedAt.isNull())).get();

    return {for (final row in rows) row.id: row};
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

  Future<List<FarmRecord>> getAllActiveRecordsForAdmin() {
    return (_database.select(_database.records)
          ..where((tbl) => tbl.isActive.equals(true) & tbl.deletedAt.isNull())
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.recordDate),
            (tbl) => OrderingTerm.desc(tbl.createdAt),
          ]))
        .get();
  }

  Future<FarmRecord?> getRecordById(String recordId) {
    return (_database.select(_database.records)
          ..where((tbl) => tbl.id.equals(recordId) & tbl.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<void> createRecord(RecordFormSaveData data) async {
    final now = DateTime.now();
    final recordId = 'record_${now.microsecondsSinceEpoch}';
    final snapshots = await _resolveRecordSaveSnapshots(data);

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
              leaderOperatorId: Value<String?>(data.operatorId),
              leaderCodeSnapshot: Value<String?>(snapshots.leaderCodeSnapshot),
              leaderNameSnapshot: Value<String?>(snapshots.leaderNameSnapshot),
              cropId: Value<String?>(data.cropId),
              cropNameSnapshot: Value<String?>(data.cropNameSnapshot),
              taskId: Value<String?>(data.taskId),
              taskCodeSnapshot: Value<String?>(snapshots.taskCodeSnapshot),
              taskNameSnapshot: Value<String?>(data.taskNameSnapshot),
              taskDetail: Value<String?>(data.taskDetail),
              lot: Value<String?>(data.lot),
              network: Value<String?>(data.network),
              scheduledWage: Value<double?>(data.scheduledWage),
              realWage: Value<double?>(data.realWage),
              ha: Value<double>(data.ha),
              ratio: Value<double?>(data.ratio),
              diningRoomId: Value<String?>(data.diningRoomId),
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
    String? currentDepartmentId,
  }) async {
    final existing = await getRecordById(recordId);

    if (existing == null || !existing.isActive) {
      throw Exception('El registro no existe.');
    }

    if (!isAdmin && existing.createdByUserId != currentUserId) {
      throw Exception('No puede editar registros de otro usuario.');
    }

    if (!isAdmin &&
        (currentDepartmentId == null ||
            existing.departmentId != currentDepartmentId)) {
      throw Exception('Este registro no pertenece al departamento activo.');
    }

    final now = DateTime.now();

    if (!isAdmin) {
      await _updateRealWageOnly(
        recordId: recordId,
        realWage: data.realWage,
        observation: data.observation,
        now: now,
      );
      return;
    }

    final snapshots = await _resolveRecordSaveSnapshots(data);

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
          leaderOperatorId: Value<String?>(data.operatorId),
          leaderCodeSnapshot: Value<String?>(snapshots.leaderCodeSnapshot),
          leaderNameSnapshot: Value<String?>(snapshots.leaderNameSnapshot),
          cropId: Value<String?>(data.cropId),
          cropNameSnapshot: Value<String?>(data.cropNameSnapshot),
          taskId: Value<String?>(data.taskId),
          taskCodeSnapshot: Value<String?>(snapshots.taskCodeSnapshot),
          taskNameSnapshot: Value<String?>(data.taskNameSnapshot),
          taskDetail: Value<String?>(data.taskDetail),
          lot: Value<String?>(data.lot),
          network: Value<String?>(data.network),
          scheduledWage: Value<double?>(data.scheduledWage),
          realWage: Value<double?>(data.realWage),
          ha: Value<double>(data.ha),
          ratio: Value<double?>(data.ratio),
          diningRoomId: Value<String?>(data.diningRoomId),
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

  Future<void> _updateRealWageOnly({
    required String recordId,
    required double? realWage,
    required String? observation,
    required DateTime now,
  }) async {
    await (_database.update(
      _database.records,
    )..where((tbl) => tbl.id.equals(recordId))).write(
      RecordsCompanion(
        realWage: Value<double?>(realWage),
        observation: Value<String?>(observation),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatuses.pending),
      ),
    );
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
              lotSnapshot: AgroLocalValueFormatters.compactLot(location.lot),
              networkSnapshot: AgroLocalValueFormatters.compactNetwork(
                location.network,
              ),
              sectorSnapshot: AgroLocalValueFormatters.compactSector(
                location.sector,
              ),
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

String _normalizeText(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ü', 'u');
}

class _RecordSaveSnapshots {
  const _RecordSaveSnapshots({
    required this.leaderCodeSnapshot,
    required this.leaderNameSnapshot,
    required this.taskCodeSnapshot,
  });

  final String? leaderCodeSnapshot;
  final String? leaderNameSnapshot;
  final String? taskCodeSnapshot;
}

class _DevelopmentField {
  const _DevelopmentField(
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
