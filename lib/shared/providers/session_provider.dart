import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/security/local_session_storage.dart';

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

    try {
      final database = ref.read(appDatabaseProvider);

      await database.seedDemoData();

      final user = await database.getUserByCodeIncludingInactive(savedUserCode);

      if (user == null || user.deletedAt != null || !user.isActive) {
        await _storage.clearSession();
        state = AppSession.empty;
        return;
      }

      final role = await database.getRoleById(user.roleId);

      if (role == null || role.deletedAt != null) {
        await _storage.clearSession();
        state = AppSession.empty;
        return;
      }

      final departments = await database.getDepartmentsForUserCode(user.code);

      if (departments.isEmpty) {
        await _storage.clearSession();
        state = AppSession.empty;
        return;
      }

      final sessionDepartments = departments
          .map(
            (department) =>
                SessionDepartment(id: department.id, name: department.name),
          )
          .toList();

      final savedActiveDepartmentId = await _storage
          .getSavedActiveDepartmentId();

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

      state = AppSession(
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

      await _storage.saveSession(
        userCode: user.code,
        activeDepartmentId: activeDepartment?.id,
      );
    } catch (_) {
      await _storage.clearSession();
      state = AppSession.empty;
    }
  }

  Future<void> loginWithCodeAndPin({
    required String userCode,
    required String password,
  }) async {
    final cleanUserCode = userCode.trim();
    final cleanPassword = password.trim();

    if (cleanUserCode.isEmpty) {
      throw Exception('El código de usuario es obligatorio.');
    }

    if (!RegExp(r'^\d{6}$').hasMatch(cleanPassword)) {
      throw Exception('La contraseña debe tener exactamente 6 dígitos.');
    }

    final database = ref.read(appDatabaseProvider);

    await database.seedDemoData();

    final user = await database.getUserByCodeIncludingInactive(cleanUserCode);

    if (user == null || user.deletedAt != null) {
      throw Exception('Usuario o contraseña incorrectos.');
    }

    if (!user.isActive) {
      throw Exception('El usuario está inactivo.');
    }

    if (user.passwordPin != cleanPassword) {
      throw Exception('Usuario o contraseña incorrectos.');
    }

    final role = await database.getRoleById(user.roleId);

    if (role == null || role.deletedAt != null) {
      throw Exception('El usuario no tiene un rol válido.');
    }

    final departments = await database.getDepartmentsForUserCode(user.code);

    if (departments.isEmpty) {
      throw Exception('El usuario no tiene departamentos asignados.');
    }

    final sessionDepartments = departments
        .map(
          (department) =>
              SessionDepartment(id: department.id, name: department.name),
        )
        .toList();

    final SessionDepartment? activeDepartment = sessionDepartments.length == 1
        ? sessionDepartments.first
        : null;

    state = AppSession(
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

    await _storage.saveSession(
      userCode: user.code,
      activeDepartmentId: activeDepartment?.id,
    );
  }

  Future<void> selectDepartment(String departmentId) async {
    SessionDepartment? selectedDepartment;

    for (final department in state.assignedDepartments) {
      if (department.id == departmentId) {
        selectedDepartment = department;
        break;
      }
    }

    if (selectedDepartment == null) {
      throw Exception(
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
