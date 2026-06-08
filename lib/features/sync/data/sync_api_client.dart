import 'dart:async';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    required this.operators,
    required this.crops,
    required this.tasks,
    required this.locations,
    required this.formFields,
    required this.lockConfigs,
  });

  final List<Map<String, dynamic>> roles;
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> departments;
  final List<Map<String, dynamic>> userDepartments;
  final List<Map<String, dynamic>> operators;
  final List<Map<String, dynamic>> crops;
  final List<Map<String, dynamic>> tasks;
  final List<Map<String, dynamic>> locations;
  final List<Map<String, dynamic>> formFields;
  final List<RecordLockConfig> lockConfigs;

  int get downloadedCount {
    return roles.length +
        users.length +
        departments.length +
        userDepartments.length +
        operators.length +
        crops.length +
        tasks.length +
        locations.length +
        formFields.length +
        lockConfigs.length;
  }
}

abstract class RemoteSyncApiClient {
  Future<UploadResult> uploadQueueItem(SyncQueueItem item);

  Future<SyncPullBundle> pullChanges({required DateTime? since});
}

class MockRemoteSyncApiClient implements RemoteSyncApiClient {
  static const _failKey = 'mock_sync_server_should_fail';

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
      throw Exception('Servidor simulado no disponible.');
    }

    return UploadResult(serverId: 'srv_${item.entityId}');
  }

  @override
  Future<SyncPullBundle> pullChanges({required DateTime? since}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (await shouldFail()) {
      throw Exception(
        'No se pudieron descargar cambios del servidor simulado.',
      );
    }

    return SyncPullBundle(
      roles: const [
        {'id': 'role_admin', 'name': 'admin', 'isAdmin': true},
        {'id': 'role_user', 'name': 'usuario', 'isAdmin': false},
      ],
      users: const [
        {
          'id': 'user_001',
          'code': '001',
          'fullName': 'Usuario Demo',
          'passwordPin': '123456',
          'roleId': 'role_user',
          'isActive': true,
        },
        {
          'id': 'user_002',
          'code': '002',
          'fullName': 'Usuario Un Departamento',
          'passwordPin': '123456',
          'roleId': 'role_user',
          'isActive': true,
        },
        {
          'id': 'user_admin',
          'code': 'admin',
          'fullName': 'Administrador Demo',
          'passwordPin': '123456',
          'roleId': 'role_admin',
          'isActive': true,
        },
      ],
      departments: const [
        {
          'id': 'dep_labores_arandano',
          'name': 'Labores Arándano',
          'isActive': true,
        },
        {
          'id': 'dep_cosecha_arandano',
          'name': 'Cosecha Arándano',
          'isActive': true,
        },
        {
          'id': 'dep_palto_fondo_01',
          'name': 'Palto Fondo 01',
          'isActive': true,
        },
      ],
      userDepartments: const [
        {
          'id': 'user_001_dep_labores',
          'userId': 'user_001',
          'departmentId': 'dep_labores_arandano',
        },
        {
          'id': 'user_001_dep_cosecha',
          'userId': 'user_001',
          'departmentId': 'dep_cosecha_arandano',
        },
        {
          'id': 'user_002_dep_palto',
          'userId': 'user_002',
          'departmentId': 'dep_palto_fondo_01',
        },
        {
          'id': 'admin_dep_labores',
          'userId': 'user_admin',
          'departmentId': 'dep_labores_arandano',
        },
        {
          'id': 'admin_dep_cosecha',
          'userId': 'user_admin',
          'departmentId': 'dep_cosecha_arandano',
        },
        {
          'id': 'admin_dep_palto',
          'userId': 'user_admin',
          'departmentId': 'dep_palto_fondo_01',
        },
      ],
      operators: const [
        {
          'id': 'op_server_01',
          'code': 'OPS01',
          'fullName': 'Operario descargado del servidor',
          'departmentId': 'dep_labores_arandano',
          'isActive': true,
        },
      ],
      crops: const [
        {'id': 'crop_arandano', 'name': 'Arándano', 'isActive': true},
        {'id': 'crop_palto', 'name': 'Palto', 'isActive': true},
      ],
      tasks: const [
        {
          'id': 'task_control_calidad',
          'departmentId': 'dep_cosecha_arandano',
          'name': 'Control de calidad',
          'defaultDetail': 'Control descargado del servidor',
          'isActive': true,
        },
      ],
      locations: const [
        {
          'id': 'loc_ar_l2_r1_s1',
          'cropId': 'crop_arandano',
          'lot': 'Lote 02',
          'network': 'Red 01',
          'sector': 'Sector 01',
          'ha': 1.75,
          'suggestedDiningRoom': 'Comedor 3',
          'isActive': true,
        },
      ],
      formFields: const [],
      lockConfigs: [
        RecordLockConfig(
          departmentId: 'dep_labores_arandano',
          globalLockEnabled: false,
          cutoffTime: null,
          allowAdminOverride: true,
          message: 'Los registros están bloqueados por administración.',
          updatedAt: DateTime(2026, 1, 1, 8, 0),
          syncStatus: 'sincronizado',
        ),
      ],
    );
  }
}

class DioSyncApiClient implements RemoteSyncApiClient {
  DioSyncApiClient({required String baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20),
        ),
      );

  final Dio _dio;

  @override
  Future<UploadResult> uploadQueueItem(SyncQueueItem item) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/sync/upload',
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
      throw Exception('El servidor no devolvió serverId.');
    }

    return UploadResult(serverId: serverId);
  }

  @override
  Future<SyncPullBundle> pullChanges({required DateTime? since}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/sync/pull',
      queryParameters: {if (since != null) 'since': since.toIso8601String()},
    );

    final data = response.data ?? {};

    List<Map<String, dynamic>> listOfMaps(String key) {
      final raw = data[key];

      if (raw is List) {
        return raw.whereType<Map<String, dynamic>>().toList();
      }

      return [];
    }

    return SyncPullBundle(
      roles: listOfMaps('roles'),
      users: listOfMaps('users'),
      departments: listOfMaps('departments'),
      userDepartments: listOfMaps('userDepartments'),
      operators: listOfMaps('operators'),
      crops: listOfMaps('crops'),
      tasks: listOfMaps('tasks'),
      locations: listOfMaps('locations'),
      formFields: listOfMaps('formFields'),
      lockConfigs: const [],
    );
  }
}
