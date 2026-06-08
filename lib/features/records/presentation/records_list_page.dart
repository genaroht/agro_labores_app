import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/local/app_database.dart';
import '../../../shared/providers/session_provider.dart';
import '../data/local_record_repository.dart';

class RecordsListPage extends ConsumerStatefulWidget {
  const RecordsListPage({super.key});

  @override
  ConsumerState<RecordsListPage> createState() => _RecordsListPageState();
}

class _RecordsListPageState extends ConsumerState<RecordsListPage> {
  bool _isLoading = false;
  String? _message;
  List<FarmRecord> _records = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadRecords);
  }

  Future<void> _loadRecords() async {
    final session = ref.read(sessionProvider);
    final activeDepartment = session.activeDepartment;

    if (activeDepartment == null || session.userId == null) {
      setState(() {
        _message = 'No hay departamento activo.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final repository = ref.read(localRecordRepositoryProvider);

      await repository.ensureDemoFormConfig();

      final records = await repository.getRecordsForDepartment(
        departmentId: activeDepartment.id,
        userId: session.userId!,
        isAdmin: session.isAdmin,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _records = records;
        _message = records.isEmpty ? 'No hay registros todavía.' : null;
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

  Future<void> _confirmDelete(FarmRecord record) async {
    final session = ref.read(sessionProvider);

    if (!session.isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solo el administrador puede eliminar registros.'),
        ),
      );
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar registro'),
          content: const Text(
            'El registro será eliminado de forma lógica. ¿Desea continuar?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    try {
      final repository = ref.read(localRecordRepositoryProvider);

      await repository.deleteRecordAsAdmin(
        recordId: record.id,
        isAdmin: session.isAdmin,
      );

      await _loadRecords();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro eliminado correctamente.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final activeDepartmentName = session.activeDepartment?.name ?? '-';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _isLoading ? null : _loadRecords,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/records/new');
          await _loadRecords();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadRecords,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Departamento: $activeDepartmentName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
            if (_message != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_message!),
                ),
              ),
            if (_records.isNotEmpty)
              ..._records.map(
                (record) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.assignment_outlined),
                    title: Text(
                      record.taskNameSnapshot ?? 'Registro sin labor',
                    ),
                    subtitle: Text(
                      'Fecha: ${_formatDate(record.recordDate)} | Semana: ${record.weekNumber}\n'
                      'Operario: ${record.operatorNameSnapshot ?? '-'} | Estado: ${record.syncStatus}',
                    ),
                    isThreeLine: true,
                    trailing: Wrap(
                      spacing: 4,
                      children: [
                        IconButton(
                          tooltip: 'Editar',
                          onPressed: () async {
                            await context.push('/records/${record.id}/edit');
                            await _loadRecords();
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        if (session.isAdmin)
                          IconButton(
                            tooltip: 'Eliminar',
                            onPressed: () => _confirmDelete(record),
                            icon: const Icon(Icons.delete_outline),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}
