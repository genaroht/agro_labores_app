import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/local/app_database.dart';
import '../../../shared/providers/session_provider.dart';
import '../../settings/data/record_lock_config.dart';
import '../data/local_record_repository.dart';

class DynamicRecordFormPage extends ConsumerStatefulWidget {
  const DynamicRecordFormPage({super.key, this.recordId});

  final String? recordId;

  @override
  ConsumerState<DynamicRecordFormPage> createState() =>
      _DynamicRecordFormPageState();
}

class _DynamicRecordFormPageState extends ConsumerState<DynamicRecordFormPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isSaving = false;
  bool _isLoadingLocations = false;
  String? _message;

  DateTime _recordDate = DateTime.now();

  List<FormFieldConfig> _fieldConfigs = [];
  List<FarmOperator> _operators = [];
  List<Crop> _crops = [];
  List<FarmTask> _tasks = [];
  List<LocationEntry> _locationsForCrop = [];
  List<FarmRecordLocation> _editingRecordLocations = [];

  FarmRecord? _editingRecord;
  RecordLockConfig? _lockConfig;

  String? _selectedOperatorId;
  String? _selectedCropId;
  String? _selectedTaskId;
  String? _selectedLot;
  String? _selectedNetwork;

  final Set<String> _selectedLocationIds = {};
  final Map<String, TextEditingController> _controllers = {};

  bool get _isEditing => widget.recordId != null;

  bool get _hasCropField {
    return _fieldConfigs.any((field) => field.fieldKey == 'cropId');
  }

  List<LocationEntry> get _selectedLocations {
    return _locationsForCrop
        .where((location) => _selectedLocationIds.contains(location.id))
        .toList();
  }

  double get _totalHa {
    var total = 0.0;

    for (final location in _selectedLocations) {
      total += location.ha;
    }

    return total;
  }

  double? get _calculatedRatio {
    final realWage = _readDouble('realWage');

    if (realWage == null || _totalHa <= 0) {
      return null;
    }

    return realWage / _totalHa;
  }

  String? get _suggestedDiningRoom {
    final suggestions = _selectedLocations
        .map((location) => location.suggestedDiningRoom)
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList();

    if (suggestions.isEmpty) {
      return null;
    }

    return suggestions.join(' / ');
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadForm);
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> _loadForm() async {
    final session = ref.read(sessionProvider);
    final activeDepartment = session.activeDepartment;

    if (activeDepartment == null) {
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
      final lockRepository = ref.read(recordLockRepositoryProvider);

      await repository.ensureDemoFormConfig();

      final fields = await repository.getFieldsForDepartment(
        activeDepartment.id,
      );
      final operators = await repository.getOperatorsForDepartment(
        activeDepartment.id,
      );
      final crops = await repository.getCrops();
      final tasks = await repository.getTasksForDepartment(activeDepartment.id);
      final lockConfig = await lockRepository.getConfig(activeDepartment.id);

      FarmRecord? record;
      List<FarmRecordLocation> recordLocations = [];
      List<LocationEntry> locationsForCrop = [];

      if (_isEditing) {
        record = await repository.getRecordById(widget.recordId!);

        if (record == null) {
          throw Exception('El registro no existe.');
        }

        if (record.departmentId != activeDepartment.id) {
          throw Exception('El registro no pertenece al departamento activo.');
        }

        if (!session.isAdmin && record.createdByUserId != session.userId) {
          throw Exception('No puede editar registros de otro usuario.');
        }

        recordLocations = await repository.getRecordLocations(record.id);

        if (record.cropId != null) {
          locationsForCrop = await repository.getLocationsForCrop(
            record.cropId!,
          );
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _fieldConfigs = fields;
        _operators = operators;
        _crops = crops;
        _tasks = tasks;
        _lockConfig = lockConfig;
        _editingRecord = record;
        _editingRecordLocations = recordLocations;
        _locationsForCrop = locationsForCrop;
      });

      _createControllers();
      _fillEditingValuesIfNeeded();
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

  void _createControllers() {
    for (final field in _fieldConfigs) {
      if (!_controllers.containsKey(field.fieldKey)) {
        _controllers[field.fieldKey] = TextEditingController();
      }
    }
  }

  void _fillEditingValuesIfNeeded() {
    final record = _editingRecord;

    if (record == null) {
      return;
    }

    _recordDate = record.recordDate;
    _selectedOperatorId = record.operatorId;
    _selectedCropId = record.cropId;
    _selectedTaskId = record.taskId;
    _selectedLot = record.lot;
    _selectedNetwork = record.network;

    _selectedLocationIds
      ..clear()
      ..addAll(_editingRecordLocations.map((item) => item.locationId));

    _controllers['taskDetail']?.text = record.taskDetail ?? '';
    _controllers['scheduledWage']?.text =
        record.scheduledWage?.toString() ?? '';
    _controllers['realWage']?.text = record.realWage?.toString() ?? '';
    _controllers['diningRoom']?.text = record.diningRoom ?? '';
    _controllers['observation']?.text = record.observation ?? '';

    final extraJson = record.extraFieldsJson;

    if (extraJson != null && extraJson.trim().isNotEmpty) {
      final decoded = jsonDecode(extraJson);

      if (decoded is Map<String, dynamic>) {
        for (final entry in decoded.entries) {
          _controllers[entry.key]?.text = entry.value?.toString() ?? '';
        }
      }
    }
  }

  Future<void> _loadLocationsForCrop(String cropId) async {
    setState(() {
      _isLoadingLocations = true;
    });

    try {
      final repository = ref.read(localRecordRepositoryProvider);
      final locations = await repository.getLocationsForCrop(cropId);

      if (!mounted) {
        return;
      }

      setState(() {
        _locationsForCrop = locations;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocations = false;
        });
      }
    }
  }

  Future<void> _pickDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _recordDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      _recordDate = selectedDate;
    });
  }

  Future<void> _save() async {
    final session = ref.read(sessionProvider);
    final activeDepartment = session.activeDepartment;

    if (activeDepartment == null ||
        session.userId == null ||
        session.userCode == null) {
      _showMessage('No hay sesión activa válida.');
      return;
    }

    final lockRepository = ref.read(recordLockRepositoryProvider);
    final latestLockConfig = await lockRepository.getConfig(
      activeDepartment.id,
    );

    final lockMessage = lockRepository.validateCanSave(
      config: latestLockConfig,
      isAdmin: session.isAdmin,
      now: DateTime.now(),
    );

    setState(() {
      _lockConfig = latestLockConfig;
    });

    if (lockMessage != null) {
      _showMessage(lockMessage);
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    if (_hasCropField) {
      if (_selectedCropId == null) {
        _showMessage('Seleccione cultivo.');
        return;
      }

      if (_selectedLot == null) {
        _showMessage('Seleccione lote.');
        return;
      }

      if (_selectedNetwork == null) {
        _showMessage('Seleccione red.');
        return;
      }

      if (_selectedLocationIds.isEmpty) {
        _showMessage('Seleccione uno o más sectores.');
        return;
      }
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(localRecordRepositoryProvider);

      final selectedOperator = _findById<FarmOperator>(
        _operators,
        _selectedOperatorId,
        (item) {
          return item.id;
        },
      );

      final selectedCrop = _findById<Crop>(_crops, _selectedCropId, (item) {
        return item.id;
      });

      final selectedTask = _findById<FarmTask>(_tasks, _selectedTaskId, (item) {
        return item.id;
      });

      final extraFields = <String, dynamic>{};

      for (final field in _fieldConfigs) {
        if (_isBaseField(field.fieldKey)) {
          continue;
        }

        final value = _controllers[field.fieldKey]?.text.trim();

        if (value != null && value.isNotEmpty) {
          extraFields[field.fieldKey] = field.fieldType == 'number'
              ? double.tryParse(value.replaceAll(',', '.')) ?? value
              : value;
        }
      }

      final data = RecordFormSaveData(
        recordDate: _recordDate,
        weekNumber: _calculateIsoWeekNumber(_recordDate),
        departmentId: activeDepartment.id,
        createdByUserId: session.userId!,
        userCode: session.userCode!,
        operatorId: _selectedOperatorId,
        operatorNameSnapshot: selectedOperator?.fullName,
        cropId: _selectedCropId,
        cropNameSnapshot: selectedCrop?.name,
        taskId: _selectedTaskId,
        taskNameSnapshot: selectedTask?.name,
        taskDetail: _readText('taskDetail'),
        lot: _selectedLot,
        network: _selectedNetwork,
        scheduledWage: _readDouble('scheduledWage'),
        realWage: _readDouble('realWage'),
        ha: _totalHa,
        ratio: _calculatedRatio,
        diningRoom: _readText('diningRoom'),
        observation: _readText('observation'),
        extraFields: extraFields,
        selectedLocations: _selectedLocations,
      );

      if (_isEditing) {
        await repository.updateRecord(
          recordId: widget.recordId!,
          data: data,
          currentUserId: session.userId!,
          isAdmin: session.isAdmin,
        );
      } else {
        await repository.createRecord(data);
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Registro actualizado.' : 'Registro creado.',
          ),
        ),
      );

      context.go('/records');
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String? _currentBlockMessage(AppSession session) {
    final config = _lockConfig;

    if (config == null) {
      return null;
    }

    final repository = ref.read(recordLockRepositoryProvider);

    return repository.validateCanSave(
      config: config,
      isAdmin: session.isAdmin,
      now: DateTime.now(),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  T? _findById<T>(List<T> items, String? id, String Function(T item) getId) {
    if (id == null) {
      return null;
    }

    for (final item in items) {
      if (getId(item) == id) {
        return item;
      }
    }

    return null;
  }

  String? _readText(String key) {
    final value = _controllers[key]?.text.trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }

  double? _readDouble(String key) {
    final value = _controllers[key]?.text.trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return double.tryParse(value.replaceAll(',', '.'));
  }

  bool _isBaseField(String key) {
    return {
      'recordDate',
      'operatorId',
      'cropId',
      'taskId',
      'taskDetail',
      'scheduledWage',
      'realWage',
      'diningRoom',
      'observation',
    }.contains(key);
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final activeDepartmentName = session.activeDepartment?.name ?? '-';
    final blockMessage = _currentBlockMessage(session);
    final isBlocked = blockMessage != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar registro' : 'Nuevo registro'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _message != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_message!),
              ),
            )
          : _fieldConfigs.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No hay configuración de formulario para este departamento.',
                ),
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Departamento: $activeDepartmentName\n'
                        'Semana automática: ${_calculateIsoWeekNumber(_recordDate)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (isBlocked) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          blockMessage,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onErrorContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ..._fieldConfigs.map(_buildField),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _isSaving || isBlocked ? null : _save,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      _isEditing ? 'Actualizar registro' : 'Guardar registro',
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildField(FormFieldConfig field) {
    switch (field.fieldKey) {
      case 'recordDate':
        return _buildDateField(field);

      case 'operatorId':
        return _buildOperatorField(field);

      case 'cropId':
        return Column(
          children: [_buildCropField(field), _buildLocationSection()],
        );

      case 'taskId':
        return _buildTaskField(field);

      case 'scheduledWage':
      case 'realWage':
        return _buildTextField(
          field,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
          ],
          onChanged: (_) {
            setState(() {});
          },
        );

      case 'observation':
        return _buildTextField(field, maxLines: 3);

      default:
        if (field.fieldType == 'number') {
          return _buildTextField(
            field,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
            ],
            onChanged: (_) {
              setState(() {});
            },
          );
        }

        if (field.fieldType == 'multiline') {
          return _buildTextField(field, maxLines: 3);
        }

        return _buildTextField(field);
    }
  }

  Widget _buildDateField(FormFieldConfig field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: _pickDate,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: '${field.label}${field.isRequired ? ' *' : ''}',
            prefixIcon: const Icon(Icons.calendar_today),
          ),
          child: Text(
            '${_formatDate(_recordDate)} | Semana ${_calculateIsoWeekNumber(_recordDate)}',
          ),
        ),
      ),
    );
  }

  Widget _buildOperatorField(FormFieldConfig field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedOperatorId,
        decoration: InputDecoration(
          labelText: '${field.label}${field.isRequired ? ' *' : ''}',
          prefixIcon: const Icon(Icons.person_outline),
        ),
        items: _operators
            .map(
              (operator) => DropdownMenuItem(
                value: operator.id,
                child: Text('${operator.code} - ${operator.fullName}'),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedOperatorId = value;
          });
        },
        validator: (value) {
          if (field.isRequired && value == null) {
            return 'Seleccione ${field.label}.';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildCropField(FormFieldConfig field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedCropId,
        decoration: InputDecoration(
          labelText: '${field.label}${field.isRequired ? ' *' : ''}',
          prefixIcon: const Icon(Icons.grass_outlined),
        ),
        items: _crops
            .map(
              (crop) =>
                  DropdownMenuItem(value: crop.id, child: Text(crop.name)),
            )
            .toList(),
        onChanged: (value) async {
          setState(() {
            _selectedCropId = value;
            _selectedLot = null;
            _selectedNetwork = null;
            _selectedLocationIds.clear();
            _locationsForCrop = [];
          });

          if (value != null) {
            await _loadLocationsForCrop(value);
          }
        },
        validator: (value) {
          if (field.isRequired && value == null) {
            return 'Seleccione ${field.label}.';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildLocationSection() {
    if (_selectedCropId == null) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Seleccione un cultivo para cargar lotes, redes y sectores.',
            ),
          ),
        ),
      );
    }

    if (_isLoadingLocations) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_locationsForCrop.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No hay ubicaciones configuradas para este cultivo.'),
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildLotField(),
        _buildNetworkField(),
        _buildSectorsField(),
        _buildHaRatioSummary(),
      ],
    );
  }

  Widget _buildLotField() {
    final lots = _locationsForCrop.map((item) => item.lot).toSet().toList()
      ..sort();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedLot,
        decoration: const InputDecoration(
          labelText: 'Lote *',
          prefixIcon: Icon(Icons.map_outlined),
        ),
        items: lots
            .map((lot) => DropdownMenuItem(value: lot, child: Text(lot)))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedLot = value;
            _selectedNetwork = null;
            _selectedLocationIds.clear();
          });
        },
      ),
    );
  }

  Widget _buildNetworkField() {
    final networks =
        _locationsForCrop
            .where((item) => item.lot == _selectedLot)
            .map((item) => item.network)
            .toSet()
            .toList()
          ..sort();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedNetwork,
        decoration: const InputDecoration(
          labelText: 'Red *',
          prefixIcon: Icon(Icons.hub_outlined),
        ),
        items: networks
            .map(
              (network) =>
                  DropdownMenuItem(value: network, child: Text(network)),
            )
            .toList(),
        onChanged: _selectedLot == null
            ? null
            : (value) {
                setState(() {
                  _selectedNetwork = value;
                  _selectedLocationIds.clear();
                });
              },
      ),
    );
  }

  Widget _buildSectorsField() {
    final sectors =
        _locationsForCrop
            .where(
              (item) =>
                  item.lot == _selectedLot && item.network == _selectedNetwork,
            )
            .toList()
          ..sort((a, b) => a.sector.compareTo(b.sector));

    if (_selectedLot == null || _selectedNetwork == null) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Seleccione lote y red para ver sectores.'),
          ),
        ),
      );
    }

    if (sectors.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No hay sectores para la combinación seleccionada.'),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Column(
          children: [
            const ListTile(
              title: Text('Sectores *'),
              subtitle: Text('Puede seleccionar uno o varios sectores.'),
            ),
            const Divider(height: 1),
            ...sectors.map(
              (location) => CheckboxListTile(
                value: _selectedLocationIds.contains(location.id),
                title: Text(location.sector),
                subtitle: Text(
                  'Ha: ${location.ha.toStringAsFixed(2)}'
                  '${location.suggestedDiningRoom == null ? '' : ' | Comedor sugerido: ${location.suggestedDiningRoom}'}',
                ),
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      _selectedLocationIds.add(location.id);
                    } else {
                      _selectedLocationIds.remove(location.id);
                    }

                    _applySuggestedDiningRoomIfEmpty();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHaRatioSummary() {
    final ratio = _calculatedRatio;
    final suggestedDiningRoom = _suggestedDiningRoom;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ha total: ${_totalHa.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                ratio == null
                    ? 'Ratio: ingrese Jornal real y seleccione sectores.'
                    : 'Ratio: ${ratio.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 8),
              Text(
                suggestedDiningRoom == null
                    ? 'Comedor sugerido: -'
                    : 'Comedor sugerido: $suggestedDiningRoom',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _applySuggestedDiningRoomIfEmpty() {
    final suggestion = _suggestedDiningRoom;
    final controller = _controllers['diningRoom'];

    if (suggestion == null || controller == null) {
      return;
    }

    if (controller.text.trim().isEmpty) {
      controller.text = suggestion;
    }
  }

  Widget _buildTaskField(FormFieldConfig field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedTaskId,
        decoration: InputDecoration(
          labelText: '${field.label}${field.isRequired ? ' *' : ''}',
          prefixIcon: const Icon(Icons.work_outline),
        ),
        items: _tasks
            .map(
              (task) =>
                  DropdownMenuItem(value: task.id, child: Text(task.name)),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedTaskId = value;

            final selectedTask = _findById<FarmTask>(
              _tasks,
              value,
              (item) => item.id,
            );
            final detail = selectedTask?.defaultDetail;

            if (detail != null && detail.isNotEmpty) {
              _controllers['taskDetail']?.text = detail;
            }
          });
        },
        validator: (value) {
          if (field.isRequired && value == null) {
            return 'Seleccione ${field.label}.';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildTextField(
    FormFieldConfig field, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    final controller = _controllers[field.fieldKey] ?? TextEditingController();

    _controllers[field.fieldKey] = controller;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: '${field.label}${field.isRequired ? ' *' : ''}',
        ),
        validator: (value) {
          if (field.isRequired && (value == null || value.trim().isEmpty)) {
            return 'Ingrese ${field.label}.';
          }

          return null;
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  int _calculateIsoWeekNumber(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final thursday = normalizedDate.add(
      Duration(days: 4 - normalizedDate.weekday),
    );

    final firstThursdayBase = DateTime(thursday.year, 1, 4);
    final firstThursday = firstThursdayBase.add(
      Duration(days: 4 - firstThursdayBase.weekday),
    );

    return 1 + thursday.difference(firstThursday).inDays ~/ 7;
  }
}
