import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/providers/session_provider.dart';
import '../../../shared/widgets/action_card.dart';
import '../../../shared/widgets/metric_card.dart';
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
                ? 'Acceso administrativo a todos los departamentos.'
                : 'Departamento activo: ${session.activeDepartment?.name ?? '-'}',
          ),
          const SizedBox(height: 24),
          ResponsiveSection(
            maxColumns: 3,
            children: [
              MetricCard(
                icon: Icons.badge_outlined,
                label: 'Código',
                value: session.userCode ?? '-',
              ),
              MetricCard(
                icon: Icons.work_outline,
                label: 'Cargo',
                value: session.roleName ?? '-',
              ),
              MetricCard(
                icon: Icons.account_tree_outlined,
                label: 'Acceso',
                value: session.isAdmin ? 'Administrador' : 'Supervisor',
                emphasize: session.isAdmin,
              ),
            ],
          ),
          const SizedBox(height: 24),
          PageHeader(
            title: 'Acciones principales',
            subtitle: session.isAdmin
                ? 'Entra al panel para administrar catálogos, reportes, captura y bloqueos.'
                : 'Atajos para registrar, revisar captura, mantener personas y sincronizar.',
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
              AppActionCard(
                icon: Icons.sync,
                title: 'Sincronización',
                subtitle: 'Subir pendientes y descargar cambios',
                onTap: () => context.push('/sync'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
