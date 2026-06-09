import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/errors/app_error.dart';
import '../../../data/local/app_database.dart';
import '../../settings/data/record_lock_config.dart';

class UploadResult {
  const UploadResult({required this.serverId});

  final String serverId;
}

class SyncPullBundle {
  const SyncPullBundle({
    required this.roles,
    required this.users,
    required this.departments,
    required this.userDepartments,
    required this.positions,
    required this.operators,
    required this.crops,
    required this.tasks,
    required this.locations,
    required this.diningRooms,
    required this.records,
    required this.recordLocations,
    required this.formFields,
    required this.tableColumns,
    required this.lockConfigs,
  });

  final List<Map<String, dynamic>> roles;
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> departments;
  final List<Map<String, dynamic>> userDepartments;
  final List<Map<String, dynamic>> positions;
  final List<Map<String, dynamic>> operators;
  final List<Map<String, dynamic>> crops;
  final List<Map<String, dynamic>> tasks;
  final List<Map<String, dynamic>> locations;
  final List<Map<String, dynamic>> diningRooms;
  final List<Map<String, dynamic>> records;
  final List<Map<String, dynamic>> recordLocations;
  final List<Map<String, dynamic>> formFields;
  final List<Map<String, dynamic>> tableColumns;
  final List<RecordLockConfig> lockConfigs;

  int get downloadedCount {
    return roles.length +
        users.length +
        departments.length +
        userDepartments.length +
        positions.length +
        operators.length +
        crops.length +
        tasks.length +
        locations.length +
        diningRooms.length +
        records.length +
        recordLocations.length +
        formFields.length +
        tableColumns.length +
        lockConfigs.length;
  }
}

abstract class RemoteSyncApiClient {
  Future<UploadResult> uploadQueueItem(SyncQueueItem item);

  Future<SyncPullBundle> pullChanges({required DateTime? since});
}

class MockRemoteSyncApiClient implements RemoteSyncApiClient {
  static const _failKey = 'mock_sync_server_should_fail';
  static const _storeKey = 'mock_sync_server_store_v2';

  Future<bool> shouldFail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_failKey) ?? false;
  }

  Future<void> setShouldFail(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_failKey, value);
  }

  @override
  Future<UploadResult> uploadQueueItem(SyncQueueItem item) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (await shouldFail()) {
      throw Exception('Servidor no disponible.');
    }

    final prefs = await SharedPreferences.getInstance();
    final store = _decodeStore(prefs.getString(_storeKey));
    final entityStore = Map<String, dynamic>.from(
      store[item.entityType] as Map<String, dynamic>? ?? const {},
    );
    final payload = _decodePayload(item.payloadJson);
    final serverId = payload['serverId'] as String? ?? 'srv_${item.entityId}';

    payload['serverId'] = serverId;
    payload['syncStatus'] = SyncStatuses.synced;
    payload['mockServerUpdatedAt'] = DateTime.now().toIso8601String();

    entityStore[item.entityId] = payload;
    store[item.entityType] = entityStore;

    // Un registro se sube como cabecera + detalle de sectores. El mock guarda
    // ambos para que el pull pueda simular otro dispositivo descargando todo.
    if (item.entityType == 'record') {
      final recordLocations = Map<String, dynamic>.from(
        store['record_location'] as Map<String, dynamic>? ?? const {},
      );
      final locations = payload['locations'];

      if (locations is List) {
        for (final location in locations) {
          if (location is Map) {
            final row = Map<String, dynamic>.from(location);
            final id = row['id'] as String?;

            if (id != null && id.isNotEmpty) {
              row['syncStatus'] = SyncStatuses.synced;
              row['mockServerUpdatedAt'] = DateTime.now().toIso8601String();
              recordLocations[id] = row;
            }
          }
        }
      }

      store['record_location'] = recordLocations;
    }

    await prefs.setString(_storeKey, jsonEncode(store));

    return UploadResult(serverId: serverId);
  }

  @override
  Future<SyncPullBundle> pullChanges({required DateTime? since}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (await shouldFail()) {
      throw Exception('No se pudieron descargar cambios del servidor.');
    }

    final prefs = await SharedPreferences.getInstance();
    final store = _decodeStore(prefs.getString(_storeKey));

    List<Map<String, dynamic>> values(String entityType) {
      final raw = store[entityType];

      if (raw is Map) {
        return raw.values
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .where((item) => _isAfterSince(item, since))
            .toList();
      }

      return [];
    }

    return SyncPullBundle(
      roles: values('role'),
      users: values('user'),
      departments: values('department'),
      userDepartments: values('user_department'),
      positions: values('position'),
      operators: values('operator'),
      crops: values('crop'),
      tasks: values('task'),
      locations: values('location'),
      diningRooms: values('dining_room'),
      records: values('record'),
      recordLocations: values('record_location'),
      formFields: values('form_field'),
      tableColumns: values('table_column'),
      lockConfigs: const [],
    );
  }

  Map<String, dynamic> _decodePayload(String payloadJson) {
    final decoded = jsonDecode(payloadJson);

    if (decoded is Map<String, dynamic>) {
      return Map<String, dynamic>.from(decoded);
    }

    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    return <String, dynamic>{};
  }

  Map<String, dynamic> _decodeStore(String? rawValue) {
    if (rawValue == null || rawValue.isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(rawValue);

    if (decoded is Map<String, dynamic>) {
      return Map<String, dynamic>.from(decoded);
    }

    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    return <String, dynamic>{};
  }

  bool _isAfterSince(Map<String, dynamic> item, DateTime? since) {
    if (since == null) {
      return true;
    }

    final rawUpdatedAt = item['mockServerUpdatedAt'] ?? item['updatedAt'];
    final updatedAt = rawUpdatedAt is String
        ? DateTime.tryParse(rawUpdatedAt)
        : null;

    return updatedAt == null || updatedAt.isAfter(since);
  }
}

class SyncApiEndpoints {
  const SyncApiEndpoints._();

  static const authLogin = '/auth/login';
  static const users = '/users';
  static const roles = '/roles';
  static const departments = '/departments';
  static const operators = '/operators';
  static const crops = '/crops';
  static const tasks = '/tasks';
  static const locations = '/locations';
  static const diningRooms = '/dining-rooms';
  static const records = '/records';
  static const reports = '/reports';
  static const syncUpload = '/sync/upload';
  static const syncPull = '/sync/pull';
}

class DioSyncApiClient implements RemoteSyncApiClient {
  DioSyncApiClient({required String baseUrl, String? bearerToken})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            if (bearerToken != null && bearerToken.trim().isNotEmpty)
              'Authorization': 'Bearer ${bearerToken.trim()}',
          },
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        ),
      );

  final Dio _dio;

  @override
  Future<UploadResult> uploadQueueItem(SyncQueueItem item) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        SyncApiEndpoints.syncUpload,
        data: {
          'queueId': item.id,
          'entityType': item.entityType,
          'entityId': item.entityId,
          'operation': item.operation,
          'payload': item.payloadJson,
        },
      );

      final data = response.data ?? {};
      final serverId = data['serverId'] as String?;

      if (serverId == null || serverId.isEmpty) {
        throw const AppException(
          'El servidor no devolvió el identificador remoto.',
        );
      }

      return UploadResult(serverId: serverId);
    } on DioException catch (error) {
      throw AppException(_messageFromDio(error));
    }
  }

  @override
  Future<SyncPullBundle> pullChanges({required DateTime? since}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        SyncApiEndpoints.syncPull,
        queryParameters: {if (since != null) 'since': since.toIso8601String()},
      );

      return _bundleFromJson(response.data ?? <String, dynamic>{});
    } on DioException catch (error) {
      throw AppException(_messageFromDio(error));
    }
  }

  SyncPullBundle _bundleFromJson(Map<String, dynamic> data) {
    List<Map<String, dynamic>> listOfMaps(String key) {
      final raw = data[key];

      if (raw is List) {
        return raw
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }

      return [];
    }

    List<RecordLockConfig> lockConfigs() {
      return listOfMaps('lockConfigs').map(RecordLockConfig.fromJson).toList();
    }

    return SyncPullBundle(
      roles: listOfMaps('roles'),
      users: listOfMaps('users'),
      departments: listOfMaps('departments'),
      userDepartments: listOfMaps('userDepartments'),
      positions: listOfMaps('positions'),
      operators: listOfMaps('operators'),
      crops: listOfMaps('crops'),
      tasks: listOfMaps('tasks'),
      locations: listOfMaps('locations'),
      diningRooms: listOfMaps('diningRooms'),
      records: listOfMaps('records'),
      recordLocations: listOfMaps('recordLocations'),
      formFields: listOfMaps('formFields'),
      tableColumns: listOfMaps('tableColumns'),
      lockConfigs: lockConfigs(),
    );
  }

  String _messageFromDio(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map) {
      final message = responseData['message'] ?? responseData['error'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
    }

    final statusCode = error.response?.statusCode;

    if (statusCode == 401 || statusCode == 403) {
      return 'No tienes permisos para sincronizar. Inicia sesión nuevamente.';
    }

    if (statusCode != null && statusCode >= 500) {
      return 'El servidor no está disponible. Los cambios locales se mantienen pendientes.';
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'La conexión tardó demasiado. Se reintentará luego.';
    }

    return 'No se pudo conectar con el servidor. Los cambios locales se mantienen pendientes.';
  }
}
