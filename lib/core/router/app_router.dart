import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/debug/presentation/database_debug_page.dart';
import '../../features/departments/presentation/department_selector_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/records/presentation/dynamic_record_form_page.dart';
import '../../features/records/presentation/records_list_page.dart';
import '../../features/settings/presentation/record_lock_settings_page.dart';
import '../../shared/providers/session_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      if (session.isLoading) {
        return null;
      }

      final isLoggedIn = session.isLoggedIn;
      final hasActiveDepartment = session.activeDepartment != null;

      final currentPath = state.uri.path;

      final isLoginRoute = currentPath == '/login';
      final isDepartmentSelectorRoute = currentPath == '/select-department';

      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }

      if (isLoggedIn && !hasActiveDepartment && !isDepartmentSelectorRoute) {
        return '/select-department';
      }

      if (isLoggedIn && hasActiveDepartment && isLoginRoute) {
        return '/home';
      }

      if (isLoggedIn && hasActiveDepartment && isDepartmentSelectorRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/select-department',
        name: 'selectDepartment',
        builder: (context, state) => const DepartmentSelectorPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/records',
        name: 'records',
        builder: (context, state) => const RecordsListPage(),
      ),
      GoRoute(
        path: '/records/new',
        name: 'newRecord',
        builder: (context, state) => const DynamicRecordFormPage(),
      ),
      GoRoute(
        path: '/records/:recordId/edit',
        name: 'editRecord',
        builder: (context, state) {
          final recordId = state.pathParameters['recordId'];

          return DynamicRecordFormPage(recordId: recordId);
        },
      ),
      GoRoute(
        path: '/settings/record-lock',
        name: 'recordLockSettings',
        builder: (context, state) => const RecordLockSettingsPage(),
      ),
      GoRoute(
        path: '/debug/database',
        name: 'databaseDebug',
        builder: (context, state) => const DatabaseDebugPage(),
      ),
    ],
  );
});
