import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    required this.pendingQueueItems,
    required this.errorQueueItems,
    required this.lastSuccessfulSyncAt,
    required this.mockServerShouldFail,
  });

  final int pendingRecords;
  final int errorRecords;
  final int pendingQueueItems;
  final int errorQueueItems;
  final DateTime? lastSuccessfulSyncAt;
  final bool mockServerShouldFail;
}

class SyncService {
  SyncService({
    required this._database,
    required this._apiClient,
    required this._lockRepository,
  });

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
        message: 'Sin conexión. Los registros quedan pendientes.',
      );
    }

    await _rebuildQueueFromLocalChanges();

    final pushResult = await _pushQueue();
    final downloaded = await _pullAndApplyChanges();

    if (pushResult.failed == 0) {
      await _saveLastSuccessfulSyncAt(DateTime.now());
    }

    return SyncRunResult(
      wasOnline: true,
      uploaded: pushResult.uploaded,
      downloaded: downloaded,
      failed: pushResult.failed,
      message: pushResult.failed == 0
          ? 'Sincronización completada.'
          : 'Sincronización completada con errores.',
    );
  }

  Future<bool> hasConnectivity() async {
    final results = await Connectivity().checkConnectivity();

    return results.any((result) => result != ConnectivityResult.none);
  }

  Future<SyncDashboard> getDashboard() async {
    final pendingRecords = await _countRecordsByStatus(SyncStatuses.pending);
    final errorRecords = await _countRecordsByStatus(SyncStatuses.error);
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
    final recordsToQueue =
        await (_database.select(_database.records)..where(
              (tbl) =>
                  tbl.syncStatus.equals(SyncStatuses.pending) |
                  tbl.syncStatus.equals(SyncStatuses.error),
            ))
            .get();

    for (final record in recordsToQueue) {
      final hasOpenQueue = await _hasOpenQueueForRecord(record.id);

      if (hasOpenQueue) {
        continue;
      }

      final operation = record.deletedAt != null || !record.isActive
          ? 'delete'
          : record.serverId == null
          ? 'create'
          : 'update';

      final payload = await _buildRecordPayload(record);

      final now = DateTime.now();

      await _database
          .into(_database.syncQueueItems)
          .insert(
            SyncQueueItemsCompanion.insert(
              id: 'queue_${record.id}_${now.microsecondsSinceEpoch}',
              entityType: 'record',
              entityId: record.id,
              operation: operation,
              payloadJson: jsonEncode(payload),
              status: const Value(SyncStatuses.pending),
              attempts: const Value(0),
              createdAt: Value(now),
              updatedAt: Value(now),
              syncStatus: const Value(SyncStatuses.pending),
            ),
          );
    }
  }

  Future<bool> _hasOpenQueueForRecord(String recordId) async {
    final item =
        await (_database.select(_database.syncQueueItems)
              ..where(
                (tbl) =>
                    tbl.entityType.equals('record') &
                    tbl.entityId.equals(recordId) &
                    tbl.deletedAt.isNull() &
                    (tbl.status.equals(SyncStatuses.pending) |
                        tbl.status.equals(SyncStatuses.error) |
                        tbl.status.equals(SyncStatuses.syncing)),
              )
              ..limit(1))
            .getSingleOrNull();

    return item != null;
  }

  Future<Map<String, dynamic>> _buildRecordPayload(FarmRecord record) async {
    final locations = await (_database.select(
      _database.recordLocations,
    )..where((tbl) => tbl.recordId.equals(record.id))).get();

    return {
      'id': record.id,
      'serverId': record.serverId,
      'recordDate': record.recordDate.toIso8601String(),
      'weekNumber': record.weekNumber,
      'departmentId': record.departmentId,
      'createdByUserId': record.createdByUserId,
      'userCode': record.userCode,
      'operatorId': record.operatorId,
      'operatorNameSnapshot': record.operatorNameSnapshot,
      'cropId': record.cropId,
      'cropNameSnapshot': record.cropNameSnapshot,
      'taskId': record.taskId,
      'taskNameSnapshot': record.taskNameSnapshot,
      'taskDetail': record.taskDetail,
      'lot': record.lot,
      'network': record.network,
      'scheduledWage': record.scheduledWage,
      'realWage': record.realWage,
      'ha': record.ha,
      'ratio': record.ratio,
      'diningRoom': record.diningRoom,
      'observation': record.observation,
      'extraFieldsJson': record.extraFieldsJson,
      'isActive': record.isActive,
      'deletedAt': record.deletedAt?.toIso8601String(),
      'updatedAt': record.updatedAt.toIso8601String(),
      'locations': locations
          .map(
            (item) => {
              'id': item.id,
              'recordId': item.recordId,
              'locationId': item.locationId,
              'cropNameSnapshot': item.cropNameSnapshot,
              'lotSnapshot': item.lotSnapshot,
              'networkSnapshot': item.networkSnapshot,
              'sectorSnapshot': item.sectorSnapshot,
              'haSnapshot': item.haSnapshot,
              'deletedAt': item.deletedAt?.toIso8601String(),
            },
          )
          .toList(),
    };
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

        await _markRecordSynced(
          recordId: item.entityId,
          serverId: result.serverId,
        );

        await _markQueueItemSynced(item);
        uploaded++;
      } catch (error) {
        await _markRecordError(item.entityId);
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
      await _applyUsers(bundle.users);
      await _applyDepartments(bundle.departments);
      await _applyUserDepartments(bundle.userDepartments);
      await _applyOperators(bundle.operators);
      await _applyCrops(bundle.crops);
      await _applyTasks(bundle.tasks);
      await _applyLocations(bundle.locations);
      await _applyFormFields(bundle.formFields);
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

    await (_database.update(
      _database.records,
    )..where((tbl) => tbl.id.equals(item.entityId))).write(
      RecordsCompanion(
        syncStatus: const Value(SyncStatuses.syncing),
        updatedAt: Value(now),
      ),
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

  Future<void> _markRecordSynced({
    required String recordId,
    required String serverId,
  }) async {
    final now = DateTime.now();

    await (_database.update(
      _database.records,
    )..where((tbl) => tbl.id.equals(recordId))).write(
      RecordsCompanion(
        serverId: Value<String?>(serverId),
        syncStatus: const Value(SyncStatuses.synced),
        updatedAt: Value(now),
      ),
    );

    await (_database.update(
      _database.recordLocations,
    )..where((tbl) => tbl.recordId.equals(recordId))).write(
      RecordLocationsCompanion(
        syncStatus: const Value(SyncStatuses.synced),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> _markRecordError(String recordId) async {
    final now = DateTime.now();

    await (_database.update(
      _database.records,
    )..where((tbl) => tbl.id.equals(recordId))).write(
      RecordsCompanion(
        syncStatus: const Value(SyncStatuses.error),
        updatedAt: Value(now),
      ),
    );

    await (_database.update(
      _database.recordLocations,
    )..where((tbl) => tbl.recordId.equals(recordId))).write(
      RecordLocationsCompanion(
        syncStatus: const Value(SyncStatuses.error),
        updatedAt: Value(now),
      ),
    );
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

  Future<void> _applyRoles(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      await _database
          .into(_database.roles)
          .insertOnConflictUpdate(
            RolesCompanion.insert(
              id: item['id'] as String,
              name: item['name'] as String,
              isAdmin: Value(item['isAdmin'] as bool? ?? false),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyUsers(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      await _database
          .into(_database.users)
          .insertOnConflictUpdate(
            UsersCompanion.insert(
              id: item['id'] as String,
              code: item['code'] as String,
              fullName: item['fullName'] as String,
              passwordPin: item['passwordPin'] as String? ?? '123456',
              roleId: item['roleId'] as String,
              isActive: Value(item['isActive'] as bool? ?? true),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyDepartments(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      await _database
          .into(_database.departments)
          .insertOnConflictUpdate(
            DepartmentsCompanion.insert(
              id: item['id'] as String,
              name: item['name'] as String,
              isActive: Value(item['isActive'] as bool? ?? true),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyUserDepartments(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      await _database
          .into(_database.userDepartments)
          .insertOnConflictUpdate(
            UserDepartmentsCompanion.insert(
              id: item['id'] as String,
              userId: item['userId'] as String,
              departmentId: item['departmentId'] as String,
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyOperators(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      await _database
          .into(_database.operators)
          .insertOnConflictUpdate(
            OperatorsCompanion.insert(
              id: item['id'] as String,
              code: item['code'] as String,
              fullName: item['fullName'] as String,
              departmentId: Value<String?>(item['departmentId'] as String?),
              isActive: Value(item['isActive'] as bool? ?? true),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyCrops(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      await _database
          .into(_database.crops)
          .insertOnConflictUpdate(
            CropsCompanion.insert(
              id: item['id'] as String,
              name: item['name'] as String,
              isActive: Value(item['isActive'] as bool? ?? true),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyTasks(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      await _database
          .into(_database.tasks)
          .insertOnConflictUpdate(
            TasksCompanion.insert(
              id: item['id'] as String,
              departmentId: Value<String?>(item['departmentId'] as String?),
              name: item['name'] as String,
              defaultDetail: Value<String?>(item['defaultDetail'] as String?),
              isActive: Value(item['isActive'] as bool? ?? true),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyLocations(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      await _database
          .into(_database.locations)
          .insertOnConflictUpdate(
            LocationsCompanion.insert(
              id: item['id'] as String,
              cropId: item['cropId'] as String,
              lot: item['lot'] as String,
              network: item['network'] as String,
              sector: item['sector'] as String,
              ha: (item['ha'] as num).toDouble(),
              suggestedDiningRoom: Value<String?>(
                item['suggestedDiningRoom'] as String?,
              ),
              isActive: Value(item['isActive'] as bool? ?? true),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }

  Future<void> _applyFormFields(List<Map<String, dynamic>> items) async {
    for (final item in items) {
      await _database
          .into(_database.formFieldConfigs)
          .insertOnConflictUpdate(
            FormFieldConfigsCompanion.insert(
              id: item['id'] as String,
              departmentId: item['departmentId'] as String,
              fieldKey: item['fieldKey'] as String,
              label: item['label'] as String,
              fieldType: item['fieldType'] as String,
              isRequired: Value(item['isRequired'] as bool? ?? false),
              isVisible: Value(item['isVisible'] as bool? ?? true),
              sortOrder: Value(item['sortOrder'] as int? ?? 0),
              optionsJson: Value<String?>(item['optionsJson'] as String?),
              syncStatus: const Value(SyncStatuses.synced),
            ),
          );
    }
  }
}

class _PushResult {
  const _PushResult({required this.uploaded, required this.failed});

  final int uploaded;
  final int failed;
}

final syncApiClientProvider = Provider<RemoteSyncApiClient>((ref) {
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
