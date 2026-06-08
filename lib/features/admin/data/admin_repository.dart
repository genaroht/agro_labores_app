import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';

class AdminRepository {
  const AdminRepository(this._database);

  final AppDatabase _database;

  Future<void> ensureDemoData() {
    return _database.seedDemoData();
  }

  Future<List<LocalRole>> getRoles() {
    return (_database.select(_database.roles)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<List<LocalUser>> getUsers() {
    return (_database.select(_database.users)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.fullName)]))
        .get();
  }

  Future<List<Department>> getDepartments() {
    return (_database.select(_database.departments)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<List<String>> getDepartmentIdsForUser(String userId) async {
    final rows =
        await (_database.select(_database.userDepartments)..where(
              (tbl) => tbl.userId.equals(userId) & tbl.deletedAt.isNull(),
            ))
            .get();

    return rows.map((item) => item.departmentId).toList();
  }

  Future<void> saveUser({
    required LocalUser? existing,
    required String code,
    required String fullName,
    required String passwordPin,
    required String roleId,
    required bool isActive,
    required List<String> departmentIds,
  }) async {
    if (code.trim().isEmpty) {
      throw Exception('Ingrese código.');
    }

    if (fullName.trim().isEmpty) {
      throw Exception('Ingrese nombre.');
    }

    if (!RegExp(r'^\d{6}$').hasMatch(passwordPin)) {
      throw Exception('La contraseña debe tener 6 dígitos.');
    }

    if (roleId.trim().isEmpty) {
      throw Exception('Seleccione rol.');
    }

    if (departmentIds.isEmpty) {
      throw Exception('Seleccione al menos un departamento.');
    }

    final now = DateTime.now();
    final userId = existing?.id ?? 'user_${now.microsecondsSinceEpoch}';

    await _database.transaction(() async {
      if (existing == null) {
        await _database
            .into(_database.users)
            .insert(
              UsersCompanion.insert(
                id: userId,
                code: code.trim(),
                fullName: fullName.trim(),
                passwordPin: passwordPin.trim(),
                roleId: roleId,
                isActive: Value(isActive),
                createdAt: Value(now),
                updatedAt: Value(now),
                syncStatus: const Value(SyncStatuses.pending),
              ),
            );
      } else {
        await (_database.update(
          _database.users,
        )..where((tbl) => tbl.id.equals(userId))).write(
          UsersCompanion(
            code: Value(code.trim()),
            fullName: Value(fullName.trim()),
            passwordPin: Value(passwordPin.trim()),
            roleId: Value(roleId),
            isActive: Value(isActive),
            updatedAt: Value(now),
            syncStatus: const Value(SyncStatuses.pending),
          ),
        );
      }

      await (_database.update(
            _database.userDepartments,
          )..where((tbl) => tbl.userId.equals(userId) & tbl.deletedAt.isNull()))
          .write(
            UserDepartmentsCompanion(
              deletedAt: Value<DateTime?>(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatuses.pending),
            ),
          );

      for (final departmentId in departmentIds) {
        await _database
            .into(_database.userDepartments)
            .insertOnConflictUpdate(
              UserDepartmentsCompanion.insert(
                id: '${userId}_$departmentId',
                userId: userId,
                departmentId: departmentId,
                createdAt: Value(now),
                updatedAt: Value(now),
                deletedAt: const Value<DateTime?>(null),
                syncStatus: const Value(SyncStatuses.pending),
              ),
            );
      }
    });
  }

  Future<void> deleteUser(LocalUser user) async {
    final now = DateTime.now();

    await (_database.update(
      _database.users,
    )..where((tbl) => tbl.id.equals(user.id))).write(
      UsersCompanion(
        isActive: const Value(false),
        deletedAt: Value<DateTime?>(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatuses.pending),
      ),
    );
  }

  Future<void> saveDepartment({
    required Department? existing,
    required String name,
    required bool isActive,
  }) async {
    if (name.trim().isEmpty) {
      throw Exception('Ingrese nombre del departamento.');
    }

    final now = DateTime.now();

    if (existing == null) {
      await _database
          .into(_database.departments)
          .insert(
            DepartmentsCompanion.insert(
              id: 'dep_${now.microsecondsSinceEpoch}',
              name: name.trim(),
              isActive: Value(isActive),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatuses.pending),
            ),
          );
    } else {
      await (_database.update(
        _database.departments,
      )..where((tbl) => tbl.id.equals(existing.id))).write(
        DepartmentsCompanion(
          name: Value(name.trim()),
          isActive: Value(isActive),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatuses.pending),
        ),
      );
    }
  }

  Future<void> deleteDepartment(Department department) async {
    final now = DateTime.now();

    await (_database.update(
      _database.departments,
    )..where((tbl) => tbl.id.equals(department.id))).write(
      DepartmentsCompanion(
        isActive: const Value(false),
        deletedAt: Value<DateTime?>(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatuses.pending),
      ),
    );
  }

  Future<List<FarmOperator>> getOperators() {
    return (_database.select(_database.operators)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.fullName)]))
        .get();
  }

  Future<void> saveOperator({
    required FarmOperator? existing,
    required String code,
    required String fullName,
    required String? departmentId,
    required bool isActive,
  }) async {
    if (code.trim().isEmpty) {
      throw Exception('Ingrese código.');
    }

    if (fullName.trim().isEmpty) {
      throw Exception('Ingrese nombre del operario.');
    }

    final now = DateTime.now();

    if (existing == null) {
      await _database
          .into(_database.operators)
          .insert(
            OperatorsCompanion.insert(
              id: 'op_${now.microsecondsSinceEpoch}',
              code: code.trim(),
              fullName: fullName.trim(),
              departmentId: Value<String?>(departmentId),
              isActive: Value(isActive),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatuses.pending),
            ),
          );
    } else {
      await (_database.update(
        _database.operators,
      )..where((tbl) => tbl.id.equals(existing.id))).write(
        OperatorsCompanion(
          code: Value(code.trim()),
          fullName: Value(fullName.trim()),
          departmentId: Value<String?>(departmentId),
          isActive: Value(isActive),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatuses.pending),
        ),
      );
    }
  }

  Future<void> deleteOperator(FarmOperator operator) async {
    final now = DateTime.now();

    await (_database.update(
      _database.operators,
    )..where((tbl) => tbl.id.equals(operator.id))).write(
      OperatorsCompanion(
        isActive: const Value(false),
        deletedAt: Value<DateTime?>(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatuses.pending),
      ),
    );
  }

  Future<List<Crop>> getCrops() {
    return (_database.select(_database.crops)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<void> saveCrop({
    required Crop? existing,
    required String name,
    required bool isActive,
  }) async {
    if (name.trim().isEmpty) {
      throw Exception('Ingrese nombre del cultivo.');
    }

    final now = DateTime.now();

    if (existing == null) {
      await _database
          .into(_database.crops)
          .insert(
            CropsCompanion.insert(
              id: 'crop_${now.microsecondsSinceEpoch}',
              name: name.trim(),
              isActive: Value(isActive),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatuses.pending),
            ),
          );
    } else {
      await (_database.update(
        _database.crops,
      )..where((tbl) => tbl.id.equals(existing.id))).write(
        CropsCompanion(
          name: Value(name.trim()),
          isActive: Value(isActive),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatuses.pending),
        ),
      );
    }
  }

  Future<void> deleteCrop(Crop crop) async {
    final now = DateTime.now();

    await (_database.update(
      _database.crops,
    )..where((tbl) => tbl.id.equals(crop.id))).write(
      CropsCompanion(
        isActive: const Value(false),
        deletedAt: Value<DateTime?>(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatuses.pending),
      ),
    );
  }

  Future<List<FarmTask>> getTasks() {
    return (_database.select(_database.tasks)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<void> saveTask({
    required FarmTask? existing,
    required String name,
    required String? departmentId,
    required String? defaultDetail,
    required bool isActive,
  }) async {
    if (name.trim().isEmpty) {
      throw Exception('Ingrese nombre de labor.');
    }

    final now = DateTime.now();

    if (existing == null) {
      await _database
          .into(_database.tasks)
          .insert(
            TasksCompanion.insert(
              id: 'task_${now.microsecondsSinceEpoch}',
              departmentId: Value<String?>(departmentId),
              name: name.trim(),
              defaultDetail: Value<String?>(defaultDetail),
              isActive: Value(isActive),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatuses.pending),
            ),
          );
    } else {
      await (_database.update(
        _database.tasks,
      )..where((tbl) => tbl.id.equals(existing.id))).write(
        TasksCompanion(
          departmentId: Value<String?>(departmentId),
          name: Value(name.trim()),
          defaultDetail: Value<String?>(defaultDetail),
          isActive: Value(isActive),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatuses.pending),
        ),
      );
    }
  }

  Future<void> deleteTask(FarmTask task) async {
    final now = DateTime.now();

    await (_database.update(
      _database.tasks,
    )..where((tbl) => tbl.id.equals(task.id))).write(
      TasksCompanion(
        isActive: const Value(false),
        deletedAt: Value<DateTime?>(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatuses.pending),
      ),
    );
  }

  Future<List<LocationEntry>> getLocations() {
    return (_database.select(_database.locations)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.lot),
            (tbl) => OrderingTerm.asc(tbl.network),
            (tbl) => OrderingTerm.asc(tbl.sector),
          ]))
        .get();
  }

  Future<void> saveLocation({
    required LocationEntry? existing,
    required String cropId,
    required String lot,
    required String network,
    required String sector,
    required double ha,
    required String? suggestedDiningRoom,
    required bool isActive,
  }) async {
    if (cropId.trim().isEmpty) {
      throw Exception('Seleccione cultivo.');
    }

    if (lot.trim().isEmpty) {
      throw Exception('Ingrese lote.');
    }

    if (network.trim().isEmpty) {
      throw Exception('Ingrese red.');
    }

    if (sector.trim().isEmpty) {
      throw Exception('Ingrese sector.');
    }

    if (ha <= 0) {
      throw Exception('Ha debe ser mayor a cero.');
    }

    final now = DateTime.now();

    if (existing == null) {
      await _database
          .into(_database.locations)
          .insert(
            LocationsCompanion.insert(
              id: 'loc_${now.microsecondsSinceEpoch}',
              cropId: cropId,
              lot: lot.trim(),
              network: network.trim(),
              sector: sector.trim(),
              ha: ha,
              suggestedDiningRoom: Value<String?>(suggestedDiningRoom),
              isActive: Value(isActive),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatuses.pending),
            ),
          );
    } else {
      await (_database.update(
        _database.locations,
      )..where((tbl) => tbl.id.equals(existing.id))).write(
        LocationsCompanion(
          cropId: Value(cropId),
          lot: Value(lot.trim()),
          network: Value(network.trim()),
          sector: Value(sector.trim()),
          ha: Value(ha),
          suggestedDiningRoom: Value<String?>(suggestedDiningRoom),
          isActive: Value(isActive),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatuses.pending),
        ),
      );
    }
  }

  Future<void> deleteLocation(LocationEntry location) async {
    final now = DateTime.now();

    await (_database.update(
      _database.locations,
    )..where((tbl) => tbl.id.equals(location.id))).write(
      LocationsCompanion(
        isActive: const Value(false),
        deletedAt: Value<DateTime?>(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatuses.pending),
      ),
    );
  }

  Future<List<FarmRecord>> getFilteredRecords({
    String? departmentId,
    String? cropId,
    String? taskId,
    String? operatorId,
    String? lot,
    String? network,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final query = _database.select(_database.records)
      ..where((tbl) => tbl.deletedAt.isNull() & tbl.isActive.equals(true))
      ..orderBy([
        (tbl) => OrderingTerm.desc(tbl.recordDate),
        (tbl) => OrderingTerm.desc(tbl.createdAt),
      ]);

    if (departmentId != null) {
      query.where((tbl) => tbl.departmentId.equals(departmentId));
    }

    if (cropId != null) {
      query.where((tbl) => tbl.cropId.equals(cropId));
    }

    if (taskId != null) {
      query.where((tbl) => tbl.taskId.equals(taskId));
    }

    if (operatorId != null) {
      query.where((tbl) => tbl.operatorId.equals(operatorId));
    }

    if (lot != null && lot.trim().isNotEmpty) {
      query.where((tbl) => tbl.lot.equals(lot));
    }

    if (network != null && network.trim().isNotEmpty) {
      query.where((tbl) => tbl.network.equals(network));
    }

    final records = await query.get();

    return records.where((record) {
      if (dateFrom != null && record.recordDate.isBefore(dateFrom)) {
        return false;
      }

      if (dateTo != null) {
        final endOfDateTo = DateTime(
          dateTo.year,
          dateTo.month,
          dateTo.day,
          23,
          59,
          59,
        );

        if (record.recordDate.isAfter(endOfDateTo)) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return AdminRepository(database);
});
