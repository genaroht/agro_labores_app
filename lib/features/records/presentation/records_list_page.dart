import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const String _columnPrefsKey =
      'records_capture_visible_columns_v1';
  static const List<String> _columnOrder = [
    'department',
    'code',
    'leader',
    'task',
    'lotNetwork',
    'sectors',
    'scheduledWage',
    'realWage',
    'ha',
    'ratio',
  ];
  static const Map<String, String> _columnLabels = {
    'department': 'Departamento',
    'code': 'Código',
    'leader': 'Líder',
    'task': 'Descripción de Labor',
    'lotNetwork': 'Lote - Red',
    'sectors': 'Sectores',
    'scheduledWage': 'Jornal Prog.',
    'realWage': 'Jornal Real',
    'ha': 'Ha',
    'ratio': 'Ratio',
  };
  static const Set<String> _defaultVisibleColumns = {
    'department',
    'code',
    'leader',
    'task',
    'lotNetwork',
    'sectors',
    'scheduledWage',
    'ha',
    'ratio',
  };


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
  final Map<String, bool> _visibleColumns = {
    for (final key in _columnOrder) key: _defaultVisibleColumns.contains(key),
  };

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _loadColumnPreferences();
      await _loadRecords();
    });
  }

  Future<void> _loadColumnPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final visibleKeys = prefs.getStringList(_columnPrefsKey);

    if (visibleKeys == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      for (final key in _columnOrder) {
        _visibleColumns[key] = visibleKeys.contains(key);
      }

      // El switch Jornal Real manda sobre la columna realWage.
      _showRealWage = _visibleColumns['realWage'] ?? false;
    });
  }

  Future<void> _saveColumnPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final visibleKeys = _columnOrder
        .where((key) => _visibleColumns[key] ?? false)
        .toList();

    await prefs.setStringList(_columnPrefsKey, visibleKeys);
  }

  Future<void> _openColumnSettings() async {
    final workingValues = Map<String, bool>.from(_visibleColumns);

    final saved = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Columnas de la vista captura',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: _columnOrder.map((key) {
                          return CheckboxListTile(
                            value: workingValues[key] ?? false,
                            title: Text(_columnLabels[key] ?? key),
                            onChanged: (checked) {
                              setSheetState(() {
                                workingValues[key] = checked ?? false;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setSheetState(() {
                                for (final key in _columnOrder) {
                                  workingValues[key] =
                                      _defaultVisibleColumns.contains(key);
                                }
                              });
                            },
                            child: const Text('Restablecer'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Guardar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (saved != true) {
      return;
    }

    setState(() {
      _visibleColumns
        ..clear()
        ..addAll(workingValues);
      _showRealWage = _visibleColumns['realWage'] ?? false;
    });

    await _saveColumnPreferences();
  }

  Future<void> _downloadCapture() async {
    if (_isLoading || _records.isEmpty) {
      return;
    }

    try {
      final bytes = await _buildCaptureImageBytes();

      if (bytes == null || bytes.isEmpty) {
        _showMessage('No se pudo generar la captura.');
        return;
      }

      final directory = await getTemporaryDirectory();
      final fileName = 'ruta_labores_${_formatFileDate(_selectedDate)}.png';
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(Uint8List.fromList(bytes), flush: true);

      if (!mounted) {
        return;
      }

      final box = context.findRenderObject() as RenderBox?;
      final shareOrigin = box == null
          ? null
          : box.localToGlobal(ui.Offset.zero) & box.size;

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'image/png')],
          text: 'Ruta de labores ${_formatDateLong(_selectedDate)}',
          sharePositionOrigin: shareOrigin,
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        userSafeErrorMessage(
          error,
          fallback: 'No se pudo descargar la captura.',
        ),
      );
    }
  }

  Future<Uint8List?> _buildCaptureImageBytes() async {
    final columns = _activeColumnKeys;
    final rows = _records.map((record) {
      final locations = _locationsByRecord[record.id] ?? [];
      return [
        for (final column in columns) _textForColumn(column, record, locations),
      ];
    }).toList();

    final columnWidths = [
      for (final column in columns) _captureColumnWidth(column),
    ];
    final tableWidth = columnWidths.fold<double>(0, (sum, width) => sum + width);
    final logicalWidth = tableWidth < 720 ? 720.0 : tableWidth + 56;
    final tableLeft = (logicalWidth - tableWidth) / 2;

    const scale = 2.0;
    const outerPadding = 28.0;
    const headerHeight = 56.0;
    const cellHorizontalPadding = 10.0;
    const cellVerticalPadding = 8.0;
    const minRowHeight = 54.0;

    const titleStyle = TextStyle(
      color: Color(0xFF182016),
      fontSize: 30,
      fontWeight: FontWeight.w800,
      height: 1.12,
    );
    const dateStyle = TextStyle(
      color: Color(0xFF182016),
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );
    const headerStyle = TextStyle(
      color: Color(0xFF182016),
      fontSize: 17,
      fontWeight: FontWeight.w800,
    );
    const cellStyle = TextStyle(
      color: Color(0xFF182016),
      fontSize: 17,
      fontWeight: FontWeight.w500,
      height: 1.18,
    );

    final titleText = 'RUTA DE LABORES [${_headerDepartmentName(ref.read(sessionProvider)).toUpperCase()}]';
    final titlePainter = _layoutCaptureText(
      titleText,
      titleStyle,
      logicalWidth - outerPadding * 2,
      textAlign: TextAlign.center,
    );
    final datePainter = _layoutCaptureText(
      'Fecha: ${_formatShortDate(_selectedDate)}',
      dateStyle,
      logicalWidth - outerPadding * 2,
      textAlign: TextAlign.center,
    );

    final rowHeights = <double>[];
    for (final row in rows) {
      var rowHeight = minRowHeight;
      for (var index = 0; index < columns.length; index += 1) {
        final painter = _layoutCaptureText(
          row[index],
          cellStyle,
          columnWidths[index] - cellHorizontalPadding * 2,
        );
        final neededHeight = painter.height + cellVerticalPadding * 2;
        if (neededHeight > rowHeight) {
          rowHeight = neededHeight;
        }
      }
      rowHeights.add(rowHeight);
    }

    final tableHeight = headerHeight + rowHeights.fold<double>(0, (sum, h) => sum + h);
    final logicalHeight = outerPadding +
        titlePainter.height +
        14 +
        datePainter.height +
        28 +
        tableHeight +
        outerPadding;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.scale(scale);

    final backgroundPaint = ui.Paint()..color = const Color(0xFFF8FCF4);
    final headerPaint = ui.Paint()..color = const Color(0xFFC4F1BA);
    final linePaint = ui.Paint()
      ..color = const Color(0xFFBBC8B5)
      ..strokeWidth = 1.2;
    final whitePaint = ui.Paint()..color = const Color(0xFFF8FCF4);

    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, logicalWidth, logicalHeight),
      backgroundPaint,
    );

    var y = outerPadding;
    titlePainter.paint(canvas, ui.Offset((logicalWidth - titlePainter.width) / 2, y));
    y += titlePainter.height + 14;
    datePainter.paint(canvas, ui.Offset((logicalWidth - datePainter.width) / 2, y));
    y += datePainter.height + 28;

    var x = tableLeft;
    for (var index = 0; index < columns.length; index += 1) {
      final width = columnWidths[index];
      final rect = ui.Rect.fromLTWH(x, y, width, headerHeight);
      canvas.drawRect(rect, headerPaint);
      canvas.drawRect(rect, linePaint..style = ui.PaintingStyle.stroke);
      _paintCaptureText(
        canvas,
        _columnLabels[columns[index]] ?? columns[index],
        headerStyle,
        ui.Rect.fromLTWH(
          x + cellHorizontalPadding,
          y + cellVerticalPadding,
          width - cellHorizontalPadding * 2,
          headerHeight - cellVerticalPadding * 2,
        ),
        textAlign: TextAlign.center,
      );
      x += width;
    }

    y += headerHeight;
    for (var rowIndex = 0; rowIndex < rows.length; rowIndex += 1) {
      final row = rows[rowIndex];
      final rowHeight = rowHeights[rowIndex];
      x = tableLeft;
      for (var columnIndex = 0; columnIndex < columns.length; columnIndex += 1) {
        final width = columnWidths[columnIndex];
        final rect = ui.Rect.fromLTWH(x, y, width, rowHeight);
        canvas.drawRect(rect, whitePaint);
        canvas.drawRect(rect, linePaint..style = ui.PaintingStyle.stroke);
        _paintCaptureText(
          canvas,
          row[columnIndex],
          cellStyle,
          ui.Rect.fromLTWH(
            x + cellHorizontalPadding,
            y + cellVerticalPadding,
            width - cellHorizontalPadding * 2,
            rowHeight - cellVerticalPadding * 2,
          ),
        );
        x += width;
      }
      y += rowHeight;
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (logicalWidth * scale).ceil(),
      (logicalHeight * scale).ceil(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    picture.dispose();

    return byteData?.buffer.asUint8List();
  }

  TextPainter _layoutCaptureText(
    String text,
    TextStyle style,
    double maxWidth, {
    TextAlign textAlign = TextAlign.left,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: textAlign,
      textDirection: ui.TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return painter;
  }

  void _paintCaptureText(
    ui.Canvas canvas,
    String text,
    TextStyle style,
    ui.Rect rect, {
    TextAlign textAlign = TextAlign.left,
  }) {
    final painter = _layoutCaptureText(
      text,
      style,
      rect.width,
      textAlign: textAlign,
    );
    final offset = ui.Offset(
      rect.left,
      rect.top + ((rect.height - painter.height) / 2).clamp(0.0, rect.height).toDouble(),
    );
    painter.paint(canvas, offset);
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
                ],
              ),
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
                  labelText: 'Rol activo',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  'Supervisor de ${session.activeDepartment?.name ?? '-'}',
                ),
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
              title: const Text('Mostrar Jornal Real'),
              subtitle: const Text(
                'Útil para comparar programación vs ejecución.',
              ),
              value: _showRealWage,
              onChanged: (value) async {
                setState(() {
                  _showRealWage = value;
                  _visibleColumns['realWage'] = value;
                });
                await _saveColumnPreferences();
              },
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _openColumnSettings,
                  icon: const Icon(Icons.view_column_outlined),
                  label: const Text('Columnas'),
                ),
                FilledButton.icon(
                  onPressed: _records.isEmpty ? null : _downloadCapture,
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Descargar captura'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramTable() {
    final colorScheme = Theme.of(context).colorScheme;
    final visibleColumns = _activeColumnKeys;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        headingRowColor: WidgetStateProperty.all(colorScheme.primaryContainer),
        border: TableBorder.all(color: colorScheme.outlineVariant),
        columnSpacing: 16,
        horizontalMargin: 10,
        columns: visibleColumns
            .map(
              (key) => DataColumn(
                label: _HeaderCell(_columnLabels[key] ?? key),
              ),
            )
            .toList(),
        rows: _records.map((record) {
          final locations = _locationsByRecord[record.id] ?? [];

          return DataRow(
            onSelectChanged: (_) => _openRecord(record),
            cells: visibleColumns.map((key) {
              return DataCell(_cellForColumn(key, record, locations));
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  List<String> get _activeColumnKeys {
    final visible = _columnOrder
        .where((key) => _visibleColumns[key] ?? false)
        .where((key) => key != 'realWage' || _showRealWage)
        .toList();

    if (visible.isEmpty) {
      return ['code', 'leader', 'task'];
    }

    return visible;
  }

  Widget _cellForColumn(
    String key,
    FarmRecord record,
    List<FarmRecordLocation> locations,
  ) {
    switch (key) {
      case 'department':
        return Text(_departmentNameById[record.departmentId] ?? '-');
      case 'code':
        return Text(_operatorCodeByRecord[record.id] ?? '-');
      case 'leader':
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 170),
          child: Text(
            record.leaderNameSnapshot ?? record.operatorNameSnapshot ?? '-',
          ),
        );
      case 'task':
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 210),
          child: Text(record.taskNameSnapshot ?? '-'),
        );
      case 'lotNetwork':
        return Text(_lotNetworkText(record, locations));
      case 'sectors':
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 150),
          child: Text(_sectorText(locations)),
        );
      case 'scheduledWage':
        return Text(_formatNumber(record.scheduledWage));
      case 'realWage':
        return Text(_formatNumber(record.realWage));
      case 'ha':
        return Text(record.ha.toStringAsFixed(2));
      case 'ratio':
        return Text(record.ratio?.toStringAsFixed(2) ?? '-');
      default:
        return const Text('-');
    }
  }

  String _textForColumn(
    String key,
    FarmRecord record,
    List<FarmRecordLocation> locations,
  ) {
    switch (key) {
      case 'department':
        return _departmentNameById[record.departmentId] ?? '-';
      case 'code':
        return _operatorCodeByRecord[record.id] ?? '-';
      case 'leader':
        return record.leaderNameSnapshot ?? record.operatorNameSnapshot ?? '-';
      case 'task':
        return record.taskNameSnapshot ?? '-';
      case 'lotNetwork':
        return _lotNetworkText(record, locations);
      case 'sectors':
        return _sectorText(locations);
      case 'scheduledWage':
        return _formatNumber(record.scheduledWage);
      case 'realWage':
        return _formatNumber(record.realWage);
      case 'ha':
        return record.ha.toStringAsFixed(2);
      case 'ratio':
        return record.ratio?.toStringAsFixed(2) ?? '-';
      default:
        return '-';
    }
  }

  double _captureColumnWidth(String key) {
    switch (key) {
      case 'department':
        return 220;
      case 'code':
        return 96;
      case 'leader':
        return 230;
      case 'task':
        return 270;
      case 'lotNetwork':
        return 150;
      case 'sectors':
        return 170;
      case 'scheduledWage':
        return 130;
      case 'realWage':
        return 130;
      case 'ha':
        return 92;
      case 'ratio':
        return 96;
      default:
        return 150;
    }
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

  String _formatNumber(double? value) {
    if (value == null) {
      return '-';
    }

    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }

  String _formatFileDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '${year}_${month}_$day';
  }

  String _formatDateLong(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  String _formatShortDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString().substring(2);

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
                'RUTA DE LABORES [${departmentName.toUpperCase()}]',
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
