import 'package:shared_preferences/shared_preferences.dart';

class LocalSessionStorage {
  static const _userCodeKey = 'session_user_code';
  static const _activeDepartmentIdKey = 'session_active_department_id';

  /// Persistimos solo el código de usuario y el departamento activo.
  /// La contraseña/PIN nunca se guarda en preferencias locales.
  Future<void> saveSession({
    required String userCode,
    String? activeDepartmentId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cleanUserCode = userCode.trim();

    await prefs.setString(_userCodeKey, cleanUserCode);

    if (activeDepartmentId == null || activeDepartmentId.trim().isEmpty) {
      await prefs.remove(_activeDepartmentIdKey);
    } else {
      await prefs.setString(_activeDepartmentIdKey, activeDepartmentId.trim());
    }
  }

  Future<String?> getSavedUserCode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_userCodeKey)?.trim();

    return value == null || value.isEmpty ? null : value;
  }

  Future<String?> getSavedActiveDepartmentId() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_activeDepartmentIdKey)?.trim();

    return value == null || value.isEmpty ? null : value;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await Future.wait([
      prefs.remove(_userCodeKey),
      prefs.remove(_activeDepartmentIdKey),
    ]);
  }
}
