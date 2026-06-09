import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_error.dart';
import '../../../data/local/app_database.dart';
import '../../../shared/providers/session_provider.dart';
import '../data/local_record_repository.dart';

class RecordsListPage extends ConsumerStatefulWidget {
  const RecordsListPage({super.key});

  @override
  ConsumerState<RecordsListPage> createState() => _RecordsListPageState();
}

class _RecordsListPageState extends ConsumerState<RecordsListPage> {
  static const String _allDepartmentsFilter = '__all_departments__';

  bool _isLoading = false;
  bool _showRealWage = false;
  String? _message;
  String? _selectedAdminDepartmentId;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  List<FarmRecord> _records = [];
  List<Department> _departments = [];
  final Map<String, List<FarmRecordLocation>> _locationsByRecord = {};
  final Map<String, String> _operatorCodeByRecord = {};
  final Map<String, String> _departmentNameById = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadRecords);
  }

  Future<void> _loadRecords() async {
    final session = ref.read(sessionProvider);
    final activeDepartment = session.activeDepartment;

    if (!session.isAdmin &&
        (activeDepartment == null || session.userId == null)) {
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

      await repository.ensureDevelopmentFormConfig();

      final departments = await repository.getDepartments();
      final departmentNameById = {
        for (final department in departments) department.id: department.name,
      };

      final loadedRecords = session.isAdmin
          ? await repository.getAllActiveRecordsForAdmin()
          : await repository.getRecordsForDepartment(
              departmentId: activeDepartment!.id,
              userId: session.userId!,
              isAdmin: false,
            );

      final validSelectedDepartmentId =
          departments.any(
            (department) => department.id == _selectedAdminDepartmentId,
          )
          ? _selectedAdminDepartmentId
          : null;

      final filteredRecords =
          loadedRecords.where((record) {
            final matchesDate = _isSameDate(record.recordDate, _selectedDate);
            final matchesDepartment =
                !session.isAdmin ||
                validSelectedDepartmentId == null ||
                record.departmentId == validSelectedDepartmentId;

            return matchesDate && matchesDepartment;
          }).toList()..sort((first, second) {
            final departmentCompare =
                (departmentNameById[first.departmentId] ?? '').compareTo(
                  departmentNameById[second.departmentId] ?? '',
                );
            if (departmentCompare != 0) {
              return departmentCompare;
            }

            final leaderCompare =
                (first.leaderNameSnapshot ?? first.operatorNameSnapshot ?? '')
                    .compareTo(
                      second.leaderNameSnapshot ??
                          second.operatorNameSnapshot ??
                          '',
                    );
            if (leaderCompare != 0) {
              return leaderCompare;
            }

            final lotCompare = _lotNetworkTextForSort(
              first,
            ).compareTo(_lotNetworkTextForSort(second));
            if (lotCompare != 0) {
              return lotCompare;
            }

            return first.createdAt.compareTo(second.createdAt);
          });

      final locationsByRecord = await repository.getRecordLocationsForRecords(
        filteredRecords.map((record) => record.id).toList(),
      );
      final operatorsById = await repository.getOperatorsByIds(
        filteredRecords
            .map((record) => record.leaderOperatorId ?? record.operatorId)
            .whereType<String>(),
      );
      final operatorCodeByRecord = <String, String>{};

      for (final record in filteredRecords) {
        final snapshotCode = record.leaderCodeSnapshot;

        if (snapshotCode != null && snapshotCode.trim().isNotEmpty) {
          operatorCodeByRecord[record.id] = snapshotCode.trim();
          continue;
        }

        final operatorId = record.leaderOperatorId ?? record.operatorId;
        final operator = operatorId == null ? null : operatorsById[operatorId];

        if (operator != null) {
          operatorCodeByRecord[record.id] = operator.code;
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _records = filteredRecords;
        _departments = departments;
        _selectedAdminDepartmentId = validSelectedDepartmentId;
        _locationsByRecord
          ..clear()
          ..addAll(locationsByRecord);
        _operatorCodeByRecord
          ..clear()
          ..addAll(operatorCodeByRecord);
        _departmentNameById
          ..clear()
          ..addAll(departmentNameById);
        _message = filteredRecords.isEmpty
            ? 'No hay registros para la fecha seleccionada.'
            : null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _message = userSafeErrorMessage(
          error,
          fallback: 'No se pudieron cargar los registros.',
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date == null) {
      return;
    }

    setState(() {
      _selectedDate = date;
    });

    await _loadRecords();
  }

  Future<void> _openRecord(FarmRecord record) async {
    await context.push('/records/${record.id}/edit');
    await _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final headerDepartmentName = _headerDepartmentName(session);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Volver al inicio',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Vista captura'),
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
          padding: const EdgeInsets.all(16),
          children: [
            _buildFilters(session),
            const SizedBox(height: 12),
            _ProgramCaptureCard(
              departmentName: headerDepartmentName,
              date: _selectedDate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (_message != null && !_isLoading)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(_message!, textAlign: TextAlign.center),
                    ),
                  if (_records.isNotEmpty) _buildProgramTable(),
                  if (_records.isNotEmpty) _buildTotals(),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (_records.isNotEmpty)
              const Text(
                'Para captura manual, gire el celular a horizontal y tome captura de la tarjeta del programa. Toque una fila para abrir el registro.',
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(AppSession session) {
    final selectedAdminDepartmentValue =
        _selectedAdminDepartmentId ?? _allDepartmentsFilter;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Filtros de captura',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (session.isAdmin) ...[
              DropdownButtonFormField<String>(
                initialValue: selectedAdminDepartmentValue,
                decoration: const InputDecoration(
                  labelText: 'Departamento',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(
                    value: _allDepartmentsFilter,
                    child: Text('Todos los departamentos'),
                  ),
                  ..._departments.map(
                    (department) => DropdownMenuItem(
                      value: department.id,
                      child: Text(department.name),
                    ),
                  ),
                ],
                onChanged: (value) async {
                  setState(() {
                    _selectedAdminDepartmentId = value == _allDepartmentsFilter
                        ? null
                        : value;
                  });
                  await _loadRecords();
                },
              ),
              const SizedBox(height: 12),
            ] else
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Departamento activo',
                  border: OutlineInputBorder(),
                ),
                child: Text(session.activeDepartment?.name ?? '-'),
              ),
            if (!session.isAdmin) const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(_formatDateLong(_selectedDate)),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: const Text('Cambiar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Mostrar Jornal real'),
              subtitle: const Text(
                'Útil para comparar programación vs ejecución.',
              ),
              value: _showRealWage,
              onChanged: (value) {
                setState(() {
                  _showRealWage = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramTable() {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        headingRowColor: WidgetStateProperty.all(colorScheme.primaryContainer),
        border: TableBorder.all(color: colorScheme.outlineVariant),
        columnSpacing: 18,
        horizontalMargin: 12,
        columns: [
          const DataColumn(label: _HeaderCell('Departamento')),
          const DataColumn(label: _HeaderCell('Líder')),
          const DataColumn(label: _HeaderCell('Código')),
          const DataColumn(label: _HeaderCell('Descripción de Labor')),
          const DataColumn(label: _HeaderCell('Lote - Red')),
          const DataColumn(label: _HeaderCell('Sectores')),
          const DataColumn(label: _HeaderCell('Jornal')),
          if (_showRealWage)
            const DataColumn(label: _HeaderCell('Jornal real')),
          const DataColumn(label: _HeaderCell('Ha')),
          const DataColumn(label: _HeaderCell('Ratio')),
        ],
        rows: _records.map((record) {
          final locations = _locationsByRecord[record.id] ?? [];

          return DataRow(
            onSelectChanged: (_) => _openRecord(record),
            cells: [
              DataCell(Text(_departmentNameById[record.departmentId] ?? '-')),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: Text(
                    record.leaderNameSnapshot ??
                        record.operatorNameSnapshot ??
                        '-',
                  ),
                ),
              ),
              DataCell(Text(_operatorCodeByRecord[record.id] ?? '-')),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 220),
                  child: Text(record.taskNameSnapshot ?? '-'),
                ),
              ),
              DataCell(Text(_lotNetworkText(record, locations))),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 160),
                  child: Text(_sectorText(locations)),
                ),
              ),
              DataCell(Text(_formatNumber(record.scheduledWage))),
              if (_showRealWage) DataCell(Text(_formatNumber(record.realWage))),
              DataCell(Text(record.ha.toStringAsFixed(2))),
              DataCell(Text(record.ratio?.toStringAsFixed(2) ?? '-')),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTotals() {
    final totalRatio = _totalHa > 0 ? _totalScheduledWage / _totalHa : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          left: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          right: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 18,
        runSpacing: 8,
        children: [
          Text(
            'Registros: ${_records.length}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Total Jornal: ${_formatNumber(_totalScheduledWage)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (_showRealWage)
            Text(
              'Total Jornal real: ${_formatNumber(_totalRealWage)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          Text(
            'Total Ha: ${_totalHa.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Ratio total: ${totalRatio?.toStringAsFixed(2) ?? '-'}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _headerDepartmentName(AppSession session) {
    if (!session.isAdmin) {
      return session.activeDepartment?.name ?? '-';
    }

    if (_selectedAdminDepartmentId == null) {
      return 'Todos los departamentos';
    }

    return _departmentNameById[_selectedAdminDepartmentId] ?? '-';
  }

  String _lotNetworkTextForSort(FarmRecord record) {
    return '${record.lot ?? ''}_${record.network ?? ''}';
  }

  String _lotNetworkText(
    FarmRecord record,
    List<FarmRecordLocation> locations,
  ) {
    if (locations.isEmpty) {
      return _formatLotNetwork(record.lot, record.network);
    }

    final values =
        locations
            .map(
              (location) => _formatLotNetwork(
                location.lotSnapshot,
                location.networkSnapshot,
              ),
            )
            .toSet()
            .toList()
          ..sort(_compareMixedLotNetwork);

    return values.join(', ');
  }

  String _formatLotNetwork(String? lot, String? network) {
    final cleanLot = AgroLocalValueFormatters.compactLot(lot);
    final cleanNetwork = AgroLocalValueFormatters.compactNetwork(network);

    if (cleanLot.isEmpty) {
      return '-';
    }

    if (cleanNetwork.isEmpty) {
      return cleanLot;
    }

    return '${cleanLot}_R$cleanNetwork';
  }

  String _sectorText(List<FarmRecordLocation> locations) {
    if (locations.isEmpty) {
      return '-';
    }

    final sectors =
        locations
            .map(
              (location) => AgroLocalValueFormatters.compactSector(
                location.sectorSnapshot,
              ),
            )
            .where((sector) => sector.isNotEmpty)
            .toSet()
            .toList()
          ..sort(_compareMixedNumbers);

    return sectors.join(', ');
  }

  int _compareMixedLotNetwork(String first, String second) {
    final firstParts = first.split('_R');
    final secondParts = second.split('_R');

    final firstLot = firstParts.isNotEmpty
        ? int.tryParse(firstParts.first)
        : null;
    final secondLot = secondParts.isNotEmpty
        ? int.tryParse(secondParts.first)
        : null;

    if (firstLot != null && secondLot != null && firstLot != secondLot) {
      return firstLot.compareTo(secondLot);
    }

    final firstNetwork = firstParts.length > 1
        ? int.tryParse(firstParts[1])
        : null;
    final secondNetwork = secondParts.length > 1
        ? int.tryParse(secondParts[1])
        : null;

    if (firstNetwork != null && secondNetwork != null) {
      return firstNetwork.compareTo(secondNetwork);
    }

    return first.compareTo(second);
  }

  int _compareMixedNumbers(String first, String second) {
    final firstNumber = int.tryParse(first.trim());
    final secondNumber = int.tryParse(second.trim());

    if (firstNumber != null && secondNumber != null) {
      return firstNumber.compareTo(secondNumber);
    }

    return first.compareTo(second);
  }

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  double get _totalScheduledWage {
    return _records.fold<double>(
      0,
      (total, record) => total + (record.scheduledWage ?? 0),
    );
  }

  double get _totalRealWage {
    return _records.fold<double>(
      0,
      (total, record) => total + (record.realWage ?? 0),
    );
  }

  double get _totalHa {
    return _records.fold<double>(0, (total, record) => total + record.ha);
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

  String _formatDateLong(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}

class _ProgramCaptureCard extends StatelessWidget {
  const _ProgramCaptureCard({
    required this.departmentName,
    required this.date,
    required this.child,
  });

  final String departmentName;
  final DateTime date;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'PROGRAMA DE LABORES [${departmentName.toUpperCase()}]',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Fecha: ${_formatShortDate(date)}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              child,
            ],
          ),
        ),
      ),
    );
  }

  String _formatShortDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString().substring(2);

    return '$day/$month/$year';
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold));
  }
}
