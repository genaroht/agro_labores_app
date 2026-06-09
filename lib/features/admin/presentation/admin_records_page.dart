import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/local/app_database.dart';
import '../../../shared/providers/session_provider.dart';
import '../../records/data/local_record_repository.dart';
import '../data/admin_repository.dart';

class AdminRecordsPage extends ConsumerStatefulWidget {
  const AdminRecordsPage({super.key});

  @override
  ConsumerState<AdminRecordsPage> createState() => _AdminRecordsPageState();
}

class _AdminRecordsPageState extends ConsumerState<AdminRecordsPage> {
  bool _isLoading = false;

  List<FarmRecord> _records = [];
  List<Department> _departments = [];
  List<Crop> _crops = [];
  List<FarmTask> _tasks = [];
  List<FarmOperator> _operators = [];

  String? _departmentId;
  String? _cropId;
  String? _taskId;
  String? _operatorId;
  String? _lot;
  String? _network;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadCatalogsAndRecords);
  }

  Future<void> _loadCatalogsAndRecords() async {
    final session = ref.read(sessionProvider);

    if (!session.isAdmin) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ref.read(adminRepositoryProvider);

      await repository.ensureDevelopmentSeedData();

      final departments = await repository.getDepartments();
      final crops = await repository.getCrops();
      final tasks = await repository.getTasks();
      final operators = await repository.getOperators();

      if (!mounted) {
        return;
      }

      setState(() {
        _departments = departments;
        _crops = crops;
        _tasks = tasks;
        _operators = operators;
      });

      await _loadRecords();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadRecords() async {
    final repository = ref.read(adminRepositoryProvider);

    final records = await repository.getFilteredRecords(
      departmentId: _departmentId,
      cropId: _cropId,
      taskId: _taskId,
      operatorId: _operatorId,
      lot: _lot,
      network: _network,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _records = records;
    });
  }

  Future<void> _pickDateFrom() async {
    final date = await _pickDate(_dateFrom ?? DateTime.now());

    if (date == null) {
      return;
    }

    setState(() {
      _dateFrom = date;
    });

    await _loadRecords();
  }

  Future<void> _pickDateTo() async {
    final date = await _pickDate(_dateTo ?? DateTime.now());

    if (date == null) {
      return;
    }

    setState(() {
      _dateTo = date;
    });

    await _loadRecords();
  }

  Future<DateTime?> _pickDate(DateTime initialDate) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
  }

  Future<void> _deleteRecord(FarmRecord record) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar registro'),
        content: const Text(
          'Se eliminará de forma lógica y quedará pendiente de sincronización.',
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
      ),
    );

    if (shouldDelete != true) {
      return;
    }

    final repository = ref.read(localRecordRepositoryProvider);

    await repository.deleteRecordAsAdmin(recordId: record.id, isAdmin: true);

    await _loadRecords();
  }

  void _clearFilters() {
    setState(() {
      _departmentId = null;
      _cropId = null;
      _taskId = null;
      _operatorId = null;
      _lot = null;
      _network = null;
      _dateFrom = null;
      _dateTo = null;
    });

    _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);

    if (!session.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Registros admin')),
        body: const Center(child: Text('Acceso solo para admin.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros admin'),
        actions: [
          IconButton(
            onPressed: _loadCatalogsAndRecords,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildFilters(),
                const SizedBox(height: 16),
                Text(
                  'Registros encontrados: ${_records.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (_records.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No hay registros con los filtros actuales.'),
                    ),
                  )
                else
                  ..._records.map(
                    (record) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.assignment_outlined),
                        title: Text(record.taskNameSnapshot ?? 'Registro'),
                        subtitle: Text(
                          'Fecha: ${_formatDate(record.recordDate)} | Semana: ${record.weekNumber}\n'
                          'Departamento: ${_departmentName(record.departmentId)} | Cultivo: ${record.cropNameSnapshot ?? '-'}\n'
                          'Lote: ${record.lot ?? '-'} | Red: ${record.network ?? '-'} | Ha: ${record.ha.toStringAsFixed(2)} | Ratio: ${record.ratio?.toStringAsFixed(2) ?? '-'}\n'
                          'Líder: ${record.leaderNameSnapshot ?? record.operatorNameSnapshot ?? '-'} | '
                          'Jornal programado: ${_formatNumber(record.scheduledWage)} | '
                          'Jornal real: ${_formatNumber(record.realWage)} | Estado: ${record.syncStatus}',
                        ),
                        isThreeLine: true,
                        trailing: Wrap(
                          children: [
                            IconButton(
                              onPressed: () async {
                                await context.push(
                                  '/records/${record.id}/edit',
                                );
                                await _loadRecords();
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () => _deleteRecord(record),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildFilters() {
    final lots =
        _records
            .map((record) => record.lot)
            .whereType<String>()
            .toSet()
            .toList()
          ..sort();

    final networks =
        _records
            .map((record) => record.network)
            .whereType<String>()
            .toSet()
            .toList()
          ..sort();

    final lotInitialValue = lots.contains(_lot) ? _lot : null;
    final networkInitialValue = networks.contains(_network) ? _network : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Filtros',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _departmentId,
              decoration: const InputDecoration(labelText: 'Departamento'),
              items: _departments
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.id,
                      child: Text(item.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _departmentId = value;
                  _lot = null;
                  _network = null;
                });
                _loadRecords();
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _cropId,
              decoration: const InputDecoration(labelText: 'Cultivo'),
              items: _crops
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.id,
                      child: Text(item.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _cropId = value;
                  _lot = null;
                  _network = null;
                });
                _loadRecords();
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _taskId,
              decoration: const InputDecoration(labelText: 'Labor'),
              items: _tasks
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.id,
                      child: Text(item.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _taskId = value;
                  _lot = null;
                  _network = null;
                });
                _loadRecords();
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _operatorId,
              decoration: const InputDecoration(labelText: 'Líder / persona'),
              items: _operators
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.id,
                      child: Text('${item.code} - ${item.fullName}'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _operatorId = value;
                  _lot = null;
                  _network = null;
                });
                _loadRecords();
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: lotInitialValue,
              decoration: const InputDecoration(labelText: 'Lote'),
              items: lots
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _lot = value;
                  _network = null;
                });
                _loadRecords();
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: networkInitialValue,
              decoration: const InputDecoration(labelText: 'Red'),
              items: networks
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _network = value);
                _loadRecords();
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDateFrom,
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      _dateFrom == null
                          ? 'Fecha desde'
                          : 'Desde: ${_formatDate(_dateFrom!)}',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDateTo,
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      _dateTo == null
                          ? 'Fecha hasta'
                          : 'Hasta: ${_formatDate(_dateTo!)}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear),
                label: const Text('Limpiar filtros'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _departmentName(String id) {
    for (final department in _departments) {
      if (department.id == id) {
        return department.name;
      }
    }

    return id;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  String _formatNumber(double? value) {
    if (value == null) {
      return '-';
    }

    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }
}
