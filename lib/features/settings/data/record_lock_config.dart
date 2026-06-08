import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordLockConfig {
  const RecordLockConfig({
    required this.departmentId,
    required this.globalLockEnabled,
    required this.cutoffTime,
    required this.allowAdminOverride,
    required this.message,
    required this.updatedAt,
    required this.syncStatus,
  });

  final String departmentId;
  final bool globalLockEnabled;
  final String? cutoffTime;
  final bool allowAdminOverride;
  final String message;
  final DateTime updatedAt;
  final String syncStatus;

  factory RecordLockConfig.defaultForDepartment(String departmentId) {
    return RecordLockConfig(
      departmentId: departmentId,
      globalLockEnabled: false,
      cutoffTime: null,
      allowAdminOverride: true,
      message: 'Los registros están bloqueados por administración.',
      updatedAt: DateTime.now(),
      syncStatus: 'sincronizado',
    );
  }

  RecordLockConfig copyWith({
    bool? globalLockEnabled,
    String? cutoffTime,
    bool clearCutoffTime = false,
    bool? allowAdminOverride,
    String? message,
    DateTime? updatedAt,
    String? syncStatus,
  }) {
    return RecordLockConfig(
      departmentId: departmentId,
      globalLockEnabled: globalLockEnabled ?? this.globalLockEnabled,
      cutoffTime: clearCutoffTime ? null : cutoffTime ?? this.cutoffTime,
      allowAdminOverride: allowAdminOverride ?? this.allowAdminOverride,
      message: message ?? this.message,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departmentId': departmentId,
      'globalLockEnabled': globalLockEnabled,
      'cutoffTime': cutoffTime,
      'allowAdminOverride': allowAdminOverride,
      'message': message,
      'updatedAt': updatedAt.toIso8601String(),
      'syncStatus': syncStatus,
    };
  }

  factory RecordLockConfig.fromJson(Map<String, dynamic> json) {
    return RecordLockConfig(
      departmentId: json['departmentId'] as String,
      globalLockEnabled: json['globalLockEnabled'] as bool? ?? false,
      cutoffTime: json['cutoffTime'] as String?,
      allowAdminOverride: json['allowAdminOverride'] as bool? ?? true,
      message:
          json['message'] as String? ??
          'Los registros están bloqueados por administración.',
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      syncStatus: json['syncStatus'] as String? ?? 'sincronizado',
    );
  }
}

class RecordLockRepository {
  static const _keyPrefix = 'record_lock_config_';

  String _keyForDepartment(String departmentId) {
    return '$_keyPrefix$departmentId';
  }

  Future<RecordLockConfig> getConfig(String departmentId) async {
    final prefs = await SharedPreferences.getInstance();
    final rawValue = prefs.getString(_keyForDepartment(departmentId));

    if (rawValue == null || rawValue.trim().isEmpty) {
      return RecordLockConfig.defaultForDepartment(departmentId);
    }

    try {
      final decoded = jsonDecode(rawValue);

      if (decoded is Map<String, dynamic>) {
        return RecordLockConfig.fromJson(decoded);
      }

      return RecordLockConfig.defaultForDepartment(departmentId);
    } catch (_) {
      return RecordLockConfig.defaultForDepartment(departmentId);
    }
  }

  Future<void> saveConfig(RecordLockConfig config) async {
    final prefs = await SharedPreferences.getInstance();

    final configToSave = config.copyWith(
      updatedAt: DateTime.now(),
      syncStatus: 'pendiente',
    );

    await prefs.setString(
      _keyForDepartment(config.departmentId),
      jsonEncode(configToSave.toJson()),
    );
  }

  String? validateCanSave({
    required RecordLockConfig config,
    required bool isAdmin,
    required DateTime now,
  }) {
    if (isAdmin && config.allowAdminOverride) {
      return null;
    }

    if (config.globalLockEnabled) {
      return config.message.trim().isEmpty
          ? 'Los registros están bloqueados por administración.'
          : config.message.trim();
    }

    final cutoffTime = config.cutoffTime;

    if (cutoffTime != null && cutoffTime.trim().isNotEmpty) {
      final nowMinutes = now.hour * 60 + now.minute;
      final cutoffMinutes = _parseTimeToMinutes(cutoffTime);

      if (cutoffMinutes != null && nowMinutes > cutoffMinutes) {
        return 'No se puede crear o editar registros después de las $cutoffTime.';
      }
    }

    return null;
  }

  int? _parseTimeToMinutes(String value) {
    final parts = value.split(':');

    if (parts.length != 2) {
      return null;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) {
      return null;
    }

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return hour * 60 + minute;
  }
}

final recordLockRepositoryProvider = Provider<RecordLockRepository>((ref) {
  return RecordLockRepository();
});
