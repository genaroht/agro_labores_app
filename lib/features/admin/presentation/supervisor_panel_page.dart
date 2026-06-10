import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/providers/session_provider.dart';
import '../../../shared/widgets/action_card.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../../../shared/widgets/status_message.dart';

class SupervisorPanelPage extends ConsumerWidget {
  const SupervisorPanelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    if (session.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Panel Supervisor')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppEmptyState(
              icon: Icons.admin_panel_settings_outlined,
              title: 'Usa el Panel Admin',
              message:
                  'El administrador gestiona estas opciones desde el panel administrativo.',
              action: FilledButton.icon(
                onPressed: () => context.go('/admin'),
                icon: const Icon(Icons.admin_panel_settings_outlined),
                label: const Text('Ir al Panel Admin'),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Supervisor'),
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
      ),
      body: ResponsivePage(
        children: [
          PageHeader(
            icon: Icons.supervisor_account_outlined,
            title: 'Panel Supervisor',
            subtitle:
                'Administra solo lo operativo del departamento: operarios, labores, comedores y ubicaciones.',
          ),
          const SizedBox(height: 24),
          ResponsiveSection(
            minItemWidth: 320,
            children: [
              AppActionCard(
                icon: Icons.badge_outlined,
                title: 'Operarios / personas',
                subtitle: 'Crear y editar personas del departamento',
                onTap: () => context.push('/supervisor/operators'),
              ),
              AppActionCard(
                icon: Icons.work_outline,
                title: 'Labores',
                subtitle: 'Crear labores por departamento y cultivo',
                onTap: () => context.push('/supervisor/tasks'),
              ),
              AppActionCard(
                icon: Icons.restaurant_outlined,
                title: 'Comedores',
                subtitle: 'Crear comedores por cultivo, lote y red',
                onTap: () => context.push('/supervisor/dining-rooms'),
              ),
              AppActionCard(
                icon: Icons.map_outlined,
                title: 'Ubicaciones',
                subtitle: 'Crear matriz de cultivo, lote, red y sector',
                onTap: () => context.push('/supervisor/locations'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
