import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/providers/session_provider.dart';

class AdminPanelPage extends ConsumerWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    if (!session.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Panel Admin')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Solo el administrador puede acceder a este panel.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Panel Admin')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Administración',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Usuario: ${session.userName ?? '-'}'),
          const SizedBox(height: 24),
          _AdminTile(
            icon: Icons.people_outline,
            title: 'Usuarios',
            subtitle: 'Crear, editar, desactivar y asignar departamentos',
            route: '/admin/users',
          ),
          _AdminTile(
            icon: Icons.badge_outlined,
            title: 'Operarios',
            subtitle: 'Gestionar operarios por departamento',
            route: '/admin/operators',
          ),
          _AdminTile(
            icon: Icons.business_outlined,
            title: 'Departamentos',
            subtitle: 'Gestionar departamentos activos',
            route: '/admin/departments',
          ),
          _AdminTile(
            icon: Icons.grass_outlined,
            title: 'Cultivos',
            subtitle: 'Gestionar cultivos',
            route: '/admin/crops',
          ),
          _AdminTile(
            icon: Icons.work_outline,
            title: 'Labores',
            subtitle: 'Gestionar labores por departamento',
            route: '/admin/tasks',
          ),
          _AdminTile(
            icon: Icons.map_outlined,
            title: 'Ubicaciones / matriz',
            subtitle: 'Cultivo, lote, red, sector, Ha y comedor sugerido',
            route: '/admin/locations',
          ),
          _AdminTile(
            icon: Icons.lock_clock,
            title: 'Bloqueo de registros',
            subtitle: 'Bloqueo global y horario límite',
            route: '/settings/record-lock',
          ),
          _AdminTile(
            icon: Icons.assignment_outlined,
            title: 'Registros',
            subtitle: 'Ver, filtrar, editar y eliminar registros',
            route: '/admin/records',
          ),
        ],
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  const _AdminTile({
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
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.push(route);
        },
      ),
    );
  }
}
