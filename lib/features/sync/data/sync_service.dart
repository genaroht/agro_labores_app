// ignore_for_file: prefer_initializing_formals

import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/app_environment.dart';
import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import '../../settings/data/record_lock_config.dart';
import 'sync_api_client.dart';

class SyncRunResult {
  const SyncRunResult({
    required this.wasOnline,
    required this.uploaded,
    required this.downloaded,
    required this.failed,
    required this.message,
  });

  final bool wasOnline;
  final int uploaded;
  final int downloaded;
  final int failed;
  final String message;
}

class SyncDashboard {
  const SyncDashboard({
    required this.pendingRecords,
    required this.errorRecords,
    required this.pendingCatalogItems,
    required this.errorCatalogItems,
    required this.pendingQueueItems,
    required this.errorQueueItems,
    required this.lastSuccessfulSyncAt,
    required this.mockServerShouldFail,
  });

  final int pendingRecords;
  final int errorRecords;
  final int pendingCatalogItems;
  final int errorCatalogItems;
  final int pendingQueueItems;
  final int errorQueueItems;
  final DateTime? lastSuccessfulSyncAt;
  final bool mockServerShouldFail;
}

class SyncService {
  // Keep public constructor parameter names (`database`, `apiClient`,
  // `lockRepository`) for readability at provider call sites.
  SyncService({
    required AppDatabase database,
    required RemoteSyncApiClient apiClient,
    required RecordLockRepository lockRepository,
  }) : _database = database,
       _apiClient = apiClient,
       _lockRepository = lockRepository;

  static const _lastSuccessfulSyncKey = 'last_successful_sync_at';

  final AppDatabase _database;
  final RemoteSyncApiClient _apiClient;
  final RecordLockRepository _lockRepository;

  Future<SyncRunResult> synchronize() async {
    final online = await hasConnectivity();

    if (!online) {
      return const SyncRunResult(
        wasOnline: false,
        uploaded: 0,
        downloaded: 0,
        failed: 0,
        message: 'Sin conexión. Los cambios quedan pendientes en el celular.',
      );
    }

    await _rebuildQueueFromLocalChanges();

    final pushResult = await _pushQueue();

    var downloaded = 0;
    var pullFailed = false;

    try {
      downloaded = await _pullAndApplyChanges();
    } catch (_) {
      pullFailed = true;
    }

    if (pushResult.failed == 0 && !pullFailed) {
      await _saveLastSuccessfulSyncAt(DateTime.now());
    }

    final failed = pushResult.failed + (pullFailed ? 1 : 0);

    return SyncRunResult(
      wasOnline: true,
      uploaded: pushResult.uploaded,
      downloaded: downloaded,
      failed: failed,
      message: failed == 0
          ? 'Sincronización completada.'
          : 'Sincronización completada con errores. Se reintentará al volver la conexión.',
    );
  }

  Future<bool> hasConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }

  Future<SyncDashboard> getDashboard() async {
    final pendingRecords = await _countRecordsByStatus(SyncStatuses.pending);
    final errorRecords = await _countRecordsByStatus(SyncStatuses.error);
    final pendingCatalogItems = await _countCatalogsByStatus(
      SyncStatuses.pending,
    );
    final errorCatalogItems = await _countCatalogsByStatus(SyncStatuses.error);
    final pendingQueueItems = await _countQueueByStatus(SyncStatuses.pending);
    final errorQueueItems = await _countQueueByStatus(SyncStatuses.error);
    final lastSyncAt = await getLastSuccessfulSyncAt();

    var mockFail = false;

    if (_apiClient is MockRemoteSyncApiClient) {
      mockFail = await _apiClient.shouldFail();
    }

    return SyncDashboard(
      pendingRecords: pendingRecords,
      errorRecords: errorRecords,
      pendingCatalogItems: pendingCatalogItems,
      errorCatalogItems: errorCatalogItems,
      pendingQueueItems: pendingQueueItems,
      errorQueueItems: errorQueueItems,
      lastSuccessfulSyncAt: lastSyncAt,
      mockServerShouldFail: mockFail,
    );
  }

  Future<void> setMockServerFailure(bool value) async {
    if (_apiClient is MockRemoteSyncApiClient) {
      await _apiClient.setShouldFail(value);
    }
  }

  Future<DateTime?> getLastSuccessfulSyncAt() async {
    final prefs = await SharedPreferences.getInstance();
    final rawValue = prefs.getString(_lastSuccessfulSyncKey);

    if (rawValue == null || rawValue.isEmpty) {
      return null;
    }

    return DateTime.tryParse(rawValue);
  }

  Future<void> _saveLastSuccessfulSyncAt(DateTime value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSuccessfulSyncKey, value.toIso8601String());
  }

  Future<void> _rebuildQueueFromLocalChanges() async {
    await _queuePendingRoles();
    await _queuePendingCrops();
    await _queuePendingPositions();
    await _queuePendingDepartments();
    await _queuePendingOperators();
    await _queuePendingUsers();
    await _queuePendingUserDepartments();
    await _queuePendingTasks();
    await _queuePendingLocations();
    await _queuePendingDiningRooms();
    await _queuePendingRecords();
    await _queuePendingFormFields();
    await _queuePendingTableColumns();
  }

  Future<void> _queuePendingRoles() async {
    final rows = await (_database.select(
      _database.roles,
    )..where(_pendingOrErrorRole)).get();

    for (final row in rows) {
      await _queueLocalChange(
        entityType: 'role',
        entityId: row.id,
        operation: _operationFor(serverId: null, deletedAt: row.deletedAt),
        payload: _rolePayload(row),
      );
    }
  }

  Future<void> _queuePendingCrops() async {
    final rows = await (_database.select(
      _database.crops,
    )..where(_pendingOrErrorCrop)).get();

    for (final row in rows) {
      await _queueLocalChange(
        entityType: 'crop',
        entityId: row.id,
        operation: _operationFor(
          serverId: row.serverId,
          deletedAt: row.deletedAt,
        ),
        payload: _cropPayload(row),
      );
    }
  }

  Future<void> _queuePendingPositions() async {
    final rows = await (_database.select(
      _database.positions,
    )..where(_pendingOrErrorPosition)).get();

    for (final row in rows) {
      await _queueLocalChange(
        entityType: 'position',
        entityId: row.id,
        operation: _operationFor(
          serverId: row.serverId,
          deletedAt: row.deletedAt,
        ),
        payload: _positionPayload(row),
      );
    }
  }

  Future<void> _queuePendingDepartments() async {
    final rows = await (_database.select(
      _database.departments,
    )..where(_pendingOrErrorDepartment)).get();

    for (final row in rows) {
      await _queueLocalChange(
        entityType: 'department',
        entityId: row.id,
        operation: _operationFor(
          serverId: row.serverId,
          deletedAt: row.deletedAt,
        ),
        payload: _departmentPayload(row),
      );
    }
  }

  Future<void> _queuePendingOperators() async {
    final rows = await (_database.select(
      _database.operators,
    )..where(_pendingOrErrorOperator)).get();

    for (final row in rows) {
      await _queueLocalChange(
        entityType: 'operator',
        entityId: row.id,
        operation: _operationFor(
          serverId: row.serverId,
          deletedAt: row.deletedAt,
        ),
        payload: _operatorPayload(row),
      );
    }
  }

  Future<void> _queuePendingUsers() async {
    final rows = await (_database.select(
      _database.users,
    )..where(_pendingOrErrorUser)).get();

    for (final row in rows) {
      await _queueLocalChange(
        entityType: 'user',
        entityId: row.id,
        operation: _operationFor(
          serverId: row.serverId,
          deletedAt: row.deletedAt,
        ),
        payload: _userPayload(row),
      );
    }
  }

  Future<void> _queuePendingUserDepartments() async {
    final rows = await (_database.select(
      _database.userDepartments,
    )..where(_pendingOrErrorUserDepartment)).get();

    for (final row in rows) {
      await _queueLocalChange(
        entityType: 'user_department',
        entityId: row.id,
        operation: _operationFor(serverId: null, deletedAt: row.deletedAt),
        payload: _userDepartmentPayload(row),
      );
    }
  }

  Future<void> _queuePendingTasks() async {
    final rows = await (_database.select(
      _database.tasks,
    )..where(_pendingOrErrorTask)).get();

    for (final row in rows) {
      await _queueLocalChange(
        entityType: 'task',
        entityId: row.id,
        operation: _operationFor(
          serverId: row.serverId,
          deletedAt: row.deletedAt,
        ),
        payload: _taskPayload(row),
      );
    }
  }

  Future<void> _queuePendingLocations() async {
    final rows = await (_database.select(
      _database.locations,
    )..where(_pendingOrErrorLocation)).get();

    for (final row in rows) {
      await _queueLocalChange(
        entityType: 'location',
        entityId: row.id,
        operation: _operationFor(
          serverId: row.serverId,
          deletedAt: row.deletedAt,
        ),
        payload: _locationPayload(row),
      );
    }
  }

  Future<void> _queuePendingDiningRooms() async {
    final rows = await (_database.select(
      _database.diningRooms,
    )..where(_pendingOrErrorDiningRoom)).get();

    for (final row in rows) {
      await _queueLocalChange(
        entityType: 'dining_room',
        entityId: row.id,
        operation: _operationFor(
          serverId: row.serverId,
          deletedAt: row.deletedAt,
        ),
        payload: _diningRoomPayload(row),
      );
    }
  }

  Future<void> _queuePendingRecords() async {
    final rows = await (_database.select(
      _database.records,
    )..where(_pendingOrErrorRecord)).get();

    for (final row in rows) {
      await _queueLocalChange(
        entityType: 'record',
        entityId: row.id,
        operation: _operationFor(
          serverId: row.serverId,
          deletedAt: row.deletedAt,
        ),
        payload: await _recordPayload(row),
      );
    }
  }

  Future<void> _queuePendingFormFields() async {
    final rows = await (_database.select(
      _database.formFieldConfigs,
    )..where(_pendingOrErrorFormField)).get();

    for (final row in rows) {
      await _queueLocalChange(
        entityType: 'form_field',
        entityId: row.id,
        operation: _operationFor(serverId: null, deletedAt: row.deletedAt),
        payload: _formFieldPayload(row),
      );
    }
  }

  Future<void> _queuePendingTableColumns() async {
    final rows = await (_database.select(
      _database.tableColumnConfigs,
    )..where(_pendingOrErrorTableColumn)).get();

    for (final row in rows) {
      await _queueLocalChange(
        entityType: 'table_column',
        entityId: row.id,
        operation: _operationFor(serverId: null, deletedAt: row.deletedAt),
        payload: _tableColumnPayload(row),
      );
    }
  }

  Expression<bool> _pendingOrErrorRole(Roles tbl) =>
      tbl.syncStatus.equals(SyncStatuses.pending) |
      tbl.syncStatus.equals(SyncStatuses.error);

  Expression<bool> _pendingOrErrorCrop(Crops tbl) =>
      tbl.syncStatus.equals(SyncStatuses.pending) |
      tbl.syncStatus.equals(SyncStatuses.error);

  Expression<bool> _pendingOrErrorPosition(Positions tbl) =>
      tbl.syncStatus.equals(SyncStatuses.pending) |
      tbl.syncStatus.equals(SyncStatuses.error);

  Expression<bool> _pendingOrErrorDepartment(Departments tbl) =>
      tbl.syncStatus.equals(SyncStatuses.pending) |
      tbl.syncStatus.equals(SyncStatuses.error);

  Expression<bool> _pendingOrErrorOperator(Operators tbl) =>
      tbl.syncStatus.equals(SyncStatuses.pending) |
      tbl.syncStatus.equals(SyncStatuses.error);

  Expression<bool> _pendingOrErrorUser(Users tbl) =>
      tbl.syncStatus.equals(SyncStatuses.pending) |
      tbl.syncStatus.equals(SyncStatuses.error);

  Expression<bool> _pendingOrErrorUserDepartment(UserDepartments tbl) =>
      tbl.syncStatus.equals(SyncStatuses.pending) |
      tbl.syncStatus.equals(SyncStatuses.error);

  Expression<bool> _pendingOrErrorTask(Tasks tbl) =>
      tbl.syncStatus.equals(SyncStatuses.pending) |
      tbl.syncStatus.equals(SyncStatuses.error);

  Expression<bool> _pendingOrErrorLocation(Locations tbl) =>
      tbl.syncStatus.equals(SyncStatuses.pending) |
      tbl.syncStatus.equals(SyncStatuses.error);

  Expression<bool> _pendingOrErrorDiningRoom(DiningRooms tbl) =>
      tbl.syncStatus.equals(SyncStatuses.pending) |
      tbl.syncStatus.equals(SyncStatuses.error);

  Expression<bool> _pendingOrErrorRecord(Records tbl) =>
      tbl.syncStatus.equals(SyncStatuses.pending) |
      tbl.syncStatus.equals(SyncStatuses.error);

  Expression<bool> _pendingOrErrorFormField(FormFieldConfigs tbl) =>
      tbl.syncStatus.equals(SyncStatuses.pending) |
      tbl.syncStatus.equals(SyncStatuses.error);

  Expression<bool> _pendingOrErrorTableColumn(TableColumnConfigs tbl) =>
      tbl.syncStatus.equals(SyncStatuses.pending) |
      tbl.syncStatus.equals(SyncStatuses.error);

  String _operationFor({
    required String? serverId,
    required DateTime? deletedAt,
  }) {
    if (deletedAt != null) {
      return 'delete';
    }

    return serverId == null || serverId.isEmpty ? 'create' : 'update';
  }

  Future<void> _queueLocalChange({
    required String entityType,
    required String entityId,
    required String operation,
    required Map<String, dynamic> payload,
  }) async {
    final now = DateTime.now();
    final payloadJson = jsonEncode(payload);
    final existing =
        await (_database.select(_database.syncQueueItems)
              ..where(
                (tbl) =>
                    tbl.entityType.equals(entityType) &
                    tbl.entityId.equals(entityId) &
                    tbl.deletedAt.isNull() &
                    (tbl.status.equals(SyncStatuses.pending) |
                        tbl.status.equals(SyncStatuses.error) |
                        tbl.status.equals(SyncStatuses.syncing)),
              )
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)])
              ..limit(1))
            .getSingleOrNull();

    if (existing != null) {
      if (existing.status == SyncStatuses.syncing) {
        return;
      }

      await (_database.update(
        _database.syncQueueItems,
      )..where((tbl) => tbl.id.equals(existing.id))).write(
        SyncQueueItemsCompanion(
          operation: Value(operation),
          payloadJson: Value(payloadJson),
          status: const Value(SyncStatuses.pending),
          lastError: const Value<String?>(null),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatuses.pending),
        ),
      );

      return;
    }

    await _database
        .into(_database.syncQueueItems)
        .insert(
          SyncQueueItemsCompanion.insert(
            id: 'queue_${entityType}_${entityId}_${now.microsecondsSinceEpoch}',
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payloadJson: payloadJson,
            status: const Value(SyncStatuses.pending),
            attempts: const Value(0),
            createdAt: Value(now),
            updatedAt: Value(now),
            syncStatus: const Value(SyncStatuses.pending),
          ),
        );
  }

  Future<_PushResult> _pushQueue() async {
    var uploaded = 0;
    var failed = 0;

    final queueItems =
        await (_database.select(_database.syncQueueItems)
              ..where(
                (tbl) =>
                    tbl.deletedAt.isNull() &
                    (tbl.status.equals(SyncStatuses.pending) |
                        tbl.status.equals(SyncStatuses.error)),
              )
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
            .get();

    for (final item in queueItems) {
      try {
        await _markQueueItemSyncing(item);

        final result = await _apiClient.uploadQueueItem(item);

        await _markEntitySynced(
          entityType: item.entityType,
          entityId: item.entityId,
          serverId: result.serverId,
        );

        await _markQueueItemSynced(item);
        uploaded++;
      } catch (error) {
        await _markEntityError(
          entityType: item.entityType,
          entityId: item.entityId,
        );
        await _markQueueItemError(item: item, error: error.toString());
        failed++;
      }
    }

    return _PushResult(uploaded: uploaded, failed: failed);
  }

  Future<int> _pullAndApplyChanges() async {
    final since = await getLastSuccessfulSyncAt();
    final bundle = await _apiClient.pullChanges(since: since);

    await _database.transaction(() async {
      await _applyRoles(bundle.roles);
      await _applyCrops(bundle.crops);
      await _applyPositions(bundle.positions);
      await _applyDepartments(bundle.departments);
      await _applyOperators(bundle.operators);
      await _applyUsers(bundle.users);
      await _applyUserDepartments(bundle.userDepartments);
      await _applyTasks(bundle.tasks);
      await _applyLocations(bundle.locations);
      await _applyDiningRooms(bundle.diningRooms);
      await _applyRecords(bundle.records);
      await _applyRecordLocations(bundle.recordLocations);
      await _applyFormFields(bundle.formFields);
      await _applyTableColumns(bundle.tableColumns);
    });

    for (final config in bundle.lockConfigs) {
      await _lockRepository.saveConfigFromServer(config);
    }

    return bundle.downloadedCount;
  }

  Future<void> _markQueueItemSyncing(SyncQueueItem item) async {
    final now = DateTime.now();

    await (_database.update(
      _database.syncQueueItems,
    )..where((tbl) => tbl.id.equals(item.id))).write(
      SyncQueueItemsCompanion(
        status: const Value(SyncStatuses.syncing),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatuses.syncing),
      ),
    );

    await _markEntityStatus(
      entityType: item.entityType,
      entityId: item.entityId,
      status: SyncStatuses.syncing,
      updatedAt: now,
    );
  }

  Future<void> _markQueueItemSynced(SyncQueueItem item) async {
    await (_database.update(
      _database.syncQueueItems,
    )..where((tbl) => tbl.id.equals(item.id))).write(
      SyncQueueItemsCompanion(
        status: const Value(SyncStatuses.synced),
        lastError: const Value<String?>(null),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatuses.synced),
      ),
    );
  }

  Future<void> _markQueueItemError({
    required SyncQueueItem item,
    required String error,
  }) async {
    await (_database.update(
      _database.syncQueueItems,
    )..where((tbl) => tbl.id.equals(item.id))).write(
      SyncQueueItemsCompanion(
        status: const Value(SyncStatuses.error),
        attempts: Value(item.attempts + 1),
        lastError: Value<String?>(error),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatuses.error),
      ),
    );
  }

  Future<void> _markEntitySynced({
    required String entityType,
    required String entityId,
    required String serverId,
  }) async {
    final now = DateTime.now();

    switch (entityType) {
      case 'crop':
        await (_database.update(
          _database.crops,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          CropsCompanion(
            serverId: Value<String?>(serverId),
            syncStatus: const Value(SyncStatuses.synced),
            updatedAt: Value(now),
          ),
        );
        break;
      case 'position':
        await (_database.update(
          _database.positions,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          PositionsCompanion(
            serverId: Value<String?>(serverId),
            syncStatus: const Value(SyncStatuses.synced),
            updatedAt: Value(now),
          ),
        );
        break;
      case 'department':
        await (_database.update(
          _database.departments,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          DepartmentsCompanion(
            serverId: Value<String?>(serverId),
            syncStatus: const Value(SyncStatuses.synced),
            updatedAt: Value(now),
          ),
        );
        break;
      case 'operator':
        await (_database.update(
          _database.operators,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          OperatorsCompanion(
            serverId: Value<String?>(serverId),
            syncStatus: const Value(SyncStatuses.synced),
            updatedAt: Value(now),
          ),
        );
        break;
      case 'user':
        await (_database.update(
          _database.users,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          UsersCompanion(
            serverId: Value<String?>(serverId),
            syncStatus: const Value(SyncStatuses.synced),
            updatedAt: Value(now),
          ),
        );
        break;
      case 'task':
        await (_database.update(
          _database.tasks,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          TasksCompanion(
            serverId: Value<String?>(serverId),
            syncStatus: const Value(SyncStatuses.synced),
            updatedAt: Value(now),
          ),
        );
        break;
      case 'location':
        await (_database.update(
          _database.locations,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          LocationsCompanion(
            serverId: Value<String?>(serverId),
            syncStatus: const Value(SyncStatuses.synced),
            updatedAt: Value(now),
          ),
        );
        break;
      case 'dining_room':
        await (_database.update(
          _database.diningRooms,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          DiningRoomsCompanion(
            serverId: Value<String?>(serverId),
            syncStatus: const Value(SyncStatuses.synced),
            updatedAt: Value(now),
          ),
        );
        break;
      case 'record':
        await (_database.update(
          _database.records,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          RecordsCompanion(
            serverId: Value<String?>(serverId),
            syncStatus: const Value(SyncStatuses.synced),
            updatedAt: Value(now),
          ),
        );
        await (_database.update(
          _database.recordLocations,
        )..where((tbl) => tbl.recordId.equals(entityId))).write(
          RecordLocationsCompanion(
            syncStatus: const Value(SyncStatuses.synced),
            updatedAt: Value(now),
          ),
        );
        break;
      default:
        await _markEntityStatus(
          entityType: entityType,
          entityId: entityId,
          status: SyncStatuses.synced,
          updatedAt: now,
        );
    }
  }

  Future<void> _markEntityError({
    required String entityType,
    required String entityId,
  }) async {
    await _markEntityStatus(
      entityType: entityType,
      entityId: entityId,
      status: SyncStatuses.error,
      updatedAt: DateTime.now(),
    );
  }

  Future<void> _markEntityStatus({
    required String entityType,
    required String entityId,
    required String status,
    required DateTime updatedAt,
  }) async {
    switch (entityType) {
      case 'role':
        await (_database.update(
          _database.roles,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          RolesCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        break;
      case 'crop':
        await (_database.update(
          _database.crops,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          CropsCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        break;
      case 'position':
        await (_database.update(
          _database.positions,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          PositionsCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        break;
      case 'department':
        await (_database.update(
          _database.departments,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          DepartmentsCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        break;
      case 'operator':
        await (_database.update(
          _database.operators,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          OperatorsCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        break;
      case 'user':
        await (_database.update(
          _database.users,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          UsersCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        break;
      case 'user_department':
        await (_database.update(
          _database.userDepartments,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          UserDepartmentsCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        break;
      case 'task':
        await (_database.update(
          _database.tasks,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          TasksCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        break;
      case 'location':
        await (_database.update(
          _database.locations,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          LocationsCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        break;
      case 'dining_room':
        await (_database.update(
          _database.diningRooms,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          DiningRoomsCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        break;
      case 'record':
        await (_database.update(
          _database.records,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          RecordsCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        await (_database.update(
          _database.recordLocations,
        )..where((tbl) => tbl.recordId.equals(entityId))).write(
          RecordLocationsCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        break;
      case 'record_location':
        await (_database.update(
          _database.recordLocations,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          RecordLocationsCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        break;
      case 'form_field':
        await (_database.update(
          _database.formFieldConfigs,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          FormFieldConfigsCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        break;
      case 'table_column':
        await (_database.update(
          _database.tableColumnConfigs,
        )..where((tbl) => tbl.id.equals(entityId))).write(
          TableColumnConfigsCompanion(
            syncStatus: Value(status),
            updatedAt: Value(updatedAt),
          ),
        );
        break;
    }
  }

  Future<int> _countRecordsByStatus(String status) async {
    final expression = _database.records.id.count();
    final query = _database.selectOnly(_database.records)
      ..addColumns([expression])
      ..where(_database.records.syncStatus.equals(status));
    final row = await query.getSingle();
    return row.read(expression) ?? 0;
  }

  Future<int> _countQueueByStatus(String status) async {
    final expression = _database.syncQueueItems.id.count();
    final query = _database.selectOnly(_database.syncQueueItems)
      ..addColumns([expression])
      ..where(
        _database.syncQueueItems.status.equals(status) &
            _database.syncQueueItems.deletedAt.isNull(),
      );
    final row = await query.getSingle();
    return row.read(expression) ?? 0;
  }

  Future<int> _countCatalogsByStatus(String status) async {
    final counts = await Future.wait<int>([
      _countByStatus(_database.crops.actualTableName, status),
      _countByStatus(_database.positions.actualTableName, status),
      _countByStatus(_database.departments.actualTableName, status),
      _countByStatus(_database.operators.actualTableName, status),
      _countByStatus(_database.users.actualTableName, status),
      _countByStatus(_database.userDepartments.actualTableName, status),
      _countByStatus(_database.tasks.actualTableName, status),
      _countByStatus(_database.locations.actualTableName, status),
      _countByStatus(_database.diningRooms.actualTableName, status),
      _countByStatus(_database.formFieldConfigs.actualTableName, status),
      _countByStatus(_database.tableColumnConfigs.actualTableName, status),
    ]);

    return counts.fold<int>(0, (total, count) => total + count);
  }

  Future<int> _countByStatus(String tableName, String status) async {
    final result = await _database
        .customSelect(
          'SELECT COUNT(*) AS total FROM $tableName WHERE sync_status = ?',
          variables: [Variable<String>(status)],
          readsFrom: {_database.syncQueueItems},
        )
        .getSingle();

    return result.data['total'] as int? ?? 0;
  }

  Future<void> _applyRoles(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final id = _string(item, 'id');
      if (id == null || id.isEmpty) continue;

      final local = await (_database.select(
        _database.roles,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (!_shouldApplyRemote(
        localSyncStatus: local?.syncStatus,
        localUpdatedAt: local?.updatedAt,
        remoteUpdatedAt: _dateTimeOrNull(item, 'updatedAt'),
      )) {
        continue;
      }

      await _database
          .into(_database.roles)
          .insertOnConflictUpdate(
            RolesCompanion.insert(
              id: id,
              name: _string(item, 'name') ?? local?.name ?? '',
              isAdmin: Value(
                _bool(item, 'isAdmin', fallback: local?.isAdmin ?? false),
              ),
              createdAt: Value(
                _dateTime(item, 'createdAt', fallback: local?.createdAt),
              ),
              updatedAt: Value(_dateTime(item, 'updatedAt')),
              deletedAt: Value<DateTime?>(_dateTimeOrNull(item, 'deletedAt')),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyCrops(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final id = _string(item, 'id');
      if (id == null || id.isEmpty) continue;

      final local = await (_database.select(
        _database.crops,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (!_shouldApplyRemote(
        localSyncStatus: local?.syncStatus,
        localUpdatedAt: local?.updatedAt,
        remoteUpdatedAt: _dateTimeOrNull(item, 'updatedAt'),
      )) {
        continue;
      }

      await _database
          .into(_database.crops)
          .insertOnConflictUpdate(
            CropsCompanion.insert(
              id: id,
              serverId: Value<String?>(_string(item, 'serverId')),
              name: _string(item, 'name') ?? local?.name ?? '',
              isActive: Value(
                _bool(item, 'isActive', fallback: local?.isActive ?? true),
              ),
              createdAt: Value(
                _dateTime(item, 'createdAt', fallback: local?.createdAt),
              ),
              updatedAt: Value(_dateTime(item, 'updatedAt')),
              deletedAt: Value<DateTime?>(_dateTimeOrNull(item, 'deletedAt')),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyPositions(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final id = _string(item, 'id');
      if (id == null || id.isEmpty) continue;

      final local = await (_database.select(
        _database.positions,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (!_shouldApplyRemote(
        localSyncStatus: local?.syncStatus,
        localUpdatedAt: local?.updatedAt,
        remoteUpdatedAt: _dateTimeOrNull(item, 'updatedAt'),
      )) {
        continue;
      }

      await _database
          .into(_database.positions)
          .insertOnConflictUpdate(
            PositionsCompanion.insert(
              id: id,
              serverId: Value<String?>(_string(item, 'serverId')),
              name: _string(item, 'name') ?? local?.name ?? '',
              canBeLeader: Value(
                _bool(
                  item,
                  'canBeLeader',
                  fallback: local?.canBeLeader ?? false,
                ),
              ),
              canLogin: Value(
                _bool(item, 'canLogin', fallback: local?.canLogin ?? false),
              ),
              isActive: Value(
                _bool(item, 'isActive', fallback: local?.isActive ?? true),
              ),
              createdAt: Value(
                _dateTime(item, 'createdAt', fallback: local?.createdAt),
              ),
              updatedAt: Value(_dateTime(item, 'updatedAt')),
              deletedAt: Value<DateTime?>(_dateTimeOrNull(item, 'deletedAt')),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyDepartments(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final id = _string(item, 'id');
      if (id == null || id.isEmpty) continue;

      final local = await (_database.select(
        _database.departments,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (!_shouldApplyRemote(
        localSyncStatus: local?.syncStatus,
        localUpdatedAt: local?.updatedAt,
        remoteUpdatedAt: _dateTimeOrNull(item, 'updatedAt'),
      )) {
        continue;
      }

      await _database
          .into(_database.departments)
          .insertOnConflictUpdate(
            DepartmentsCompanion.insert(
              id: id,
              serverId: Value<String?>(_string(item, 'serverId')),
              name: _string(item, 'name') ?? local?.name ?? '',
              cropId: Value<String?>(_string(item, 'cropId')),
              isActive: Value(
                _bool(item, 'isActive', fallback: local?.isActive ?? true),
              ),
              createdAt: Value(
                _dateTime(item, 'createdAt', fallback: local?.createdAt),
              ),
              updatedAt: Value(_dateTime(item, 'updatedAt')),
              deletedAt: Value<DateTime?>(_dateTimeOrNull(item, 'deletedAt')),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyOperators(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final id = _string(item, 'id');
      if (id == null || id.isEmpty) continue;

      final local = await (_database.select(
        _database.operators,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (!_shouldApplyRemote(
        localSyncStatus: local?.syncStatus,
        localUpdatedAt: local?.updatedAt,
        remoteUpdatedAt: _dateTimeOrNull(item, 'updatedAt'),
      )) {
        continue;
      }

      await _database
          .into(_database.operators)
          .insertOnConflictUpdate(
            OperatorsCompanion.insert(
              id: id,
              serverId: Value<String?>(_string(item, 'serverId')),
              code: _string(item, 'code') ?? local?.code ?? '000000',
              fullName: _string(item, 'fullName') ?? local?.fullName ?? '',
              departmentId: Value<String?>(_string(item, 'departmentId')),
              positionId: Value<String?>(_string(item, 'positionId')),
              isActive: Value(
                _bool(item, 'isActive', fallback: local?.isActive ?? true),
              ),
              createdAt: Value(
                _dateTime(item, 'createdAt', fallback: local?.createdAt),
              ),
              updatedAt: Value(_dateTime(item, 'updatedAt')),
              deletedAt: Value<DateTime?>(_dateTimeOrNull(item, 'deletedAt')),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyUsers(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final id = _string(item, 'id');
      if (id == null || id.isEmpty) continue;

      final local = await (_database.select(
        _database.users,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (!_shouldApplyRemote(
        localSyncStatus: local?.syncStatus,
        localUpdatedAt: local?.updatedAt,
        remoteUpdatedAt: _dateTimeOrNull(item, 'updatedAt'),
      )) {
        continue;
      }

      await _database
          .into(_database.users)
          .insertOnConflictUpdate(
            UsersCompanion.insert(
              id: id,
              serverId: Value<String?>(_string(item, 'serverId')),
              code: _string(item, 'code') ?? local?.code ?? '000000',
              fullName: _string(item, 'fullName') ?? local?.fullName ?? '',
              passwordPin:
                  _string(item, 'passwordPin') ??
                  local?.passwordPin ??
                  '123456',
              roleId: _string(item, 'roleId') ?? local?.roleId ?? 'role_user',
              operatorId: Value<String?>(_string(item, 'operatorId')),
              isActive: Value(
                _bool(item, 'isActive', fallback: local?.isActive ?? true),
              ),
              createdAt: Value(
                _dateTime(item, 'createdAt', fallback: local?.createdAt),
              ),
              updatedAt: Value(_dateTime(item, 'updatedAt')),
              deletedAt: Value<DateTime?>(_dateTimeOrNull(item, 'deletedAt')),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyUserDepartments(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final id = _string(item, 'id');
      if (id == null || id.isEmpty) continue;

      final local = await (_database.select(
        _database.userDepartments,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (!_shouldApplyRemote(
        localSyncStatus: local?.syncStatus,
        localUpdatedAt: local?.updatedAt,
        remoteUpdatedAt: _dateTimeOrNull(item, 'updatedAt'),
      )) {
        continue;
      }

      final userId = _string(item, 'userId') ?? local?.userId;
      final departmentId = _string(item, 'departmentId') ?? local?.departmentId;
      if (userId == null || departmentId == null) continue;

      await _database
          .into(_database.userDepartments)
          .insertOnConflictUpdate(
            UserDepartmentsCompanion.insert(
              id: id,
              userId: userId,
              departmentId: departmentId,
              createdAt: Value(
                _dateTime(item, 'createdAt', fallback: local?.createdAt),
              ),
              updatedAt: Value(_dateTime(item, 'updatedAt')),
              deletedAt: Value<DateTime?>(_dateTimeOrNull(item, 'deletedAt')),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyTasks(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final id = _string(item, 'id');
      if (id == null || id.isEmpty) continue;

      final local = await (_database.select(
        _database.tasks,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (!_shouldApplyRemote(
        localSyncStatus: local?.syncStatus,
        localUpdatedAt: local?.updatedAt,
        remoteUpdatedAt: _dateTimeOrNull(item, 'updatedAt'),
      )) {
        continue;
      }

      await _database
          .into(_database.tasks)
          .insertOnConflictUpdate(
            TasksCompanion.insert(
              id: id,
              serverId: Value<String?>(_string(item, 'serverId')),
              departmentId: Value<String?>(_string(item, 'departmentId')),
              cropId: Value<String?>(_string(item, 'cropId')),
              code: Value<String?>(_string(item, 'code')),
              name: _string(item, 'name') ?? local?.name ?? '',
              defaultDetail: Value<String?>(_string(item, 'defaultDetail')),
              isActive: Value(
                _bool(item, 'isActive', fallback: local?.isActive ?? true),
              ),
              createdAt: Value(
                _dateTime(item, 'createdAt', fallback: local?.createdAt),
              ),
              updatedAt: Value(_dateTime(item, 'updatedAt')),
              deletedAt: Value<DateTime?>(_dateTimeOrNull(item, 'deletedAt')),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyLocations(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final id = _string(item, 'id');
      if (id == null || id.isEmpty) continue;

      final local = await (_database.select(
        _database.locations,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (!_shouldApplyRemote(
        localSyncStatus: local?.syncStatus,
        localUpdatedAt: local?.updatedAt,
        remoteUpdatedAt: _dateTimeOrNull(item, 'updatedAt'),
      )) {
        continue;
      }

      final cropId = _string(item, 'cropId') ?? local?.cropId;
      if (cropId == null) continue;

      await _database
          .into(_database.locations)
          .insertOnConflictUpdate(
            LocationsCompanion.insert(
              id: id,
              serverId: Value<String?>(_string(item, 'serverId')),
              cropId: cropId,
              lot: _string(item, 'lot') ?? local?.lot ?? '',
              network: _string(item, 'network') ?? local?.network ?? '',
              sector: _string(item, 'sector') ?? local?.sector ?? '',
              ha: _double(item, 'ha', fallback: local?.ha ?? 0),
              suggestedDiningRoom: Value<String?>(
                _string(item, 'suggestedDiningRoom'),
              ),
              isActive: Value(
                _bool(item, 'isActive', fallback: local?.isActive ?? true),
              ),
              createdAt: Value(
                _dateTime(item, 'createdAt', fallback: local?.createdAt),
              ),
              updatedAt: Value(_dateTime(item, 'updatedAt')),
              deletedAt: Value<DateTime?>(_dateTimeOrNull(item, 'deletedAt')),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyDiningRooms(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final id = _string(item, 'id');
      if (id == null || id.isEmpty) continue;

      final local = await (_database.select(
        _database.diningRooms,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (!_shouldApplyRemote(
        localSyncStatus: local?.syncStatus,
        localUpdatedAt: local?.updatedAt,
        remoteUpdatedAt: _dateTimeOrNull(item, 'updatedAt'),
      )) {
        continue;
      }

      final cropId = _string(item, 'cropId') ?? local?.cropId;
      if (cropId == null) continue;

      await _database
          .into(_database.diningRooms)
          .insertOnConflictUpdate(
            DiningRoomsCompanion.insert(
              id: id,
              serverId: Value<String?>(_string(item, 'serverId')),
              cropId: cropId,
              name: _string(item, 'name') ?? local?.name ?? '',
              lot: Value<String?>(_string(item, 'lot')),
              network: Value<String?>(_string(item, 'network')),
              isActive: Value(
                _bool(item, 'isActive', fallback: local?.isActive ?? true),
              ),
              createdAt: Value(
                _dateTime(item, 'createdAt', fallback: local?.createdAt),
              ),
              updatedAt: Value(_dateTime(item, 'updatedAt')),
              deletedAt: Value<DateTime?>(_dateTimeOrNull(item, 'deletedAt')),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyRecords(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final id = _string(item, 'id');
      if (id == null || id.isEmpty) continue;

      final local = await (_database.select(
        _database.records,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (!_shouldApplyRemote(
        localSyncStatus: local?.syncStatus,
        localUpdatedAt: local?.updatedAt,
        remoteUpdatedAt: _dateTimeOrNull(item, 'updatedAt'),
      )) {
        continue;
      }

      final departmentId = _string(item, 'departmentId') ?? local?.departmentId;
      final createdByUserId =
          _string(item, 'createdByUserId') ?? local?.createdByUserId;
      final userCode = _string(item, 'userCode') ?? local?.userCode;
      if (departmentId == null || createdByUserId == null || userCode == null) {
        continue;
      }

      await _database
          .into(_database.records)
          .insertOnConflictUpdate(
            RecordsCompanion.insert(
              id: id,
              serverId: Value<String?>(_string(item, 'serverId')),
              recordDate: _dateTime(
                item,
                'recordDate',
                fallback: local?.recordDate,
              ),
              weekNumber: _int(
                item,
                'weekNumber',
                fallback: local?.weekNumber ?? 0,
              ),
              departmentId: departmentId,
              createdByUserId: createdByUserId,
              userCode: userCode,
              operatorId: Value<String?>(_string(item, 'operatorId')),
              operatorNameSnapshot: Value<String?>(
                _string(item, 'operatorNameSnapshot'),
              ),
              leaderOperatorId: Value<String?>(
                _string(item, 'leaderOperatorId'),
              ),
              leaderCodeSnapshot: Value<String?>(
                _string(item, 'leaderCodeSnapshot'),
              ),
              leaderNameSnapshot: Value<String?>(
                _string(item, 'leaderNameSnapshot'),
              ),
              cropId: Value<String?>(_string(item, 'cropId')),
              cropNameSnapshot: Value<String?>(
                _string(item, 'cropNameSnapshot'),
              ),
              taskId: Value<String?>(_string(item, 'taskId')),
              taskCodeSnapshot: Value<String?>(
                _string(item, 'taskCodeSnapshot'),
              ),
              taskNameSnapshot: Value<String?>(
                _string(item, 'taskNameSnapshot'),
              ),
              taskDetail: Value<String?>(_string(item, 'taskDetail')),
              lot: Value<String?>(_string(item, 'lot')),
              network: Value<String?>(_string(item, 'network')),
              scheduledWage: Value<double?>(
                _doubleOrNull(item, 'scheduledWage'),
              ),
              realWage: Value<double?>(_doubleOrNull(item, 'realWage')),
              ha: Value(_double(item, 'ha', fallback: local?.ha ?? 0)),
              ratio: Value<double?>(_doubleOrNull(item, 'ratio')),
              diningRoomId: Value<String?>(_string(item, 'diningRoomId')),
              diningRoom: Value<String?>(_string(item, 'diningRoom')),
              observation: Value<String?>(_string(item, 'observation')),
              extraFieldsJson: Value<String?>(_string(item, 'extraFieldsJson')),
              isActive: Value(
                _bool(item, 'isActive', fallback: local?.isActive ?? true),
              ),
              isLocked: Value(
                _bool(item, 'isLocked', fallback: local?.isLocked ?? false),
              ),
              createdAt: Value(
                _dateTime(item, 'createdAt', fallback: local?.createdAt),
              ),
              updatedAt: Value(_dateTime(item, 'updatedAt')),
              deletedAt: Value<DateTime?>(_dateTimeOrNull(item, 'deletedAt')),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );

      final locations = item['locations'];
      if (locations is List) {
        await _applyRecordLocations(
          locations
              .whereType<Map>()
              .map((location) => Map<String, dynamic>.from(location))
              .toList(),
        );
      }
    }
  }

  Future<void> _applyRecordLocations(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final id = _string(item, 'id');
      if (id == null || id.isEmpty) continue;

      final local = await (_database.select(
        _database.recordLocations,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (!_shouldApplyRemote(
        localSyncStatus: local?.syncStatus,
        localUpdatedAt: local?.updatedAt,
        remoteUpdatedAt: _dateTimeOrNull(item, 'updatedAt'),
      )) {
        continue;
      }

      final recordId = _string(item, 'recordId') ?? local?.recordId;
      final locationId = _string(item, 'locationId') ?? local?.locationId;
      if (recordId == null || locationId == null) continue;

      await _database
          .into(_database.recordLocations)
          .insertOnConflictUpdate(
            RecordLocationsCompanion.insert(
              id: id,
              recordId: recordId,
              locationId: locationId,
              cropNameSnapshot:
                  _string(item, 'cropNameSnapshot') ??
                  local?.cropNameSnapshot ??
                  '',
              lotSnapshot:
                  _string(item, 'lotSnapshot') ?? local?.lotSnapshot ?? '',
              networkSnapshot:
                  _string(item, 'networkSnapshot') ??
                  local?.networkSnapshot ??
                  '',
              sectorSnapshot:
                  _string(item, 'sectorSnapshot') ??
                  local?.sectorSnapshot ??
                  '',
              haSnapshot: _double(
                item,
                'haSnapshot',
                fallback: local?.haSnapshot ?? 0,
              ),
              createdAt: Value(
                _dateTime(item, 'createdAt', fallback: local?.createdAt),
              ),
              updatedAt: Value(_dateTime(item, 'updatedAt')),
              deletedAt: Value<DateTime?>(_dateTimeOrNull(item, 'deletedAt')),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyFormFields(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final id = _string(item, 'id');
      if (id == null || id.isEmpty) continue;

      final local = await (_database.select(
        _database.formFieldConfigs,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (!_shouldApplyRemote(
        localSyncStatus: local?.syncStatus,
        localUpdatedAt: local?.updatedAt,
        remoteUpdatedAt: _dateTimeOrNull(item, 'updatedAt'),
      )) {
        continue;
      }

      final departmentId = _string(item, 'departmentId') ?? local?.departmentId;
      if (departmentId == null) continue;

      await _database
          .into(_database.formFieldConfigs)
          .insertOnConflictUpdate(
            FormFieldConfigsCompanion.insert(
              id: id,
              departmentId: departmentId,
              fieldKey: _string(item, 'fieldKey') ?? local?.fieldKey ?? '',
              label: _string(item, 'label') ?? local?.label ?? '',
              fieldType:
                  _string(item, 'fieldType') ?? local?.fieldType ?? 'text',
              isRequired: Value(
                _bool(item, 'isRequired', fallback: local?.isRequired ?? false),
              ),
              isVisible: Value(
                _bool(item, 'isVisible', fallback: local?.isVisible ?? true),
              ),
              sortOrder: Value(
                _int(item, 'sortOrder', fallback: local?.sortOrder ?? 0),
              ),
              optionsJson: Value<String?>(_string(item, 'optionsJson')),
              createdAt: Value(
                _dateTime(item, 'createdAt', fallback: local?.createdAt),
              ),
              updatedAt: Value(_dateTime(item, 'updatedAt')),
              deletedAt: Value<DateTime?>(_dateTimeOrNull(item, 'deletedAt')),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyTableColumns(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final id = _string(item, 'id');
      if (id == null || id.isEmpty) continue;

      final local = await (_database.select(
        _database.tableColumnConfigs,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (!_shouldApplyRemote(
        localSyncStatus: local?.syncStatus,
        localUpdatedAt: local?.updatedAt,
        remoteUpdatedAt: _dateTimeOrNull(item, 'updatedAt'),
      )) {
        continue;
      }

      await _database
          .into(_database.tableColumnConfigs)
          .insertOnConflictUpdate(
            TableColumnConfigsCompanion.insert(
              id: id,
              departmentId: Value<String?>(_string(item, 'departmentId')),
              tableKey: _string(item, 'tableKey') ?? local?.tableKey ?? '',
              columnKey: _string(item, 'columnKey') ?? local?.columnKey ?? '',
              label: _string(item, 'label') ?? local?.label ?? '',
              isVisible: Value(
                _bool(item, 'isVisible', fallback: local?.isVisible ?? true),
              ),
              isExportable: Value(
                _bool(
                  item,
                  'isExportable',
                  fallback: local?.isExportable ?? true,
                ),
              ),
              sortOrder: Value(
                _int(item, 'sortOrder', fallback: local?.sortOrder ?? 0),
              ),
              createdAt: Value(
                _dateTime(item, 'createdAt', fallback: local?.createdAt),
              ),
              updatedAt: Value(_dateTime(item, 'updatedAt')),
              deletedAt: Value<DateTime?>(_dateTimeOrNull(item, 'deletedAt')),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  bool _shouldApplyRemote({
    required String? localSyncStatus,
    required DateTime? localUpdatedAt,
    required DateTime? remoteUpdatedAt,
  }) {
    if (localSyncStatus == SyncStatuses.pending ||
        localSyncStatus == SyncStatuses.syncing ||
        localSyncStatus == SyncStatuses.error) {
      return false;
    }

    if (localUpdatedAt == null || remoteUpdatedAt == null) {
      return true;
    }

    return !remoteUpdatedAt.isBefore(localUpdatedAt);
  }

  Map<String, dynamic> _rolePayload(LocalRole row) => {
    'id': row.id,
    'name': row.name,
    'isAdmin': row.isAdmin,
    'createdAt': row.createdAt.toIso8601String(),
    'updatedAt': row.updatedAt.toIso8601String(),
    'deletedAt': row.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _cropPayload(Crop row) => {
    'id': row.id,
    'serverId': row.serverId,
    'name': row.name,
    'isActive': row.isActive,
    'createdAt': row.createdAt.toIso8601String(),
    'updatedAt': row.updatedAt.toIso8601String(),
    'deletedAt': row.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _positionPayload(OperatorPosition row) => {
    'id': row.id,
    'serverId': row.serverId,
    'name': row.name,
    'canBeLeader': row.canBeLeader,
    'canLogin': row.canLogin,
    'isActive': row.isActive,
    'createdAt': row.createdAt.toIso8601String(),
    'updatedAt': row.updatedAt.toIso8601String(),
    'deletedAt': row.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _departmentPayload(Department row) => {
    'id': row.id,
    'serverId': row.serverId,
    'name': row.name,
    'cropId': row.cropId,
    'isActive': row.isActive,
    'createdAt': row.createdAt.toIso8601String(),
    'updatedAt': row.updatedAt.toIso8601String(),
    'deletedAt': row.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _operatorPayload(FarmOperator row) => {
    'id': row.id,
    'serverId': row.serverId,
    'code': row.code,
    'fullName': row.fullName,
    'departmentId': row.departmentId,
    'positionId': row.positionId,
    'isActive': row.isActive,
    'createdAt': row.createdAt.toIso8601String(),
    'updatedAt': row.updatedAt.toIso8601String(),
    'deletedAt': row.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _userPayload(LocalUser row) => {
    'id': row.id,
    'serverId': row.serverId,
    'code': row.code,
    'fullName': row.fullName,
    'passwordPin': row.passwordPin,
    'roleId': row.roleId,
    'operatorId': row.operatorId,
    'isActive': row.isActive,
    'createdAt': row.createdAt.toIso8601String(),
    'updatedAt': row.updatedAt.toIso8601String(),
    'deletedAt': row.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _userDepartmentPayload(UserDepartment row) => {
    'id': row.id,
    'userId': row.userId,
    'departmentId': row.departmentId,
    'createdAt': row.createdAt.toIso8601String(),
    'updatedAt': row.updatedAt.toIso8601String(),
    'deletedAt': row.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _taskPayload(FarmTask row) => {
    'id': row.id,
    'serverId': row.serverId,
    'departmentId': row.departmentId,
    'cropId': row.cropId,
    'code': row.code,
    'name': row.name,
    'defaultDetail': row.defaultDetail,
    'isActive': row.isActive,
    'createdAt': row.createdAt.toIso8601String(),
    'updatedAt': row.updatedAt.toIso8601String(),
    'deletedAt': row.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _locationPayload(LocationEntry row) => {
    'id': row.id,
    'serverId': row.serverId,
    'cropId': row.cropId,
    'lot': row.lot,
    'network': row.network,
    'sector': row.sector,
    'ha': row.ha,
    'suggestedDiningRoom': row.suggestedDiningRoom,
    'isActive': row.isActive,
    'createdAt': row.createdAt.toIso8601String(),
    'updatedAt': row.updatedAt.toIso8601String(),
    'deletedAt': row.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _diningRoomPayload(DiningRoom row) => {
    'id': row.id,
    'serverId': row.serverId,
    'cropId': row.cropId,
    'name': row.name,
    'lot': row.lot,
    'network': row.network,
    'isActive': row.isActive,
    'createdAt': row.createdAt.toIso8601String(),
    'updatedAt': row.updatedAt.toIso8601String(),
    'deletedAt': row.deletedAt?.toIso8601String(),
  };

  Future<Map<String, dynamic>> _recordPayload(FarmRecord row) async {
    final locations = await (_database.select(
      _database.recordLocations,
    )..where((tbl) => tbl.recordId.equals(row.id))).get();

    return {
      'id': row.id,
      'serverId': row.serverId,
      'recordDate': row.recordDate.toIso8601String(),
      'weekNumber': row.weekNumber,
      'departmentId': row.departmentId,
      'createdByUserId': row.createdByUserId,
      'userCode': row.userCode,
      'operatorId': row.operatorId,
      'operatorNameSnapshot': row.operatorNameSnapshot,
      'leaderOperatorId': row.leaderOperatorId,
      'leaderCodeSnapshot': row.leaderCodeSnapshot,
      'leaderNameSnapshot': row.leaderNameSnapshot,
      'cropId': row.cropId,
      'cropNameSnapshot': row.cropNameSnapshot,
      'taskId': row.taskId,
      'taskCodeSnapshot': row.taskCodeSnapshot,
      'taskNameSnapshot': row.taskNameSnapshot,
      'taskDetail': row.taskDetail,
      'lot': row.lot,
      'network': row.network,
      'scheduledWage': row.scheduledWage,
      'realWage': row.realWage,
      'ha': row.ha,
      'ratio': row.ratio,
      'diningRoomId': row.diningRoomId,
      'diningRoom': row.diningRoom,
      'observation': row.observation,
      'extraFieldsJson': row.extraFieldsJson,
      'isActive': row.isActive,
      'isLocked': row.isLocked,
      'createdAt': row.createdAt.toIso8601String(),
      'updatedAt': row.updatedAt.toIso8601String(),
      'deletedAt': row.deletedAt?.toIso8601String(),
      'locations': locations.map(_recordLocationPayload).toList(),
    };
  }

  Map<String, dynamic> _recordLocationPayload(FarmRecordLocation row) => {
    'id': row.id,
    'recordId': row.recordId,
    'locationId': row.locationId,
    'cropNameSnapshot': row.cropNameSnapshot,
    'lotSnapshot': row.lotSnapshot,
    'networkSnapshot': row.networkSnapshot,
    'sectorSnapshot': row.sectorSnapshot,
    'haSnapshot': row.haSnapshot,
    'createdAt': row.createdAt.toIso8601String(),
    'updatedAt': row.updatedAt.toIso8601String(),
    'deletedAt': row.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _formFieldPayload(FormFieldConfig row) => {
    'id': row.id,
    'departmentId': row.departmentId,
    'fieldKey': row.fieldKey,
    'label': row.label,
    'fieldType': row.fieldType,
    'isRequired': row.isRequired,
    'isVisible': row.isVisible,
    'sortOrder': row.sortOrder,
    'optionsJson': row.optionsJson,
    'createdAt': row.createdAt.toIso8601String(),
    'updatedAt': row.updatedAt.toIso8601String(),
    'deletedAt': row.deletedAt?.toIso8601String(),
  };

  Map<String, dynamic> _tableColumnPayload(TableColumnConfig row) => {
    'id': row.id,
    'departmentId': row.departmentId,
    'tableKey': row.tableKey,
    'columnKey': row.columnKey,
    'label': row.label,
    'isVisible': row.isVisible,
    'isExportable': row.isExportable,
    'sortOrder': row.sortOrder,
    'createdAt': row.createdAt.toIso8601String(),
    'updatedAt': row.updatedAt.toIso8601String(),
    'deletedAt': row.deletedAt?.toIso8601String(),
  };

  String? _string(Map<String, dynamic> item, String key) {
    final value = item[key] ?? item[_snakeCase(key)];

    if (value == null) {
      return null;
    }

    return value.toString();
  }

  bool _bool(Map<String, dynamic> item, String key, {required bool fallback}) {
    final value = item[key] ?? item[_snakeCase(key)];

    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      if (normalized == 'true' ||
          normalized == '1' ||
          normalized == 'sí' ||
          normalized == 'si') {
        return true;
      }
      if (normalized == 'false' || normalized == '0' || normalized == 'no') {
        return false;
      }
    }

    return fallback;
  }

  int _int(Map<String, dynamic> item, String key, {required int fallback}) {
    final value = item[key] ?? item[_snakeCase(key)];

    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;

    return fallback;
  }

  double _double(
    Map<String, dynamic> item,
    String key, {
    required double fallback,
  }) {
    final value = item[key] ?? item[_snakeCase(key)];

    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.replaceAll(',', '.')) ?? fallback;
    }

    return fallback;
  }

  double? _doubleOrNull(Map<String, dynamic> item, String key) {
    final value = item[key] ?? item[_snakeCase(key)];

    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.replaceAll(',', '.'));

    return null;
  }

  DateTime _dateTime(
    Map<String, dynamic> item,
    String key, {
    DateTime? fallback,
  }) {
    return _dateTimeOrNull(item, key) ?? fallback ?? DateTime.now();
  }

  DateTime? _dateTimeOrNull(Map<String, dynamic> item, String key) {
    final value = item[key] ?? item[_snakeCase(key)];

    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);

    return null;
  }

  String _snakeCase(String key) {
    return key.replaceAllMapped(
      RegExp('[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );
  }
}

class _PushResult {
  const _PushResult({required this.uploaded, required this.failed});

  final int uploaded;
  final int failed;
}

final syncApiClientProvider = Provider<RemoteSyncApiClient>((ref) {
  if (AppEnvironment.useRemoteSyncApi) {
    return DioSyncApiClient(baseUrl: AppEnvironment.apiBaseUrl.trim());
  }

  return MockRemoteSyncApiClient();
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    database: ref.watch(appDatabaseProvider),
    apiClient: ref.watch(syncApiClientProvider),
    lockRepository: ref.watch(recordLockRepositoryProvider),
  );
});

final syncAutoStartProvider = Provider<void>((ref) {
  final service = ref.watch(syncServiceProvider);

  var running = false;
  Timer? timer;
  StreamSubscription<List<ConnectivityResult>>? subscription;

  Future<void> trySync() async {
    if (running) {
      return;
    }

    running = true;

    try {
      await service.synchronize();
    } catch (_) {
      // La sincronización automática no debe romper la app.
    } finally {
      running = false;
    }
  }

  Connectivity().checkConnectivity().then((results) {
    if (results.any((result) => result != ConnectivityResult.none)) {
      unawaited(trySync());
    }
  });

  subscription = Connectivity().onConnectivityChanged.listen((results) {
    if (results.any((result) => result != ConnectivityResult.none)) {
      unawaited(trySync());
    }
  });

  timer = Timer.periodic(const Duration(minutes: 5), (_) {
    unawaited(trySync());
  });

  ref.onDispose(() {
    timer?.cancel();
    subscription?.cancel();
  });
});
