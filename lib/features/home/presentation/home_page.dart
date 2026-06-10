import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/providers/session_provider.dart';
import '../../../shared/widgets/action_card.dart';
import '../../../shared/widgets/responsive_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final canChangeDepartment =
        !session.isAdmin && session.assignedDepartments.length > 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          if (canChangeDepartment)
            IconButton(
              tooltip: 'Cambiar departamento',
              onPressed: () async {
                await ref
                    .read(sessionProvider.notifier)
                    .clearActiveDepartment();
              },
              icon: const Icon(Icons.swap_horiz),
            ),
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
            icon: Icons.eco_outlined,
            title: 'Hola, ${session.userName ?? 'usuario'}',
            subtitle: session.isAdmin
                ? 'Administrador · acceso completo'
                : '${_roleTitle(session)} de ${session.activeDepartment?.name ?? '-'}',
          ),
          const SizedBox(height: 24),
          PageHeader(
            title: 'Acciones principales',
            subtitle: session.isAdmin
                ? 'Gestiona usuarios, catálogos, registros y reportes.'
                : 'Registra y revisa la ruta de labores del departamento activo.',
          ),
          const SizedBox(height: 16),
          ResponsiveSection(
            minItemWidth: 320,
            children: [
              if (session.isAdmin) ...[
                AppActionCard(
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Panel Admin',
                  subtitle:
                      'Usuarios, catálogos, captura, reportes y bloqueo de registros',
                  onTap: () => context.push('/admin'),
                ),
              ] else ...[
                AppActionCard(
                  icon: Icons.edit_note,
                  title: 'Nuevo registro',
                  subtitle: 'Registrar programación del departamento activo',
                  onTap: () => context.push('/records/new'),
                ),
                AppActionCard(
                  icon: Icons.table_chart_outlined,
                  title: 'Mis registros',
                  subtitle:
                      'Vista captura para revisar y completar jornales reales',
                  onTap: () => context.push('/records'),
                ),
                AppActionCard(
                  icon: Icons.badge_outlined,
                  title: 'Panel Supervisor',
                  subtitle: 'Personas y catálogos operativos',
                  onTap: () => context.push('/supervisor'),
                ),
              ],

            ],
          ),
        ],
      ),
    );
  }
  String _roleTitle(AppSession session) {
    final role = session.roleName?.trim();

    if (role == null || role.isEmpty) {
      return 'Supervisor';
    }

    final lower = role.toLowerCase();

    if (lower == 'supervisor') {
      return 'Supervisor';
    }

    return role[0].toUpperCase() + role.substring(1);
  }
}
