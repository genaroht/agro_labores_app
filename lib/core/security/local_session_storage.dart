import 'package:shared_preferences/shared_preferences.dart';

class LocalSessionStorage {
  static const _userCodeKey = 'session_user_code';
  static const _activeDepartmentIdKey = 'session_active_department_id';

  Future<void> saveSession({
    required String userCode,
    String? activeDepartmentId,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userCodeKey, userCode);

    if (activeDepartmentId == null) {
      await prefs.remove(_activeDepartmentIdKey);
    } else {
      await prefs.setString(_activeDepartmentIdKey, activeDepartmentId);
    }
  }

  Future<String?> getSavedUserCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userCodeKey);
  }

  Future<String?> getSavedActiveDepartmentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeDepartmentIdKey);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userCodeKey);
    await prefs.remove(_activeDepartmentIdKey);
  }
}
