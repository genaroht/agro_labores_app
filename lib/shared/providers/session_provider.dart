import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/app_error.dart';
import '../../core/security/local_session_storage.dart';
import '../../data/local/app_database.dart';
import '../../data/local/database_provider.dart';

class SessionDepartment {
  const SessionDepartment({required this.id, required this.name});

  final String id;
  final String name;
}

class AppSession {
  const AppSession({
    required this.isLoading,
    required this.isLoggedIn,
    required this.userId,
    required this.userCode,
    required this.userName,
    required this.roleId,
    required this.roleName,
    required this.isAdmin,
    required this.assignedDepartments,
    required this.activeDepartment,
  });

  final bool isLoading;
  final bool isLoggedIn;
  final String? userId;
  final String? userCode;
  final String? userName;
  final String? roleId;
  final String? roleName;
  final bool isAdmin;
  final List<SessionDepartment> assignedDepartments;
  final SessionDepartment? activeDepartment;

  AppSession copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    String? userId,
    String? userCode,
    String? userName,
    String? roleId,
    String? roleName,
    bool? isAdmin,
    List<SessionDepartment>? assignedDepartments,
    SessionDepartment? activeDepartment,
    bool clearActiveDepartment = false,
  }) {
    return AppSession(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userId: userId ?? this.userId,
      userCode: userCode ?? this.userCode,
      userName: userName ?? this.userName,
      roleId: roleId ?? this.roleId,
      roleName: roleName ?? this.roleName,
      isAdmin: isAdmin ?? this.isAdmin,
      assignedDepartments: assignedDepartments ?? this.assignedDepartments,
      activeDepartment: clearActiveDepartment
          ? null
          : activeDepartment ?? this.activeDepartment,
    );
  }

  static const loading = AppSession(
    isLoading: true,
    isLoggedIn: false,
    userId: null,
    userCode: null,
    userName: null,
    roleId: null,
    roleName: null,
    isAdmin: false,
    assignedDepartments: [],
    activeDepartment: null,
  );

  static const empty = AppSession(
    isLoading: false,
    isLoggedIn: false,
    userId: null,
    userCode: null,
    userName: null,
    roleId: null,
    roleName: null,
    isAdmin: false,
    assignedDepartments: [],
    activeDepartment: null,
  );
}

class SessionNotifier extends Notifier<AppSession> {
  final LocalSessionStorage _storage = LocalSessionStorage();

  @override
  AppSession build() {
    Future.microtask(_restoreSavedSession);
    return AppSession.loading;
  }

  Future<void> _restoreSavedSession() async {
    final savedUserCode = await _storage.getSavedUserCode();

    if (savedUserCode == null || savedUserCode.trim().isEmpty) {
      state = AppSession.empty;
      return;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(savedUserCode.trim())) {
      await _storage.clearSession();
      state = AppSession.empty;
      return;
    }

    try {
      final database = ref.read(appDatabaseProvider);
      final session = await _buildSessionFromUser(
        database: database,
        userCode: savedUserCode.trim(),
        savedActiveDepartmentId: await _storage.getSavedActiveDepartmentId(),
      );

      if (session == null) {
        await _storage.clearSession();
        state = AppSession.empty;
        return;
      }

      state = session;

      await _storage.saveSession(
        userCode: session.userCode!,
        activeDepartmentId: session.activeDepartment?.id,
      );
    } catch (_) {
      await _storage.clearSession();
      state = AppSession.empty;
    }
  }

  Future<AppSession?> _buildSessionFromUser({
    required AppDatabase database,
    required String userCode,
    required String? savedActiveDepartmentId,
  }) async {
    final user = await database.getUserByCodeIncludingInactive(userCode);

    if (user == null || user.deletedAt != null || !user.isActive) {
      return null;
    }

    final role = await database.getRoleById(user.roleId);

    if (role == null || role.deletedAt != null) {
      return null;
    }

    final departments = role.isAdmin
        ? await database.getActiveDepartments()
        : await database.getDepartmentsForUserCode(user.code);
    final sessionDepartments = departments
        .map(
          (department) =>
              SessionDepartment(id: department.id, name: department.name),
        )
        .toList();

    if (!role.isAdmin && sessionDepartments.isEmpty) {
      return null;
    }

    SessionDepartment? activeDepartment;

    if (sessionDepartments.length == 1) {
      activeDepartment = sessionDepartments.first;
    } else if (savedActiveDepartmentId != null) {
      for (final department in sessionDepartments) {
        if (department.id == savedActiveDepartmentId) {
          activeDepartment = department;
          break;
        }
      }
    }

    if (role.isAdmin &&
        activeDepartment == null &&
        sessionDepartments.isNotEmpty) {
      activeDepartment = sessionDepartments.first;
    }

    return AppSession(
      isLoading: false,
      isLoggedIn: true,
      userId: user.id,
      userCode: user.code,
      userName: user.fullName,
      roleId: role.id,
      roleName: role.name,
      isAdmin: role.isAdmin,
      assignedDepartments: sessionDepartments,
      activeDepartment: activeDepartment,
    );
  }

  Future<void> loginWithCodeAndPin({
    required String userCode,
    required String password,
  }) async {
    final cleanUserCode = userCode.trim();
    final cleanPassword = password.trim();

    if (cleanUserCode.isEmpty || cleanPassword.isEmpty) {
      throw const AppException('Ingrese su código y contraseña.');
    }

    final database = ref.read(appDatabaseProvider);
    final user = await database.getUserByCodeIncludingInactive(cleanUserCode);

    if (user == null || user.deletedAt != null) {
      throw const AppException('Usuario o contraseña incorrectos.');
    }

    if (!user.isActive) {
      throw const AppException('El usuario está inactivo.');
    }

    if (!_constantTimeEquals(user.passwordPin, cleanPassword)) {
      throw const AppException('Usuario o contraseña incorrectos.');
    }

    final session = await _buildSessionFromUser(
      database: database,
      userCode: cleanUserCode,
      savedActiveDepartmentId: null,
    );

    if (session == null) {
      throw const AppException('El usuario no tiene rol o permisos válidos.');
    }

    state = session;

    await _storage.saveSession(
      userCode: session.userCode!,
      activeDepartmentId: session.activeDepartment?.id,
    );
  }

  bool _constantTimeEquals(String left, String right) {
    if (left.length != right.length) {
      return false;
    }

    var difference = 0;

    for (var i = 0; i < left.length; i++) {
      difference |= left.codeUnitAt(i) ^ right.codeUnitAt(i);
    }

    return difference == 0;
  }

  Future<void> selectDepartment(String departmentId) async {
    if (state.isAdmin) {
      return;
    }

    SessionDepartment? selectedDepartment;

    for (final department in state.assignedDepartments) {
      if (department.id == departmentId) {
        selectedDepartment = department;
        break;
      }
    }

    if (selectedDepartment == null) {
      throw const AppException(
        'El departamento seleccionado no está asignado al usuario.',
      );
    }

    state = state.copyWith(activeDepartment: selectedDepartment);

    final userCode = state.userCode;

    if (userCode != null) {
      await _storage.saveSession(
        userCode: userCode,
        activeDepartmentId: selectedDepartment.id,
      );
    }
  }

  Future<void> clearActiveDepartment() async {
    if (state.isAdmin || state.assignedDepartments.length <= 1) {
      return;
    }

    state = state.copyWith(clearActiveDepartment: true);

    final userCode = state.userCode;

    if (userCode != null) {
      await _storage.saveSession(userCode: userCode, activeDepartmentId: null);
    }
  }

  Future<void> logout() async {
    await _storage.clearSession();
    state = AppSession.empty;
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, AppSession>(
  SessionNotifier.new,
);
