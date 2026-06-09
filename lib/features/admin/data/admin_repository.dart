import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_environment.dart';
import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';

class AdminRepository {
  const AdminRepository(this._database);

  final AppDatabase _database;

  Future<void> ensureDevelopmentSeedData() async {
    if (!AppEnvironment.enableDevelopmentSeed) {
      return;
    }

    await _database.seedDevelopmentData();
  }

  Future<List<LocalRole>> getRoles() {
    return (_database.select(_database.roles)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<List<OperatorPosition>> getPositions() {
    return (_database.select(_database.positions)
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

  Future<List<Department>> getDepartmentsForSupervisor(
    List<String> departmentIds,
  ) async {
    if (departmentIds.isEmpty) {
      return [];
    }

    final departments = await getDepartments();

    return departments
        .where((department) => departmentIds.contains(department.id))
        .toList();
  }

  Future<List<String>> getDepartmentIdsForUser(String userId) async {
    final rows =
        await (_database.select(_database.userDepartments)..where(
              (tbl) => tbl.userId.equals(userId) & tbl.deletedAt.isNull(),
            ))
            .get();

    return rows.map((item) => item.departmentId).toList();
  }

  Future<LocalUser?> getUserById(String userId) {
    return (_database.select(
      _database.users,
    )..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
  }

  Future<FarmOperator?> getOperatorById(String operatorId) {
    return (_database.select(
      _database.operators,
    )..where((tbl) => tbl.id.equals(operatorId))).getSingleOrNull();
  }

  Future<Department?> getDepartmentById(String departmentId) {
    return (_database.select(
      _database.departments,
    )..where((tbl) => tbl.id.equals(departmentId))).getSingleOrNull();
  }

  Future<Crop?> getCropById(String cropId) {
    return (_database.select(
      _database.crops,
    )..where((tbl) => tbl.id.equals(cropId))).getSingleOrNull();
  }

  Future<OperatorPosition?> getPositionById(String positionId) {
    return (_database.select(
      _database.positions,
    )..where((tbl) => tbl.id.equals(positionId))).getSingleOrNull();
  }

  Future<FarmOperator?> getOperatorByCodeIncludingDeleted(String code) {
    return (_database.select(
      _database.operators,
    )..where((tbl) => tbl.code.equals(code.trim()))).getSingleOrNull();
  }

  Future<void> saveUser({
    required LocalUser? existing,
    required String code,
    required String fullName,
    required String passwordPin,
    required String roleId,
    required bool isActive,
    required List<String> departmentIds,
    String? operatorId,
  }) async {
    final role = await _database.getRoleById(roleId);

    if (role == null) {
      throw Exception('Seleccione un cargo/acceso válido.');
    }

    FarmOperator? linkedOperator;

    if (operatorId != null && operatorId.trim().isNotEmpty) {
      linkedOperator = await getOperatorById(operatorId.trim());

      if (linkedOperator == null || linkedOperator.deletedAt != null) {
        throw Exception('Seleccione una persona/operario válido.');
      }

      if (!linkedOperator.isActive) {
        throw Exception('La persona/operario seleccionado está inactivo.');
      }
    }

    final cleanCode = linkedOperator?.code ?? code.trim();
    final cleanFullName = linkedOperator?.fullName.trim() ?? fullName.trim();
    final cleanPin = passwordPin.trim();

    if (cleanCode.toLowerCase() == 'admin') {
      throw Exception('El código de usuario debe ser numérico, no "admin".');
    }

    if (!RegExp(r'^\d{6}$').hasMatch(cleanCode)) {
      throw Exception('Ingrese un código de usuario válido.');
    }

    if (cleanFullName.isEmpty) {
      throw Exception('Ingrese nombre completo.');
    }

    if (existing == null && !RegExp(r'^\d{6}$').hasMatch(cleanPin)) {
      throw Exception('Ingrese una contraseña válida.');
    }

    if (existing != null &&
        cleanPin.isNotEmpty &&
        !RegExp(r'^\d{6}$').hasMatch(cleanPin)) {
      throw Exception('Ingrese una contraseña válida.');
    }

    final duplicateUser = await _database.getUserByCodeIncludingInactive(
      cleanCode,
    );

    if (duplicateUser != null && duplicateUser.id != existing?.id) {
      throw Exception('Ya existe un usuario con ese código.');
    }

    final normalizedDepartmentIds = <String>{...departmentIds};

    if (linkedOperator?.departmentId != null && !role.isAdmin) {
      normalizedDepartmentIds.add(linkedOperator!.departmentId!);
    }

    if (!role.isAdmin && normalizedDepartmentIds.isEmpty) {
      throw Exception('Un supervisor debe tener al menos un departamento.');
    }

    for (final departmentId in normalizedDepartmentIds) {
      final department = await getDepartmentById(departmentId);

      if (department == null || department.deletedAt != null) {
        throw Exception('Hay un departamento asignado que ya no existe.');
      }
    }

    final now = DateTime.now();
    final userId = existing?.id ?? 'user_${now.microsecondsSinceEpoch}';
    final effectivePin = existing == null
        ? cleanPin
        : cleanPin.isEmpty
        ? existing.passwordPin
        : cleanPin;

    await _database.transaction(() async {
      if (existing == null) {
        await _database
            .into(_database.users)
            .insert(
              UsersCompanion.insert(
                id: userId,
                code: cleanCode,
                fullName: cleanFullName,
                passwordPin: effectivePin,
                roleId: roleId,
                operatorId: Value<String?>(linkedOperator?.id),
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
            code: Value(cleanCode),
            fullName: Value(cleanFullName),
            passwordPin: Value(effectivePin),
            roleId: Value(roleId),
            operatorId: Value<String?>(linkedOperator?.id),
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

      if (!role.isAdmin) {
        for (final departmentId in normalizedDepartmentIds) {
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
    final cleanName = name.trim();

    if (cleanName.isEmpty) {
      throw Exception('Ingrese nombre del cultivo.');
    }

    final crops = await getCrops();
    final duplicate = crops.any(
      (crop) =>
          crop.id != existing?.id &&
          crop.name.trim().toLowerCase() == cleanName.toLowerCase(),
    );

    if (duplicate) {
      throw Exception('Ya existe un cultivo con ese nombre.');
    }

    final now = DateTime.now();

    if (existing == null) {
      await _database
          .into(_database.crops)
          .insert(
            CropsCompanion.insert(
              id: 'crop_${now.microsecondsSinceEpoch}',
              name: cleanName,
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
          name: Value(cleanName),
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

  Future<void> saveDepartment({
    required Department? existing,
    required String name,
    required String cropId,
    required bool isActive,
  }) async {
    final cleanName = name.trim();

    if (cleanName.isEmpty) {
      throw Exception('Ingrese nombre del departamento.');
    }

    if (cropId.trim().isEmpty) {
      throw Exception('Seleccione cultivo.');
    }

    final crop = await getCropById(cropId.trim());

    if (crop == null || crop.deletedAt != null || !crop.isActive) {
      throw Exception('Seleccione un cultivo activo.');
    }

    final departments = await getDepartments();
    final duplicate = departments.any(
      (department) =>
          department.id != existing?.id &&
          department.name.trim().toLowerCase() == cleanName.toLowerCase(),
    );

    if (duplicate) {
      throw Exception('Ya existe un departamento con ese nombre.');
    }

    final now = DateTime.now();

    if (existing == null) {
      await _database
          .into(_database.departments)
          .insert(
            DepartmentsCompanion.insert(
              id: 'dep_${now.microsecondsSinceEpoch}',
              name: cleanName,
              cropId: Value(crop.id),
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
          name: Value(cleanName),
          cropId: Value(crop.id),
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

  Future<List<FarmOperator>> getOperators({
    List<String>? allowedDepartmentIds,
  }) async {
    final query = _database.select(_database.operators)
      ..where((tbl) => tbl.deletedAt.isNull())
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.fullName)]);

    final operators = await query.get();

    if (allowedDepartmentIds == null) {
      return operators;
    }

    return operators
        .where(
          (operator) =>
              operator.departmentId != null &&
              allowedDepartmentIds.contains(operator.departmentId),
        )
        .toList();
  }

  Future<void> saveOperator({
    required FarmOperator? existing,
    required String code,
    required String fullName,
    required String departmentId,
    required String positionId,
    required bool isActive,
    required bool isAdmin,
    required List<String> allowedDepartmentIds,
  }) async {
    final cleanCode = code.trim();
    final cleanFullName = fullName.trim();
    final cleanDepartmentId = departmentId.trim();
    final cleanPositionId = positionId.trim();

    if (!RegExp(r'^\d{6}$').hasMatch(cleanCode)) {
      throw Exception('Ingrese un código válido.');
    }

    if (cleanFullName.isEmpty) {
      throw Exception('Ingrese nombre completo de la persona.');
    }

    if (cleanDepartmentId.isEmpty) {
      throw Exception('Seleccione departamento.');
    }

    if (cleanPositionId.isEmpty) {
      throw Exception('Seleccione cargo.');
    }

    if (!isAdmin && !allowedDepartmentIds.contains(cleanDepartmentId)) {
      throw Exception(
        'Solo puede crear personas en sus departamentos asignados.',
      );
    }

    final department = await getDepartmentById(cleanDepartmentId);

    if (department == null ||
        department.deletedAt != null ||
        !department.isActive) {
      throw Exception('Seleccione un departamento activo.');
    }

    final position = await getPositionById(cleanPositionId);

    if (position == null || position.deletedAt != null || !position.isActive) {
      throw Exception('Seleccione un cargo activo.');
    }

    final duplicateOperator = await getOperatorByCodeIncludingDeleted(
      cleanCode,
    );

    if (duplicateOperator != null && duplicateOperator.id != existing?.id) {
      throw Exception('Ya existe una persona/operario con ese código.');
    }

    final now = DateTime.now();

    if (existing == null) {
      await _database
          .into(_database.operators)
          .insert(
            OperatorsCompanion.insert(
              id: 'op_${now.microsecondsSinceEpoch}',
              code: cleanCode,
              fullName: cleanFullName,
              departmentId: Value<String?>(cleanDepartmentId),
              positionId: Value<String?>(cleanPositionId),
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
          code: Value(cleanCode),
          fullName: Value(cleanFullName),
          departmentId: Value<String?>(cleanDepartmentId),
          positionId: Value<String?>(cleanPositionId),
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

  Future<List<FarmTask>> getTasks() {
    return (_database.select(_database.tasks)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.departmentId),
            (tbl) => OrderingTerm.asc(tbl.code),
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();
  }

  Future<void> saveTask({
    required FarmTask? existing,
    required String code,
    required String name,
    required String departmentId,
    required String? defaultDetail,
    required bool isActive,
  }) async {
    final cleanCode = code.trim();
    final cleanName = name.trim();
    final cleanDepartmentId = departmentId.trim();
    final cleanDefaultDetail = defaultDetail?.trim();

    if (cleanDepartmentId.isEmpty) {
      throw Exception('Seleccione departamento.');
    }

    if (cleanCode.isEmpty) {
      throw Exception('Ingrese código de labor.');
    }

    if (cleanName.isEmpty) {
      throw Exception('Ingrese descripción de labor.');
    }

    final department = await getDepartmentById(cleanDepartmentId);

    if (department == null ||
        department.deletedAt != null ||
        !department.isActive) {
      throw Exception('Seleccione un departamento activo.');
    }

    final cropId = department.cropId;

    if (cropId == null || cropId.trim().isEmpty) {
      throw Exception(
        'El departamento seleccionado no tiene cultivo asociado.',
      );
    }

    final crop = await getCropById(cropId);

    if (crop == null || crop.deletedAt != null || !crop.isActive) {
      throw Exception('El cultivo del departamento no está activo.');
    }

    final tasks = await getTasks();
    final duplicate = tasks.any(
      (task) =>
          task.id != existing?.id &&
          task.departmentId == cleanDepartmentId &&
          (task.code ?? '').trim().toLowerCase() == cleanCode.toLowerCase(),
    );

    if (duplicate) {
      throw Exception('Ya existe una labor con ese código en el departamento.');
    }

    final now = DateTime.now();

    if (existing == null) {
      await _database
          .into(_database.tasks)
          .insert(
            TasksCompanion.insert(
              id: 'task_${now.microsecondsSinceEpoch}',
              departmentId: Value<String?>(cleanDepartmentId),
              cropId: Value<String?>(cropId),
              code: Value<String?>(cleanCode),
              name: cleanName,
              defaultDetail: Value<String?>(
                cleanDefaultDetail == null || cleanDefaultDetail.isEmpty
                    ? null
                    : cleanDefaultDetail,
              ),
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
          departmentId: Value<String?>(cleanDepartmentId),
          cropId: Value<String?>(cropId),
          code: Value<String?>(cleanCode),
          name: Value(cleanName),
          defaultDetail: Value<String?>(
            cleanDefaultDetail == null || cleanDefaultDetail.isEmpty
                ? null
                : cleanDefaultDetail,
          ),
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

  Future<List<DiningRoom>> getDiningRooms() {
    return (_database.select(_database.diningRooms)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.cropId),
            (tbl) => OrderingTerm.asc(tbl.lot),
            (tbl) => OrderingTerm.asc(tbl.network),
            (tbl) => OrderingTerm.asc(tbl.name),
          ]))
        .get();
  }

  Future<void> saveDiningRoom({
    required DiningRoom? existing,
    required String name,
    required String cropId,
    required String lot,
    required String network,
    required bool isActive,
  }) async {
    final cleanName = name.trim();
    final cleanCropId = cropId.trim();
    final cleanLot = AgroLocalValueFormatters.compactLot(lot.trim());
    final cleanNetwork = AgroLocalValueFormatters.compactNetwork(
      network.trim(),
    );

    if (cleanName.isEmpty) {
      throw Exception('Ingrese nombre del comedor.');
    }

    if (cleanCropId.isEmpty) {
      throw Exception('Seleccione cultivo.');
    }

    if (cleanLot.isEmpty) {
      throw Exception('Ingrese lote.');
    }

    if (cleanNetwork.isEmpty) {
      throw Exception('Ingrese red.');
    }

    final crop = await getCropById(cleanCropId);

    if (crop == null || crop.deletedAt != null || !crop.isActive) {
      throw Exception('Seleccione un cultivo activo.');
    }

    final diningRooms = await getDiningRooms();
    final duplicate = diningRooms.any(
      (diningRoom) =>
          diningRoom.id != existing?.id &&
          diningRoom.cropId == cleanCropId &&
          AgroLocalValueFormatters.compactLot(diningRoom.lot ?? '') ==
              cleanLot &&
          AgroLocalValueFormatters.compactNetwork(diningRoom.network ?? '') ==
              cleanNetwork &&
          diningRoom.name.trim().toLowerCase() == cleanName.toLowerCase(),
    );

    if (duplicate) {
      throw Exception(
        'Ya existe un comedor con ese nombre para el cultivo, lote y red.',
      );
    }

    final now = DateTime.now();

    if (existing == null) {
      await _database
          .into(_database.diningRooms)
          .insert(
            DiningRoomsCompanion.insert(
              id: 'dining_${now.microsecondsSinceEpoch}',
              cropId: cleanCropId,
              name: cleanName,
              lot: Value<String?>(cleanLot),
              network: Value<String?>(cleanNetwork),
              isActive: Value(isActive),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatuses.pending),
            ),
          );
    } else {
      await (_database.update(
        _database.diningRooms,
      )..where((tbl) => tbl.id.equals(existing.id))).write(
        DiningRoomsCompanion(
          cropId: Value(cleanCropId),
          name: Value(cleanName),
          lot: Value<String?>(cleanLot),
          network: Value<String?>(cleanNetwork),
          isActive: Value(isActive),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatuses.pending),
        ),
      );
    }
  }

  Future<void> deleteDiningRoom(DiningRoom diningRoom) async {
    final now = DateTime.now();

    await (_database.update(
      _database.diningRooms,
    )..where((tbl) => tbl.id.equals(diningRoom.id))).write(
      DiningRoomsCompanion(
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
      query.where(
        (tbl) =>
            tbl.operatorId.equals(operatorId) |
            tbl.leaderOperatorId.equals(operatorId),
      );
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
