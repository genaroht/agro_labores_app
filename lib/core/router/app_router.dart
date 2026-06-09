import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/admin_catalog_pages.dart';
import '../../features/admin/presentation/admin_panel_page.dart';
import '../../features/admin/presentation/admin_records_page.dart';
import '../../features/admin/presentation/admin_users_page.dart';
import '../../features/admin/presentation/supervisor_panel_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/departments/presentation/department_selector_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/records/presentation/dynamic_record_form_page.dart';
import '../../features/records/presentation/records_list_page.dart';
import '../../features/reports/presentation/admin_reports_page.dart';
import '../../features/settings/presentation/record_lock_settings_page.dart';
import '../../features/sync/presentation/sync_page.dart';
import '../../shared/providers/session_provider.dart';
import '../../shared/widgets/status_message.dart';

class RouterRefreshNotifier extends ChangeNotifier {
  bool _isDisposed = false;
  bool _refreshScheduled = false;

  void refresh() {
    if (_isDisposed || _refreshScheduled) {
      return;
    }

    _refreshScheduled = true;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshScheduled = false;

      if (!_isDisposed) {
        notifyListeners();
      }
    });

    SchedulerBinding.instance.ensureVisualUpdate();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

final routerRefreshNotifierProvider = Provider<RouterRefreshNotifier>((ref) {
  final notifier = RouterRefreshNotifier();

  ref.listen(sessionProvider, (previous, next) {
    notifier.refresh();
  });

  ref.onDispose(notifier.dispose);

  return notifier;
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(routerRefreshNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refreshNotifier,
    errorBuilder: (context, state) => const _RouteErrorPage(),
    redirect: (context, state) {
      final session = ref.read(sessionProvider);

      if (session.isLoading) {
        return null;
      }

      final currentPath = state.uri.path;
      final isLoggedIn = session.isLoggedIn;
      final isLoginRoute = currentPath == '/login';
      final isDepartmentSelectorRoute = currentPath == '/select-department';
      final isAdminRoute =
          currentPath == '/admin' || currentPath.startsWith('/admin/');

      if (!isLoggedIn) {
        return isLoginRoute ? null : '/login';
      }

      if (isAdminRoute && !session.isAdmin) {
        return '/home';
      }

      final needsDepartmentSelection =
          !session.isAdmin &&
          session.assignedDepartments.length > 1 &&
          session.activeDepartment == null;

      if (needsDepartmentSelection && !isDepartmentSelectorRoute) {
        return '/select-department';
      }

      if (!needsDepartmentSelection && isDepartmentSelectorRoute) {
        return '/home';
      }

      if (isLoginRoute) {
        return needsDepartmentSelection ? '/select-department' : '/home';
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
        path: '/operators',
        name: 'operators',
        builder: (context, state) => const AdminOperatorsPage(),
      ),
      GoRoute(
        path: '/settings/record-lock',
        name: 'recordLockSettings',
        builder: (context, state) => const RecordLockSettingsPage(),
      ),
      GoRoute(
        path: '/sync',
        name: 'sync',
        builder: (context, state) => const SyncPage(),
      ),
      GoRoute(
        path: '/supervisor',
        name: 'supervisorPanel',
        builder: (context, state) => const SupervisorPanelPage(),
      ),
      GoRoute(
        path: '/supervisor/operators',
        name: 'supervisorOperators',
        builder: (context, state) => const AdminOperatorsPage(),
      ),
      GoRoute(
        path: '/supervisor/departments',
        name: 'supervisorDepartments',
        builder: (context, state) => const AdminDepartmentsPage(),
      ),
      GoRoute(
        path: '/supervisor/crops',
        name: 'supervisorCrops',
        builder: (context, state) => const AdminCropsPage(),
      ),
      GoRoute(
        path: '/supervisor/tasks',
        name: 'supervisorTasks',
        builder: (context, state) => const AdminTasksPage(),
      ),
      GoRoute(
        path: '/supervisor/dining-rooms',
        name: 'supervisorDiningRooms',
        builder: (context, state) => const AdminDiningRoomsPage(),
      ),
      GoRoute(
        path: '/supervisor/locations',
        name: 'supervisorLocations',
        builder: (context, state) => const AdminLocationsPage(),
      ),
      GoRoute(
        path: '/admin',
        name: 'adminPanel',
        builder: (context, state) => const AdminPanelPage(),
      ),
      GoRoute(
        path: '/admin/users',
        name: 'adminUsers',
        builder: (context, state) => const AdminUsersPage(),
      ),
      GoRoute(
        path: '/admin/operators',
        name: 'adminOperators',
        builder: (context, state) => const AdminOperatorsPage(),
      ),
      GoRoute(
        path: '/admin/departments',
        name: 'adminDepartments',
        builder: (context, state) => const AdminDepartmentsPage(),
      ),
      GoRoute(
        path: '/admin/crops',
        name: 'adminCrops',
        builder: (context, state) => const AdminCropsPage(),
      ),
      GoRoute(
        path: '/admin/tasks',
        name: 'adminTasks',
        builder: (context, state) => const AdminTasksPage(),
      ),
      GoRoute(
        path: '/admin/dining-rooms',
        name: 'adminDiningRooms',
        builder: (context, state) => const AdminDiningRoomsPage(),
      ),
      GoRoute(
        path: '/admin/locations',
        name: 'adminLocations',
        builder: (context, state) => const AdminLocationsPage(),
      ),
      GoRoute(
        path: '/admin/records',
        name: 'adminRecords',
        builder: (context, state) => const AdminRecordsPage(),
      ),
      GoRoute(
        path: '/admin/reports',
        name: 'adminReports',
        builder: (context, state) => const AdminReportsPage(),
      ),
    ],
  );
});

class _RouteErrorPage extends StatelessWidget {
  const _RouteErrorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página no encontrada')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AppEmptyState(
            icon: Icons.travel_explore_outlined,
            title: 'Ruta no disponible',
            message:
                'La pantalla solicitada no existe o no está disponible para tu usuario.',
            action: FilledButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.home_outlined),
              label: const Text('Ir al inicio'),
            ),
          ),
        ),
      ),
    );
  }
}
