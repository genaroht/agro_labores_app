import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/providers/session_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            tooltip: 'Cambiar departamento',
            onPressed: () async {
              await ref.read(sessionProvider.notifier).clearActiveDepartment();
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
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sesión activa',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(label: 'Usuario', value: session.userName ?? '-'),
                  _InfoRow(label: 'Código', value: session.userCode ?? '-'),
                  _InfoRow(label: 'Rol', value: session.roleName ?? '-'),
                  _InfoRow(
                    label: 'Es admin',
                    value: session.isAdmin ? 'Sí' : 'No',
                  ),
                  _InfoRow(
                    label: 'Departamento activo',
                    value: session.activeDepartment?.name ?? '-',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_note),
                  title: const Text('Nuevo registro'),
                  subtitle: const Text('Formulario dinámico por departamento'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/records/new');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.list_alt),
                  title: const Text('Mis registros'),
                  subtitle: Text(
                    session.isAdmin
                        ? 'Ver y administrar registros del departamento'
                        : 'Ver y editar mis registros',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/records');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('Probar base local'),
                  subtitle: const Text('Insertar y consultar datos offline'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/debug/database');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.sync),
                  title: const Text('Sincronización'),
                  subtitle: const Text('Próxima fase: estado offline/online'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
