import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_environment.dart';
import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';

class DatabaseDebugPage extends ConsumerStatefulWidget {
  const DatabaseDebugPage({super.key});

  @override
  ConsumerState<DatabaseDebugPage> createState() => _DatabaseDebugPageState();
}

class _DatabaseDebugPageState extends ConsumerState<DatabaseDebugPage> {
  bool _isLoading = false;
  String? _message;

  int _usersCount = 0;
  int _departmentsCount = 0;
  int _locationsCount = 0;
  int _syncQueueCount = 0;

  List<Department> _departmentsForUser = [];

  Future<void> _seedAndLoad() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      if (!AppEnvironment.enableDevelopmentSeed) {
        throw Exception(
          'Esta herramienta solo está disponible en modo desarrollo.',
        );
      }

      final database = ref.read(appDatabaseProvider);

      await database.seedDevelopmentData();

      final usersCount = await database.countUsers();
      final departmentsCount = await database.countDepartments();
      final locationsCount = await database.countLocations();
      final syncQueueCount = await database.countSyncQueueItems();

      final departmentsForUser = await database.getDepartmentsForUserCode(
        '000001',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _usersCount = usersCount;
        _departmentsCount = departmentsCount;
        _locationsCount = locationsCount;
        _syncQueueCount = syncQueueCount;
        _departmentsForUser = departmentsForUser;
        _message = 'Datos de desarrollo insertados correctamente.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _message = 'Error: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadOnly() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final database = ref.read(appDatabaseProvider);

      final usersCount = await database.countUsers();
      final departmentsCount = await database.countDepartments();
      final locationsCount = await database.countLocations();
      final syncQueueCount = await database.countSyncQueueItems();

      final departmentsForUser = await database.getDepartmentsForUserCode(
        '000001',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _usersCount = usersCount;
        _departmentsCount = departmentsCount;
        _locationsCount = locationsCount;
        _syncQueueCount = syncQueueCount;
        _departmentsForUser = departmentsForUser;
        _message = 'Consulta local ejecutada correctamente.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _message = 'Error: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(_loadOnly);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de base local')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Base local Drift/SQLite',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Esta pantalla sirve solo para verificar que la base local funciona.',
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _isLoading ? null : _seedAndLoad,
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.storage),
            label: const Text('Insertar datos de prueba'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _isLoading ? null : _loadOnly,
            icon: const Icon(Icons.search),
            label: const Text('Consultar base local'),
          ),
          const SizedBox(height: 24),
          if (_message != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_message!),
              ),
            ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _InfoTile(label: 'Usuarios', value: _usersCount.toString()),
                const Divider(height: 1),
                _InfoTile(
                  label: 'Departamentos',
                  value: _departmentsCount.toString(),
                ),
                const Divider(height: 1),
                _InfoTile(
                  label: 'Ubicaciones',
                  value: _locationsCount.toString(),
                ),
                const Divider(height: 1),
                _InfoTile(
                  label: 'Cola de sincronización',
                  value: _syncQueueCount.toString(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Departamentos asignados al usuario 001',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_departmentsForUser.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No hay departamentos asignados. Presiona "Insertar datos de prueba".',
                ),
              ),
            )
          else
            Card(
              child: Column(
                children: _departmentsForUser
                    .map(
                      (department) => ListTile(
                        leading: const Icon(Icons.business_outlined),
                        title: Text(department.name),
                        subtitle: Text('ID: ${department.id}'),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
