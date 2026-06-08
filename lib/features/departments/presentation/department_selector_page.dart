import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/session_provider.dart';

class DepartmentSelectorPage extends ConsumerWidget {
  const DepartmentSelectorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final departments = session.assignedDepartments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar departamento'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await ref.read(sessionProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.business_outlined,
                      size: 56,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Hola, ${session.userName ?? 'usuario'}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Elige con qué departamento trabajarás.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (departments.isEmpty)
                      const Text(
                        'No tienes departamentos asignados.',
                        style: TextStyle(color: Colors.red),
                      )
                    else
                      ...departments.map(
                        (department) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await ref
                                    .read(sessionProvider.notifier)
                                    .selectDepartment(department.id);
                              },
                              icon: const Icon(Icons.arrow_forward),
                              label: Text(department.name),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
