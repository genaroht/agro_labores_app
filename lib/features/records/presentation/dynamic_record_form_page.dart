import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/local/app_database.dart';
import '../../../shared/providers/session_provider.dart';
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
  String? _message;

  DateTime _recordDate = DateTime.now();

  List<FormFieldConfig> _fieldConfigs = [];
  List<FarmOperator> _operators = [];
  List<Crop> _crops = [];
  List<FarmTask> _tasks = [];

  FarmRecord? _editingRecord;

  String? _selectedOperatorId;
  String? _selectedCropId;
  String? _selectedTaskId;

  final Map<String, TextEditingController> _controllers = {};

  bool get _isEditing => widget.recordId != null;

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

      await repository.ensureDemoFormConfig();

      final fields = await repository.getFieldsForDepartment(
        activeDepartment.id,
      );
      final operators = await repository.getOperatorsForDepartment(
        activeDepartment.id,
      );
      final crops = await repository.getCrops();
      final tasks = await repository.getTasksForDepartment(activeDepartment.id);

      FarmRecord? record;

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
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _fieldConfigs = fields;
        _operators = operators;
        _crops = crops;
        _tasks = tasks;
        _editingRecord = record;
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay sesión activa válida.')),
      );
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(localRecordRepositoryProvider);

      final selectedOperator = _operators
          .where((item) => item.id == _selectedOperatorId)
          .firstOrNull;
      final selectedCrop = _crops
          .where((item) => item.id == _selectedCropId)
          .firstOrNull;
      final selectedTask = _tasks
          .where((item) => item.id == _selectedTaskId)
          .firstOrNull;

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
        scheduledWage: _readDouble('scheduledWage'),
        realWage: _readDouble('realWage'),
        diningRoom: _readText('diningRoom'),
        observation: _readText('observation'),
        extraFields: extraFields,
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
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
                  const SizedBox(height: 16),
                  ..._fieldConfigs.map(_buildField),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _isSaving ? null : _save,
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
        return _buildCropField(field);

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
        onChanged: (value) {
          setState(() {
            _selectedCropId = value;
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

            final selectedTask = _tasks
                .where((task) => task.id == value)
                .firstOrNull;
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
