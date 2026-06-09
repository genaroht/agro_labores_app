import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../shared/providers/session_provider.dart';
import '../data/report_export_service.dart';
import '../data/report_models.dart';
import '../data/report_repository.dart';

class AdminReportsPage extends ConsumerStatefulWidget {
  const AdminReportsPage({super.key});

  @override
  ConsumerState<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends ConsumerState<AdminReportsPage> {
  final _weekController = TextEditingController();

  bool _isLoading = false;
  bool _isExporting = false;
  String? _message;

  ReportFilters _filters = const ReportFilters();
  List<ReportRow> _rows = [];

  List<Department> _departments = [];
  List<Crop> _crops = [];
  List<FarmTask> _tasks = [];
  List<FarmOperator> _operators = [];
  List<LocalUser> _users = [];
  List<DiningRoom> _diningRooms = [];
  List<String> _lots = [];
  List<String> _networks = [];
  List<String> _sectors = [];

  final Set<ReportColumn> _selectedColumns = {...defaultReportColumns};

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadCatalogsAndRows);
  }

  @override
  void dispose() {
    _weekController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalogsAndRows() async {
    final session = ref.read(sessionProvider);

    if (!session.isAdmin) {
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final repository = ref.read(reportRepositoryProvider);

      final departments = await repository.getDepartments();
      final crops = await repository.getCrops();
      final tasks = await repository.getTasks();
      final operators = await repository.getOperators();
      final users = await repository.getUsers();
      final diningRooms = await repository.getDiningRooms();
      final lots = await repository.getLots();
      final networks = await repository.getNetworks();
      final sectors = await repository.getSectors();
      final rows = await repository.getReportRows(_filters);

      if (!mounted) {
        return;
      }

      setState(() {
        _departments = departments;
        _crops = crops;
        _tasks = tasks;
        _operators = operators;
        _users = users;
        _diningRooms = diningRooms;
        _lots = lots;
        _networks = networks;
        _sectors = sectors;
        _rows = rows;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _message = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadRows() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final repository = ref.read(reportRepositoryProvider);
      final rows = await repository.getReportRows(_filters);

      if (!mounted) {
        return;
      }

      setState(() {
        _rows = rows;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _message = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickDateFrom() async {
    final date = await _pickDate(_filters.dateFrom ?? DateTime.now());

    if (date == null) {
      return;
    }

    setState(() {
      _filters = _filters.copyWith(dateFrom: date);
    });

    await _loadRows();
  }

  Future<void> _pickDateTo() async {
    final date = await _pickDate(_filters.dateTo ?? DateTime.now());

    if (date == null) {
      return;
    }

    setState(() {
      _filters = _filters.copyWith(dateTo: date);
    });

    await _loadRows();
  }

  Future<DateTime?> _pickDate(DateTime initialDate) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
  }

  Future<void> _applyWeekFilter() async {
    final rawValue = _weekController.text.trim();

    if (rawValue.isEmpty) {
      setState(() {
        _filters = _filters.copyWith(clearWeekNumber: true);
      });

      await _loadRows();
      return;
    }

    final week = int.tryParse(rawValue);

    if (week == null || week < 1 || week > 53) {
      _showMessage('Ingrese una semana válida entre 1 y 53.');
      return;
    }

    setState(() {
      _filters = _filters.copyWith(weekNumber: week);
    });

    await _loadRows();
  }

  Future<void> _clearFilters() async {
    setState(() {
      _filters = const ReportFilters();
      _weekController.clear();
    });

    await _loadRows();
  }

  Future<void> _exportCsv() async {
    await _export(
      exporter: () {
        return ref
            .read(reportExportServiceProvider)
            .exportCsv(rows: _rows, columns: _orderedSelectedColumns());
      },
    );
  }

  Future<void> _exportExcel() async {
    await _export(
      exporter: () {
        return ref
            .read(reportExportServiceProvider)
            .exportExcel(rows: _rows, columns: _orderedSelectedColumns());
      },
    );
  }

  Future<void> _export({required Future<File> Function() exporter}) async {
    if (_rows.isEmpty) {
      _showMessage('No hay datos para exportar.');
      return;
    }

    if (_selectedColumns.isEmpty) {
      _showMessage('Seleccione al menos una columna.');
      return;
    }

    setState(() {
      _isExporting = true;
      _message = null;
    });

    try {
      final file = await exporter();
      final exportService = ref.read(reportExportServiceProvider);

      await exportService.shareFile(file);

      if (!mounted) {
        return;
      }

      _showMessage('Archivo generado correctamente.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  List<ReportColumn> _orderedSelectedColumns() {
    return defaultReportColumns
        .where((column) => _selectedColumns.contains(column))
        .toList();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);

    if (!session.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reportes')),
        body: const Center(
          child: Text('Solo el administrador puede acceder a reportes.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes admin'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _isLoading ? null : _loadCatalogsAndRows,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Reportes y exportación Excel',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'El Excel exporta un sector por fila. Si un registro tiene 3 sectores, se generan 3 filas con los datos generales repetidos.',
          ),
          const SizedBox(height: 16),
          if (_message != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_message!),
              ),
            ),
          _buildFiltersCard(),
          const SizedBox(height: 16),
          _buildColumnsCard(),
          const SizedBox(height: 16),
          _buildActionsCard(),
          const SizedBox(height: 16),
          _buildPreviewCard(),
        ],
      ),
    );
  }

  Widget _buildFiltersCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Filtros admin',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildDateFilterRow(),
            const SizedBox(height: 12),
            _buildWeekField(),
            const SizedBox(height: 12),
            _buildDepartmentDropdown(),
            const SizedBox(height: 12),
            _buildCropDropdown(),
            const SizedBox(height: 12),
            _buildTaskDropdown(),
            const SizedBox(height: 12),
            _buildLeaderDropdown(),
            const SizedBox(height: 12),
            _buildCreatedByUserDropdown(),
            const SizedBox(height: 12),
            _buildTextOptionDropdown(
              label: 'Lote',
              value: _filters.lot,
              values: _lots,
              onChanged: (value) async {
                setState(() {
                  _filters = value == null
                      ? _filters.copyWith(clearLot: true)
                      : _filters.copyWith(lot: value);
                });
                await _loadRows();
              },
            ),
            const SizedBox(height: 12),
            _buildTextOptionDropdown(
              label: 'Red',
              value: _filters.network,
              values: _networks,
              onChanged: (value) async {
                setState(() {
                  _filters = value == null
                      ? _filters.copyWith(clearNetwork: true)
                      : _filters.copyWith(network: value);
                });
                await _loadRows();
              },
            ),
            const SizedBox(height: 12),
            _buildTextOptionDropdown(
              label: 'Sector',
              value: _filters.sector,
              values: _sectors,
              onChanged: (value) async {
                setState(() {
                  _filters = value == null
                      ? _filters.copyWith(clearSector: true)
                      : _filters.copyWith(sector: value);
                });
                await _loadRows();
              },
            ),
            const SizedBox(height: 12),
            _buildDiningRoomDropdown(),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear_all),
                label: const Text('Limpiar filtros'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilterRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickDateFrom,
                icon: const Icon(Icons.date_range),
                label: Text(
                  _filters.dateFrom == null
                      ? 'Fecha desde'
                      : 'Desde: ${_formatDate(_filters.dateFrom!)}',
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Quitar fecha desde',
              onPressed: () async {
                setState(() {
                  _filters = _filters.copyWith(clearDateFrom: true);
                });
                await _loadRows();
              },
              icon: const Icon(Icons.clear),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickDateTo,
                icon: const Icon(Icons.date_range),
                label: Text(
                  _filters.dateTo == null
                      ? 'Fecha hasta'
                      : 'Hasta: ${_formatDate(_filters.dateTo!)}',
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Quitar fecha hasta',
              onPressed: () async {
                setState(() {
                  _filters = _filters.copyWith(clearDateTo: true);
                });
                await _loadRows();
              },
              icon: const Icon(Icons.clear),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _weekController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Semana',
              hintText: 'Ejemplo: 25',
            ),
            onSubmitted: (_) => _applyWeekFilter(),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(onPressed: _applyWeekFilter, child: const Text('Aplicar')),
      ],
    );
  }

  Widget _buildDepartmentDropdown() {
    return DropdownButtonFormField<String?>(
      initialValue: _filters.departmentId,
      decoration: const InputDecoration(labelText: 'Departamento'),
      items: [
        const DropdownMenuItem<String?>(value: null, child: Text('Todos')),
        ..._departments.map(
          (item) =>
              DropdownMenuItem<String?>(value: item.id, child: Text(item.name)),
        ),
      ],
      onChanged: (value) async {
        setState(() {
          _filters = value == null
              ? _filters.copyWith(clearDepartmentId: true)
              : _filters.copyWith(departmentId: value);
        });
        await _loadRows();
      },
    );
  }

  Widget _buildCropDropdown() {
    return DropdownButtonFormField<String?>(
      initialValue: _filters.cropId,
      decoration: const InputDecoration(labelText: 'Cultivo'),
      items: [
        const DropdownMenuItem<String?>(value: null, child: Text('Todos')),
        ..._crops.map(
          (item) =>
              DropdownMenuItem<String?>(value: item.id, child: Text(item.name)),
        ),
      ],
      onChanged: (value) async {
        setState(() {
          _filters = value == null
              ? _filters.copyWith(clearCropId: true)
              : _filters.copyWith(cropId: value);
        });
        await _loadRows();
      },
    );
  }

  Widget _buildTaskDropdown() {
    return DropdownButtonFormField<String?>(
      initialValue: _filters.taskId,
      decoration: const InputDecoration(labelText: 'Labor'),
      items: [
        const DropdownMenuItem<String?>(value: null, child: Text('Todas')),
        ..._tasks.map(
          (item) => DropdownMenuItem<String?>(
            value: item.id,
            child: Text(_taskLabel(item)),
          ),
        ),
      ],
      onChanged: (value) async {
        setState(() {
          _filters = value == null
              ? _filters.copyWith(clearTaskId: true)
              : _filters.copyWith(taskId: value);
        });
        await _loadRows();
      },
    );
  }

  Widget _buildLeaderDropdown() {
    return DropdownButtonFormField<String?>(
      initialValue: _filters.leaderOperatorId,
      decoration: const InputDecoration(labelText: 'Líder'),
      items: [
        const DropdownMenuItem<String?>(value: null, child: Text('Todos')),
        ..._operators.map(
          (item) => DropdownMenuItem<String?>(
            value: item.id,
            child: Text('${item.code} - ${item.fullName}'),
          ),
        ),
      ],
      onChanged: (value) async {
        setState(() {
          _filters = value == null
              ? _filters.copyWith(clearLeaderOperatorId: true)
              : _filters.copyWith(leaderOperatorId: value);
        });
        await _loadRows();
      },
    );
  }

  Widget _buildCreatedByUserDropdown() {
    return DropdownButtonFormField<String?>(
      initialValue: _filters.createdByUserId,
      decoration: const InputDecoration(labelText: 'Usuario registrador'),
      items: [
        const DropdownMenuItem<String?>(value: null, child: Text('Todos')),
        ..._users.map(
          (item) => DropdownMenuItem<String?>(
            value: item.id,
            child: Text('${item.code} - ${item.fullName}'),
          ),
        ),
      ],
      onChanged: (value) async {
        setState(() {
          _filters = value == null
              ? _filters.copyWith(clearCreatedByUserId: true)
              : _filters.copyWith(createdByUserId: value);
        });
        await _loadRows();
      },
    );
  }

  Widget _buildDiningRoomDropdown() {
    return DropdownButtonFormField<String?>(
      initialValue: _filters.diningRoomId,
      decoration: const InputDecoration(labelText: 'Comedor'),
      items: [
        const DropdownMenuItem<String?>(value: null, child: Text('Todos')),
        ..._diningRooms.map(
          (item) => DropdownMenuItem<String?>(
            value: item.id,
            child: Text(_diningRoomLabel(item)),
          ),
        ),
      ],
      onChanged: (value) async {
        setState(() {
          _filters = value == null
              ? _filters.copyWith(clearDiningRoomId: true)
              : _filters.copyWith(diningRoomId: value);
        });
        await _loadRows();
      },
    );
  }

  Widget _buildTextOptionDropdown({
    required String label,
    required String? value,
    required List<String> values,
    required Future<void> Function(String? value) onChanged,
  }) {
    final safeValue = values.contains(value) ? value : null;

    return DropdownButtonFormField<String?>(
      initialValue: safeValue,
      decoration: InputDecoration(labelText: label),
      items: [
        const DropdownMenuItem<String?>(value: null, child: Text('Todos')),
        ...values.map(
          (item) => DropdownMenuItem<String?>(value: item, child: Text(item)),
        ),
      ],
      onChanged: onChanged,
    );
  }

  Widget _buildColumnsCard() {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.view_column_outlined),
        title: const Text('Columnas de exportación'),
        subtitle: Text('${_selectedColumns.length} columnas seleccionadas'),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedColumns
                        ..clear()
                        ..addAll(defaultReportColumns);
                    });
                  },
                  child: const Text('Seleccionar todo'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedColumns.clear();
                    });
                  },
                  child: const Text('Quitar todo'),
                ),
              ],
            ),
          ),
          ...defaultReportColumns.map(
            (column) => CheckboxListTile(
              value: _selectedColumns.contains(column),
              title: Text(column.label),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _selectedColumns.add(column);
                  } else {
                    _selectedColumns.remove(column);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard() {
    final totalHaSector = _rows.fold<double>(
      0,
      (previous, row) => previous + row.haSector,
    );
    final uniqueRecordRows = _uniqueRowsByRecord(_rows);
    final totalHaByRecord = uniqueRecordRows.fold<double>(
      0,
      (previous, row) => previous + row.haTotal,
    );
    final totalScheduled = uniqueRecordRows.fold<double>(
      0,
      (previous, row) => previous + (row.scheduledWage ?? 0),
    );
    final totalReal = uniqueRecordRows.fold<double>(
      0,
      (previous, row) => previous + (row.realWage ?? 0),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.table_chart_outlined),
              title: Text('Filas encontradas: ${_rows.length}'),
              subtitle: Text(
                'Registros únicos: ${uniqueRecordRows.length} | Ha sectores: ${totalHaSector.toStringAsFixed(2)} | Ha registros: ${totalHaByRecord.toStringAsFixed(2)} | Jornal prog.: ${totalScheduled.toStringAsFixed(2)} | Jornal real: ${totalReal.toStringAsFixed(2)}',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isExporting ? null : _exportCsv,
                    icon: const Icon(Icons.description_outlined),
                    label: const Text('CSV'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isExporting ? null : _exportExcel,
                    icon: const Icon(Icons.grid_on_outlined),
                    label: const Text('Excel'),
                  ),
                ),
              ],
            ),
            if (_isExporting) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  List<ReportRow> _uniqueRowsByRecord(List<ReportRow> rows) {
    final seen = <String>{};
    final result = <ReportRow>[];

    for (final row in rows) {
      if (seen.add(row.recordId)) {
        result.add(row);
      }
    }

    return result;
  }

  Widget _buildPreviewCard() {
    final columns = _orderedSelectedColumns();

    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_rows.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No hay registros para mostrar.'),
        ),
      );
    }

    if (columns.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Seleccione columnas para ver la tabla.'),
        ),
      );
    }

    final previewRows = _rows.take(50).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vista previa: ${previewRows.length} de ${_rows.length} filas. Cada sector se muestra como una fila independiente.',
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: columns
                    .map((column) => DataColumn(label: Text(column.label)))
                    .toList(),
                rows: previewRows
                    .map(
                      (row) => DataRow(
                        cells: columns
                            .map(
                              (column) => DataCell(
                                Text(
                                  _formatCellValue(row.valueForColumn(column)),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _taskLabel(FarmTask item) {
    final code = item.code?.trim();

    if (code != null && code.isNotEmpty) {
      return '$code - ${item.name}';
    }

    return item.name;
  }

  String _diningRoomLabel(DiningRoom item) {
    final lot = AgroLocalValueFormatters.compactLot(item.lot);
    final network = AgroLocalValueFormatters.compactNetwork(item.network);
    final location = <String>[
      if (lot.isNotEmpty) 'Lote $lot',
      if (network.isNotEmpty) 'Red $network',
    ].join(' | ');

    if (location.isEmpty) {
      return item.name;
    }

    return '${item.name} ($location)';
  }

  String _formatCellValue(Object? value) {
    if (value == null) {
      return '';
    }

    if (value is double) {
      return value.toStringAsFixed(2);
    }

    return value.toString();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}
