import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/providers/session_provider.dart';
import '../../../shared/widgets/action_card.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../../../shared/widgets/status_message.dart';

class AdminPanelPage extends ConsumerWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    if (!session.isAdmin) {
      return const Scaffold(
        appBar: _AdminAppBar(),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: AppEmptyState(
              icon: Icons.lock_outline,
              title: 'Acceso restringido',
              message: 'Solo el administrador puede acceder a este panel.',
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const _AdminAppBar(),
      body: ResponsivePage(
        children: [
          PageHeader(
            icon: Icons.admin_panel_settings_outlined,
            title: 'Administración',
            subtitle:
                'Usuario: ${session.userName ?? '-'} · Control central de catálogos, registros y reportes.',
          ),
          const SizedBox(height: 24),
          ResponsiveSection(
            minItemWidth: 340,
            children: [
              _AdminCard(
                icon: Icons.people_outline,
                title: 'Usuarios',
                subtitle: 'Crear, editar, desactivar y asignar departamentos',
                route: '/admin/users',
              ),
              _AdminCard(
                icon: Icons.manage_accounts_outlined,
                title: 'Cargos / accesos',
                subtitle: 'Crear accesos de administrador o supervisor',
                route: '/admin/roles',
              ),
              _AdminCard(
                icon: Icons.badge_outlined,
                title: 'Operarios / Personas',
                subtitle: 'Gestionar personas, códigos, departamentos y cargos',
                route: '/admin/operators',
              ),
              _AdminCard(
                icon: Icons.business_outlined,
                title: 'Departamentos',
                subtitle: 'Gestionar departamentos activos',
                route: '/admin/departments',
              ),
              _AdminCard(
                icon: Icons.grass_outlined,
                title: 'Cultivos',
                subtitle: 'Gestionar cultivos disponibles',
                route: '/admin/crops',
              ),
              _AdminCard(
                icon: Icons.work_outline,
                title: 'Labores',
                subtitle:
                    'Código, descripción, departamento y cultivo automático',
                route: '/admin/tasks',
              ),
              _AdminCard(
                icon: Icons.restaurant_outlined,
                title: 'Comedores',
                subtitle: 'Asignar comedor por cultivo, lote y red',
                route: '/admin/dining-rooms',
              ),
              _AdminCard(
                icon: Icons.map_outlined,
                title: 'Ubicaciones / matriz',
                subtitle: 'Cultivo, lote, red, sector, Ha y comedor sugerido',
                route: '/admin/locations',
              ),
              _AdminCard(
                icon: Icons.lock_clock,
                title: 'Bloqueo de registros',
                subtitle: 'Bloqueo global y horario límite',
                route: '/settings/record-lock',
              ),
              _AdminCard(
                icon: Icons.edit_note,
                title: 'Nuevo registro',
                subtitle: 'Registrar programación en cualquier departamento',
                route: '/records/new',
              ),
              _AdminCard(
                icon: Icons.table_chart_outlined,
                title: 'Vista captura',
                subtitle: 'Tabla limpia para captura y envío por WhatsApp',
                route: '/records',
              ),
              _AdminCard(
                icon: Icons.assignment_outlined,
                title: 'Registros',
                subtitle: 'Ver, filtrar, editar y eliminar registros',
                route: '/admin/records',
              ),
              _AdminCard(
                icon: Icons.file_download_outlined,
                title: 'Reportes',
                subtitle:
                    'Filtrar, seleccionar columnas y exportar CSV o Excel',
                route: '/admin/reports',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _AdminAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('Panel Admin'),
      actions: [
        IconButton(
          tooltip: 'Sincronizar',
          onPressed: () => context.push('/sync'),
          icon: const Icon(Icons.sync),
        ),
        IconButton(
          tooltip: 'Cerrar sesión',
          onPressed: () async {
            await ref.read(sessionProvider.notifier).logout();
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }
}

class _AdminCard extends StatelessWidget {
  const _AdminCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  @override
  Widget build(BuildContext context) {
    return AppActionCard(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: () => context.push(route),
    );
  }
}
