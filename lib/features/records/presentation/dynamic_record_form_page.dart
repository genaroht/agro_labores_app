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
  final _scheduledWageController = TextEditingController();
  final _realWageController = TextEditingController();
  final _observationController = TextEditingController();

  bool _isLoading = false;
  bool _isSaving = false;
  bool _isLoadingLocations = false;
  bool _isLoadingDiningRooms = false;
  String? _message;

  DateTime _recordDate = DateTime.now().add(const Duration(days: 1));

  List<Department> _departments = [];
  List<Crop> _crops = [];
  List<FarmOperator> _leaderOperators = [];
  List<FarmTask> _tasks = [];
  List<LocationEntry> _locationsForCrop = [];
  List<DiningRoom> _diningRooms = [];
  List<FarmRecordLocation> _editingRecordLocations = [];

  FarmRecord? _editingRecord;
  Department? _selectedDepartment;
  RecordLockConfig? _lockConfig;

  String? _selectedDepartmentId;
  String? _selectedLeaderOperatorId;
  String? _selectedTaskId;
  String? _selectedCropId;
  String? _selectedLot;
  String? _selectedNetwork;
  String? _selectedDiningRoomId;

  final Set<String> _selectedLocationIds = {};

  bool get _isEditing => widget.recordId != null;

  bool get _isSupervisorRealWageMode {
    final session = ref.read(sessionProvider);
    return _isEditing && !session.isAdmin;
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
    final scheduledWage = _readDouble(_scheduledWageController);

    if (scheduledWage == null || _totalHa <= 0) {
      return null;
    }

    return scheduledWage / _totalHa;
  }

  FarmOperator? get _selectedLeader {
    return _findById<FarmOperator>(
      _leaderOperators,
      _selectedLeaderOperatorId,
      (item) => item.id,
    );
  }

  FarmTask? get _selectedTask {
    return _findById<FarmTask>(_tasks, _selectedTaskId, (item) => item.id);
  }

  Crop? get _selectedCrop {
    return _findById<Crop>(_crops, _selectedCropId, (item) => item.id);
  }

  DiningRoom? get _selectedDiningRoom {
    return _findById<DiningRoom>(
      _diningRooms,
      _selectedDiningRoomId,
      (item) => item.id,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadForm);
  }

  @override
  void dispose() {
    _scheduledWageController.dispose();
    _realWageController.dispose();
    _observationController.dispose();
    super.dispose();
  }

  Future<void> _loadForm() async {
    final session = ref.read(sessionProvider);

    if (session.userId == null || session.userCode == null) {
      setState(() {
        _message = 'No hay sesión activa válida.';
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
      final crops = await repository.getCrops();
      FarmRecord? record;

      if (_isEditing) {
        record = await repository.getRecordById(widget.recordId!);

        if (record == null) {
          throw Exception('El registro no existe.');
        }

        if (!session.isAdmin && record.createdByUserId != session.userId) {
          throw Exception('No puede editar registros de otro usuario.');
        }

        if (!session.isAdmin &&
            record.departmentId != session.activeDepartment?.id) {
          throw Exception('Este registro no pertenece al departamento activo.');
        }
      }

      String? departmentId;

      if (record != null) {
        departmentId = record.departmentId;
      } else if (session.isAdmin) {
        departmentId = _selectedDepartmentId;

        if (departmentId == null && departments.isNotEmpty) {
          departmentId = departments.first.id;
        }
      } else {
        departmentId = session.activeDepartment?.id;
      }

      if (departmentId == null) {
        throw Exception(
          session.isAdmin
              ? 'Cree al menos un departamento antes de registrar.'
              : 'No hay departamento activo.',
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _departments = departments;
        _crops = crops;
        _editingRecord = record;
      });

      await _loadDepartmentFormData(departmentId: departmentId, record: record);
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

  Future<void> _loadDepartmentFormData({
    required String departmentId,
    FarmRecord? record,
  }) async {
    final repository = ref.read(localRecordRepositoryProvider);
    final lockRepository = ref.read(recordLockRepositoryProvider);

    final department = await repository.getDepartmentById(departmentId);

    if (department == null) {
      throw Exception(
        'El departamento seleccionado no existe o está inactivo.',
      );
    }

    final leaders = await repository.getLeaderOperatorsForDepartment(
      departmentId,
    );
    final tasks = await repository.getTasksForDepartment(departmentId);
    final lockConfig = await lockRepository.getConfig(departmentId);

    var selectedLeaderId = record?.leaderOperatorId ?? record?.operatorId;
    var selectedTaskId = record?.taskId;
    var selectedTask = _findById<FarmTask>(tasks, selectedTaskId, (item) {
      return item.id;
    });
    var selectedCropId =
        record?.cropId ?? selectedTask?.cropId ?? department.cropId;
    var selectedLot = record != null && record.lot != null
        ? AgroLocalValueFormatters.compactLot(record.lot!)
        : null;
    var selectedNetwork = record != null && record.network != null
        ? AgroLocalValueFormatters.compactNetwork(record.network!)
        : null;
    var selectedDiningRoomId = record?.diningRoomId;

    List<FarmRecordLocation> recordLocations = [];
    List<LocationEntry> locationsForCrop = [];
    List<DiningRoom> diningRooms = [];

    if (record != null) {
      recordLocations = await repository.getRecordLocations(record.id);

      if (selectedLot == null && recordLocations.isNotEmpty) {
        selectedLot = AgroLocalValueFormatters.compactLot(
          recordLocations.first.lotSnapshot,
        );
      }

      if (selectedNetwork == null && recordLocations.isNotEmpty) {
        selectedNetwork = AgroLocalValueFormatters.compactNetwork(
          recordLocations.first.networkSnapshot,
        );
      }
    }

    if (selectedCropId != null) {
      locationsForCrop = await repository.getLocationsForCrop(selectedCropId);

      if (selectedLot != null && selectedNetwork != null) {
        diningRooms = await repository.getDiningRoomsForCropLotNetwork(
          cropId: selectedCropId,
          lot: selectedLot,
          network: selectedNetwork,
        );

        if (selectedDiningRoomId == null &&
            record != null &&
            record.diningRoom != null) {
          final recordDiningRoomName = record.diningRoom!.trim().toLowerCase();

          for (final diningRoom in diningRooms) {
            if (diningRoom.name.trim().toLowerCase() == recordDiningRoomName) {
              selectedDiningRoomId = diningRoom.id;
              break;
            }
          }
        }
      }
    }

    if (record == null && diningRooms.length == 1) {
      selectedDiningRoomId = diningRooms.first.id;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedDepartment = department;
      _selectedDepartmentId = department.id;
      _leaderOperators = leaders;
      _tasks = tasks;
      _selectedLeaderOperatorId = selectedLeaderId;
      _selectedTaskId = selectedTaskId;
      _selectedCropId = selectedCropId;
      _selectedLot = selectedLot;
      _selectedNetwork = selectedNetwork;
      _selectedDiningRoomId = selectedDiningRoomId;
      _locationsForCrop = locationsForCrop;
      _diningRooms = diningRooms;
      _editingRecordLocations = recordLocations;
      _lockConfig = lockConfig;
      if (record != null) {
        _recordDate = record.recordDate;
        _selectedLocationIds
          ..clear()
          ..addAll(recordLocations.map((item) => item.locationId));
      } else {
        _selectedLocationIds.clear();
      }
    });

    _fillEditingValuesIfNeeded();
  }

  void _fillEditingValuesIfNeeded() {
    final record = _editingRecord;

    if (record == null) {
      _scheduledWageController.clear();
      _realWageController.clear();
      _observationController.clear();
      return;
    }

    _scheduledWageController.text = _formatControllerNumber(
      record.scheduledWage,
    );
    _realWageController.text = _formatControllerNumber(record.realWage);
    _observationController.text = record.observation ?? '';
  }

  Future<void> _loadLocationsForSelectedCrop({
    bool clearSelection = true,
  }) async {
    final cropId = _selectedCropId;

    if (cropId == null) {
      setState(() {
        _locationsForCrop = [];
        if (clearSelection) {
          _selectedLot = null;
          _selectedNetwork = null;
          _selectedLocationIds.clear();
        }
      });
      return;
    }

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
        if (clearSelection) {
          _selectedLot = null;
          _selectedNetwork = null;
          _selectedLocationIds.clear();
          _selectedDiningRoomId = null;
          _diningRooms = [];
        }
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocations = false;
        });
      }
    }
  }

  Future<void> _loadDiningRoomsForCurrentSelection() async {
    final cropId = _selectedCropId;
    final lot = _selectedLot;
    final network = _selectedNetwork;

    if (cropId == null || lot == null || network == null) {
      setState(() {
        _diningRooms = [];
        _selectedDiningRoomId = null;
      });
      return;
    }

    setState(() {
      _isLoadingDiningRooms = true;
    });

    try {
      final repository = ref.read(localRecordRepositoryProvider);
      final diningRooms = await repository.getDiningRoomsForCropLotNetwork(
        cropId: cropId,
        lot: lot,
        network: network,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _diningRooms = diningRooms;
        if (diningRooms.length == 1) {
          _selectedDiningRoomId = diningRooms.first.id;
        } else if (!diningRooms.any(
          (item) => item.id == _selectedDiningRoomId,
        )) {
          _selectedDiningRoomId = null;
        }
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDiningRooms = false;
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
    final departmentId = session.isAdmin
        ? _selectedDepartmentId
        : session.activeDepartment?.id;

    if (departmentId == null ||
        session.userId == null ||
        session.userCode == null) {
      _showMessage('No hay sesión activa válida.');
      return;
    }

    final lockRepository = ref.read(recordLockRepositoryProvider);
    final latestLockConfig = await lockRepository.getConfig(departmentId);

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

    if (!_isEditing || session.isAdmin) {
      final validationMessage = _validateProgrammingFields();

      if (validationMessage != null) {
        _showMessage(validationMessage);
        return;
      }
    }

    if ((!_isEditing || session.isAdmin) &&
        _diningRooms.length > 1 &&
        _selectedDiningRoomId == null) {
      _showMessage('Seleccione comedor.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(localRecordRepositoryProvider);
      final data = _buildSaveData(session: session, departmentId: departmentId);

      if (_isEditing) {
        await repository.updateRecord(
          recordId: widget.recordId!,
          data: data,
          currentUserId: session.userId!,
          isAdmin: session.isAdmin,
          currentDepartmentId: session.activeDepartment?.id,
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
            _isSupervisorRealWageMode
                ? 'Jornal real guardado pendiente de sincronización.'
                : _isEditing
                ? 'Registro actualizado pendiente de sincronización.'
                : 'Registro creado pendiente de sincronización.',
          ),
        ),
      );

      _returnAfterSave(session);
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

  void _returnAfterSave(AppSession session) {
    if (context.canPop()) {
      context.pop(true);
      return;
    }

    context.go(session.isAdmin ? '/admin/records' : '/home');
  }

  RecordFormSaveData _buildSaveData({
    required AppSession session,
    required String departmentId,
  }) {
    final leader = _selectedLeader;
    final task = _selectedTask;
    final crop = _selectedCrop;
    final diningRoom = _selectedDiningRoom;

    return RecordFormSaveData(
      recordDate: _recordDate,
      weekNumber: _calculateIsoWeekNumber(_recordDate),
      departmentId: departmentId,
      createdByUserId: _editingRecord?.createdByUserId ?? session.userId!,
      userCode: _editingRecord?.userCode ?? session.userCode!,
      operatorId: _selectedLeaderOperatorId,
      operatorNameSnapshot:
          leader?.fullName ?? _editingRecord?.leaderNameSnapshot,
      cropId: _selectedCropId,
      cropNameSnapshot: crop?.name ?? _editingRecord?.cropNameSnapshot,
      taskId: _selectedTaskId,
      taskNameSnapshot: task?.name ?? _editingRecord?.taskNameSnapshot,
      taskDetail: task?.defaultDetail ?? _editingRecord?.taskDetail,
      lot: _selectedLot,
      network: _selectedNetwork,
      scheduledWage: _readDouble(_scheduledWageController),
      realWage: _readDouble(_realWageController),
      ha: _totalHa,
      ratio: _calculatedRatio,
      diningRoomId: diningRoom?.id,
      diningRoom: diningRoom?.name ?? _editingRecord?.diningRoom,
      observation: _readOptionalText(_observationController),
      extraFields: const {},
      selectedLocations: _selectedLocations,
    );
  }

  String? _validateProgrammingFields() {
    if (_selectedDepartmentId == null) {
      return 'Seleccione departamento.';
    }

    if (_selectedLeaderOperatorId == null) {
      return 'Seleccione líder.';
    }

    if (_selectedTaskId == null) {
      return 'Seleccione labor.';
    }

    if (_selectedCropId == null) {
      return 'El departamento o la labor no tiene cultivo asociado.';
    }

    if (_selectedLot == null) {
      return 'Seleccione lote.';
    }

    if (_selectedNetwork == null) {
      return 'Seleccione red.';
    }

    if (_selectedLocationIds.isEmpty) {
      return 'Seleccione uno o más sectores.';
    }

    final scheduledWage = _readDouble(_scheduledWageController);

    if (scheduledWage == null || scheduledWage <= 0) {
      return 'Ingrese Jornal programado mayor a 0.';
    }

    return null;
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

  String? _readOptionalText(TextEditingController controller) {
    final value = controller.text.trim();

    if (value.isEmpty) {
      return null;
    }

    return value;
  }

  double? _readDouble(TextEditingController controller) {
    final value = controller.text.trim();

    if (value.isEmpty) {
      return null;
    }

    return double.tryParse(value.replaceAll(',', '.'));
  }

  bool _isFieldLockedForNormalEditing(String key) {
    final session = ref.read(sessionProvider);

    if (!_isEditing || session.isAdmin) {
      return false;
    }

    return key != 'realWage' && key != 'observation';
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final blockMessage = _currentBlockMessage(session);
    final isBlocked = blockMessage != null;
    final supervisorRealWageMode = _isEditing && !session.isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Editar registro' : 'Nuevo registro programado',
        ),
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
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildHeaderCard(session),
                  if (session.isAdmin) ...[
                    const SizedBox(height: 16),
                    _buildAdminDepartmentField(),
                  ],
                  if (isBlocked) ...[
                    const SizedBox(height: 16),
                    _buildBlockMessageCard(blockMessage),
                  ],
                  const SizedBox(height: 16),
                  if (supervisorRealWageMode) ...[
                    _buildLockedProgrammingSummary(),
                    _buildRealWageField(),
                  ] else ...[
                    _buildDateField(),
                    _buildLeaderField(),
                    _buildTaskField(),
                    _buildLocationSection(),
                    _buildDiningRoomField(),
                    _buildScheduledWageField(),
                    if (_isEditing) _buildRealWageField(),
                  ],
                  _buildObservationField(),
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
                      supervisorRealWageMode
                          ? 'Guardar jornal real'
                          : _isEditing
                          ? 'Actualizar registro'
                          : 'Guardar programación',
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderCard(AppSession session) {
    final departmentName = session.isAdmin
        ? _selectedDepartment?.name ?? '-'
        : session.activeDepartment?.name ?? '-';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing
                  ? 'Edición de registro'
                  : 'Programación para el día siguiente',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Departamento: $departmentName'),
            Text(
              'Usuario registrador: ${session.userName ?? '-'} (${session.userCode ?? '-'})',
            ),
            Text('Semana automática: ${_calculateIsoWeekNumber(_recordDate)}'),
            Text('Estado local al guardar: ${SyncStatuses.pending}'),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockMessageCard(String blockMessage) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          blockMessage,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onErrorContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLockedProgrammingSummary() {
    final record = _editingRecord;
    final leaderName =
        record?.leaderNameSnapshot ??
        record?.operatorNameSnapshot ??
        _selectedLeader?.fullName ??
        '-';
    final leaderCode =
        record?.leaderCodeSnapshot ?? _selectedLeader?.code ?? '-';
    final taskCode = record?.taskCodeSnapshot ?? _selectedTask?.code ?? '-';
    final taskName = record?.taskNameSnapshot ?? _selectedTask?.name ?? '-';
    final sectors = _formatRecordSectors(_editingRecordLocations);
    final lotNetwork = _formatRecordLotNetwork(record, _editingRecordLocations);
    final diningRoom = record?.diningRoom ?? _selectedDiningRoom?.name ?? '-';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Programación bloqueada',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Como supervisor solo puede editar Jornal real y Observación.',
              ),
              const Divider(height: 24),
              _ReadOnlySummaryRow(
                label: 'Fecha',
                value: record == null ? '-' : _formatDate(record.recordDate),
              ),
              _ReadOnlySummaryRow(
                label: 'Semana',
                value:
                    '${record?.weekNumber ?? _calculateIsoWeekNumber(_recordDate)}',
              ),
              _ReadOnlySummaryRow(
                label: 'Departamento',
                value: _selectedDepartment?.name ?? '-',
              ),
              _ReadOnlySummaryRow(
                label: 'Líder',
                value: '$leaderName | Código: $leaderCode',
              ),
              _ReadOnlySummaryRow(
                label: 'Labor',
                value: '$taskCode | $taskName',
              ),
              _ReadOnlySummaryRow(label: 'Lote - Red', value: lotNetwork),
              _ReadOnlySummaryRow(label: 'Sectores', value: sectors),
              _ReadOnlySummaryRow(
                label: 'Jornal programado',
                value: _formatControllerNumber(record?.scheduledWage).isEmpty
                    ? '-'
                    : _formatControllerNumber(record?.scheduledWage),
              ),
              _ReadOnlySummaryRow(
                label: 'Ha',
                value: (record?.ha ?? _totalHa).toStringAsFixed(2),
              ),
              _ReadOnlySummaryRow(
                label: 'Ratio',
                value: record?.ratio == null
                    ? '-'
                    : record!.ratio!.toStringAsFixed(2),
              ),
              _ReadOnlySummaryRow(label: 'Comedor', value: diningRoom),
              _ReadOnlySummaryRow(
                label: 'Estado sync',
                value: record?.syncStatus ?? '-',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminDepartmentField() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedDepartmentId,
      decoration: const InputDecoration(
        labelText: 'Departamento *',
        prefixIcon: Icon(Icons.account_tree_outlined),
      ),
      items: _departments
          .map(
            (department) => DropdownMenuItem(
              value: department.id,
              child: Text(department.name),
            ),
          )
          .toList(),
      onChanged: (value) async {
        if (value == null) {
          return;
        }

        setState(() {
          _selectedDepartmentId = value;
          _selectedLeaderOperatorId = null;
          _selectedTaskId = null;
          _selectedCropId = null;
          _selectedLot = null;
          _selectedNetwork = null;
          _selectedDiningRoomId = null;
          _selectedLocationIds.clear();
          _locationsForCrop = [];
          _diningRooms = [];
        });

        await _loadDepartmentFormData(departmentId: value);
      },
      validator: (value) {
        if (value == null) {
          return 'Seleccione departamento.';
        }

        return null;
      },
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: _isFieldLockedForNormalEditing('recordDate') ? null : _pickDate,
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Fecha de programación *',
            prefixIcon: Icon(Icons.calendar_today),
          ),
          child: Text(
            '${_formatDate(_recordDate)} | Semana ${_calculateIsoWeekNumber(_recordDate)}',
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderField() {
    final selectedLeader = _selectedLeader;
    final locked = _isFieldLockedForNormalEditing('operatorId');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RawAutocomplete<FarmOperator>(
            key: ValueKey(
              'leader_${_selectedDepartmentId}_${selectedLeader?.id ?? 'none'}',
            ),
            displayStringForOption: (operator) =>
                '${operator.fullName} - ${operator.code}',
            initialValue: TextEditingValue(
              text: selectedLeader == null
                  ? ''
                  : '${selectedLeader.fullName} - ${selectedLeader.code}',
            ),
            optionsBuilder: (textEditingValue) {
              if (locked) {
                return const Iterable<FarmOperator>.empty();
              }

              final query = textEditingValue.text.trim().toLowerCase();

              if (query.isEmpty) {
                return _leaderOperators.take(20);
              }

              return _leaderOperators
                  .where((operator) {
                    return operator.fullName.toLowerCase().contains(query) ||
                        operator.code.toLowerCase().contains(query);
                  })
                  .take(20);
            },
            onSelected: (operator) {
              setState(() {
                _selectedLeaderOperatorId = operator.id;
              });
            },
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    enabled: !locked,
                    decoration: const InputDecoration(
                      labelText: 'Líder *',
                      hintText: 'Buscar por nombre o código',
                      prefixIcon: Icon(Icons.person_search_outlined),
                    ),
                    onChanged: (value) {
                      final typedValue = value.trim().toLowerCase();
                      final currentLeader = _selectedLeader;
                      final currentLabel = currentLeader == null
                          ? ''
                          : '${currentLeader.fullName} - ${currentLeader.code}'
                                .trim()
                                .toLowerCase();

                      if (typedValue.isEmpty || typedValue != currentLabel) {
                        setState(() {
                          _selectedLeaderOperatorId = null;
                        });
                      }
                    },
                  );
                },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 260,
                      maxWidth: 380,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final operator = options.elementAt(index);

                        return ListTile(
                          title: Text(operator.fullName),
                          subtitle: Text('Código: ${operator.code}'),
                          onTap: () => onSelected(operator),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            selectedLeader == null
                ? 'Código líder: -'
                : 'Código líder: ${selectedLeader.code}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (_leaderOperators.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'No hay personas con cargo líder para este departamento.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskField() {
    final selectedTask = _selectedTask;
    final locked = _isFieldLockedForNormalEditing('taskId');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _selectedTaskId,
            decoration: const InputDecoration(
              labelText: 'Labor *',
              prefixIcon: Icon(Icons.work_outline),
            ),
            items: _tasks
                .map(
                  (task) => DropdownMenuItem(
                    value: task.id,
                    child: Text('${task.code ?? '-'} | ${task.name}'),
                  ),
                )
                .toList(),
            onChanged: locked
                ? null
                : (value) async {
                    final task = _findById<FarmTask>(_tasks, value, (item) {
                      return item.id;
                    });

                    setState(() {
                      _selectedTaskId = value;
                      _selectedCropId =
                          task?.cropId ?? _selectedDepartment?.cropId;
                      _selectedLot = null;
                      _selectedNetwork = null;
                      _selectedDiningRoomId = null;
                      _selectedLocationIds.clear();
                      _diningRooms = [];
                    });

                    await _loadLocationsForSelectedCrop();
                  },
            validator: (value) {
              if (value == null) {
                return 'Seleccione labor.';
              }

              return null;
            },
          ),
          const SizedBox(height: 8),
          Text(
            selectedTask == null
                ? 'Código labor: -'
                : 'Código labor: ${selectedTask.code ?? '-'}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (_tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'No hay labores activas para este departamento.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
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
              'Seleccione una labor con configuración completa para cargar lotes, redes y sectores.',
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
    final lots =
        _locationsForCrop
            .map((item) => AgroLocalValueFormatters.compactLot(item.lot))
            .where((item) => item.isNotEmpty)
            .toSet()
            .toList()
          ..sort(_compareMixedNumbers);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: lots.contains(_selectedLot) ? _selectedLot : null,
        decoration: const InputDecoration(
          labelText: 'Lote *',
          prefixIcon: Icon(Icons.map_outlined),
        ),
        items: lots
            .map((lot) => DropdownMenuItem(value: lot, child: Text(lot)))
            .toList(),
        onChanged: _isFieldLockedForNormalEditing('locations')
            ? null
            : (value) async {
                setState(() {
                  _selectedLot = value;
                  _selectedNetwork = null;
                  _selectedDiningRoomId = null;
                  _selectedLocationIds.clear();
                  _diningRooms = [];
                });
              },
        validator: (value) {
          if (value == null) {
            return 'Seleccione lote.';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildNetworkField() {
    final networks =
        _locationsForCrop
            .where(
              (item) =>
                  AgroLocalValueFormatters.compactLot(item.lot) == _selectedLot,
            )
            .map(
              (item) => AgroLocalValueFormatters.compactNetwork(item.network),
            )
            .where((item) => item.isNotEmpty)
            .toSet()
            .toList()
          ..sort(_compareMixedNumbers);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: networks.contains(_selectedNetwork)
            ? _selectedNetwork
            : null,
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
        onChanged:
            _selectedLot == null || _isFieldLockedForNormalEditing('locations')
            ? null
            : (value) async {
                setState(() {
                  _selectedNetwork = value;
                  _selectedDiningRoomId = null;
                  _selectedLocationIds.clear();
                });

                await _loadDiningRoomsForCurrentSelection();
              },
        validator: (value) {
          if (value == null) {
            return 'Seleccione red.';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildSectorsField() {
    final sectors =
        _locationsForCrop
            .where(
              (item) =>
                  AgroLocalValueFormatters.compactLot(item.lot) ==
                      _selectedLot &&
                  AgroLocalValueFormatters.compactNetwork(item.network) ==
                      _selectedNetwork,
            )
            .toList()
          ..sort(
            (a, b) => _compareMixedNumbers(
              AgroLocalValueFormatters.compactSector(a.sector),
              AgroLocalValueFormatters.compactSector(b.sector),
            ),
          );

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
            ...sectors.map((location) {
              final sector = AgroLocalValueFormatters.compactSector(
                location.sector,
              );

              return CheckboxListTile(
                value: _selectedLocationIds.contains(location.id),
                title: Text(sector),
                subtitle: Text('Ha sector: ${location.ha.toStringAsFixed(2)}'),
                onChanged: _isFieldLockedForNormalEditing('locations')
                    ? null
                    : (checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedLocationIds.add(location.id);
                          } else {
                            _selectedLocationIds.remove(location.id);
                          }
                        });
                      },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDiningRoomField() {
    if (_selectedCropId == null ||
        _selectedLot == null ||
        _selectedNetwork == null) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Seleccione lote y red para filtrar comedores.'),
          ),
        ),
      );
    }

    if (_isLoadingDiningRooms) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_diningRooms.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'No hay comedor configurado para este cultivo/lote/red.',
            ),
          ),
        ),
      );
    }

    if (_diningRooms.length == 1) {
      final diningRoom = _diningRooms.first;

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Card(
          child: ListTile(
            leading: const Icon(Icons.restaurant_outlined),
            title: const Text('Comedor sugerido'),
            subtitle: Text(diningRoom.name),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedDiningRoomId,
        decoration: const InputDecoration(
          labelText: 'Comedor *',
          prefixIcon: Icon(Icons.restaurant_outlined),
        ),
        items: _diningRooms
            .map(
              (diningRoom) => DropdownMenuItem(
                value: diningRoom.id,
                child: Text(diningRoom.name),
              ),
            )
            .toList(),
        onChanged: _isFieldLockedForNormalEditing('diningRoom')
            ? null
            : (value) {
                setState(() {
                  _selectedDiningRoomId = value;
                });
              },
        validator: (value) {
          if (_diningRooms.length > 1 && value == null) {
            return 'Seleccione comedor.';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildHaRatioSummary() {
    final ratio = _calculatedRatio;

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
                    ? 'Ratio: ingrese Jornal programado y seleccione sectores.'
                    : 'Ratio: ${ratio.toStringAsFixed(2)}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduledWageField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _scheduledWageController,
        enabled: !_isFieldLockedForNormalEditing('scheduledWage'),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
        ],
        decoration: const InputDecoration(
          labelText: 'Jornal programado *',
          prefixIcon: Icon(Icons.groups_outlined),
        ),
        onChanged: (_) {
          setState(() {});
        },
        validator: (value) {
          if (_isEditing && !ref.read(sessionProvider).isAdmin) {
            return null;
          }

          final number = double.tryParse((value ?? '').replaceAll(',', '.'));

          if (number == null || number <= 0) {
            return 'Ingrese Jornal programado mayor a 0.';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildRealWageField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _realWageController,
        enabled: !_isFieldLockedForNormalEditing('realWage'),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
        ],
        decoration: const InputDecoration(
          labelText: 'Jornal real',
          prefixIcon: Icon(Icons.fact_check_outlined),
        ),
        validator: (value) {
          final cleanValue = (value ?? '').trim();

          if (cleanValue.isEmpty) {
            return null;
          }

          final number = double.tryParse(cleanValue.replaceAll(',', '.'));

          if (number == null || number < 0) {
            return 'Ingrese Jornal real válido.';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildObservationField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _observationController,
        enabled: !_isFieldLockedForNormalEditing('observation'),
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: 'Observación',
          prefixIcon: Icon(Icons.notes_outlined),
        ),
      ),
    );
  }

  String _formatRecordLotNetwork(
    FarmRecord? record,
    List<FarmRecordLocation> locations,
  ) {
    if (locations.isNotEmpty) {
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
            ..sort(_compareMixedNumbers);

      return values.join(', ');
    }

    return _formatLotNetwork(record?.lot, record?.network);
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

  String _formatRecordSectors(List<FarmRecordLocation> locations) {
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

    if (sectors.isEmpty) {
      return '-';
    }

    return sectors.join(', ');
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  String _formatControllerNumber(double? value) {
    if (value == null) {
      return '';
    }

    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    }

    return value.toString();
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

  int _compareMixedNumbers(String first, String second) {
    final firstNumber = int.tryParse(first.trim());
    final secondNumber = int.tryParse(second.trim());

    if (firstNumber != null && secondNumber != null) {
      return firstNumber.compareTo(secondNumber);
    }

    return first.compareTo(second);
  }
}

class _ReadOnlySummaryRow extends StatelessWidget {
  const _ReadOnlySummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
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
