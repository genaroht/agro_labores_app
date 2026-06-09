import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../shared/providers/session_provider.dart';
import '../data/admin_repository.dart';

class AdminDepartmentsPage extends ConsumerStatefulWidget {
  const AdminDepartmentsPage({super.key});

  @override
  ConsumerState<AdminDepartmentsPage> createState() =>
      _AdminDepartmentsPageState();
}

class _AdminDepartmentsPageState extends ConsumerState<AdminDepartmentsPage> {
  bool _isLoading = false;
  List<Department> _items = [];
  List<Crop> _crops = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(adminRepositoryProvider);
      await repository.ensureDevelopmentSeedData();

      final items = await repository.getDepartments();
      final crops = await repository.getCrops();

      if (!mounted) {
        return;
      }

      setState(() {
        _items = items;
        _crops = crops;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openForm([Department? item]) async {
    final repository = ref.read(adminRepositoryProvider);
    final nameController = TextEditingController(text: item?.name ?? '');
    String? cropId = item?.cropId ?? _firstActiveCropId();
    var isActive = item?.isActive ?? true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(
              item == null ? 'Nuevo departamento' : 'Editar departamento',
            ),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: cropId,
                    decoration: const InputDecoration(
                      labelText: 'Cultivo principal',
                    ),
                    items: _crops
                        .where(
                          (crop) => crop.isActive || crop.id == item?.cropId,
                        )
                        .map(
                          (crop) => DropdownMenuItem(
                            value: crop.id,
                            child: Text(crop.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() => cropId = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Activo'),
                    value: isActive,
                    onChanged: (value) {
                      setDialogState(() => isActive = value);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () async {
                  try {
                    await repository.saveDepartment(
                      existing: item,
                      name: nameController.text,
                      cropId: cropId ?? '',
                      isActive: isActive,
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } catch (error) {
                    if (context.mounted) {
                      _showError(context, error);
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        );
      },
    );

    if (saved == true) {
      await _load();
    }

    nameController.dispose();
  }

  Future<void> _delete(Department item) async {
    await ref.read(adminRepositoryProvider).deleteDepartment(item);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return _CatalogScaffold(
      title: 'Departamentos',
      isLoading: _isLoading,
      onRefresh: _load,
      onNew: () => _openForm(),
      children: _items
          .map(
            (item) => Card(
              child: ListTile(
                leading: Icon(
                  item.isActive ? Icons.business_outlined : Icons.block,
                ),
                title: Text(item.name),
                subtitle: Text(
                  'Cultivo: ${_cropName(item.cropId)} | ${item.isActive ? 'Activo' : 'Inactivo'}',
                ),
                trailing: _EditDeleteActions(
                  onEdit: () => _openForm(item),
                  onDelete: () => _delete(item),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  String? _firstActiveCropId() {
    for (final crop in _crops) {
      if (crop.isActive) {
        return crop.id;
      }
    }

    return null;
  }

  String _cropName(String? id) {
    if (id == null) {
      return '-';
    }

    for (final crop in _crops) {
      if (crop.id == id) {
        return crop.name;
      }
    }

    return id;
  }
}

class AdminOperatorsPage extends ConsumerStatefulWidget {
  const AdminOperatorsPage({super.key});

  @override
  ConsumerState<AdminOperatorsPage> createState() => _AdminOperatorsPageState();
}

class _AdminOperatorsPageState extends ConsumerState<AdminOperatorsPage> {
  bool _isLoading = false;
  List<FarmOperator> _items = [];
  List<Department> _departments = [];
  List<OperatorPosition> _positions = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(adminRepositoryProvider);
      final session = ref.read(sessionProvider);
      await repository.ensureDevelopmentSeedData();

      final allowedDepartmentIds = session.assignedDepartments
          .map((department) => department.id)
          .toList();
      final items = await repository.getOperators(
        allowedDepartmentIds: session.isAdmin ? null : allowedDepartmentIds,
      );
      final departments = session.isAdmin
          ? await repository.getDepartments()
          : await repository.getDepartmentsForSupervisor(allowedDepartmentIds);
      final positions = await repository.getPositions();

      if (!mounted) {
        return;
      }

      setState(() {
        _items = items;
        _departments = departments;
        _positions = positions;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openForm([FarmOperator? item]) async {
    final repository = ref.read(adminRepositoryProvider);
    final session = ref.read(sessionProvider);

    final codeController = TextEditingController(text: item?.code ?? '');
    final nameController = TextEditingController(text: item?.fullName ?? '');

    String? departmentId = item?.departmentId ?? _defaultDepartmentId();
    String? positionId = item?.positionId ?? _defaultPositionId();
    var isActive = item?.isActive ?? true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(
              item == null
                  ? 'Nueva persona/operario'
                  : 'Editar persona/operario',
            ),
            content: SizedBox(
              width: 460,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: codeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(labelText: 'Código'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: departmentId,
                      decoration: const InputDecoration(
                        labelText: 'Departamento',
                      ),
                      items: _departments
                          .where(
                            (department) =>
                                department.isActive ||
                                department.id == item?.departmentId,
                          )
                          .map(
                            (department) => DropdownMenuItem(
                              value: department.id,
                              child: Text(department.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() => departmentId = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: positionId,
                      decoration: const InputDecoration(
                        labelText: 'Cargo de la persona',
                        helperText: 'Cargo no es rol del sistema',
                      ),
                      items: _positions
                          .where(
                            (position) =>
                                position.isActive ||
                                position.id == item?.positionId,
                          )
                          .map(
                            (position) => DropdownMenuItem(
                              value: position.id,
                              child: Text(position.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() => positionId = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('Activo'),
                      value: isActive,
                      onChanged: (value) {
                        setDialogState(() => isActive = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () async {
                  try {
                    await repository.saveOperator(
                      existing: item,
                      code: codeController.text,
                      fullName: nameController.text,
                      departmentId: departmentId ?? '',
                      positionId: positionId ?? '',
                      isActive: isActive,
                      isAdmin: session.isAdmin,
                      allowedDepartmentIds: session.assignedDepartments
                          .map((department) => department.id)
                          .toList(),
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } catch (error) {
                    if (context.mounted) {
                      _showError(context, error);
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        );
      },
    );

    if (saved == true) {
      await _load();
    }

    codeController.dispose();
    nameController.dispose();
  }

  Future<void> _delete(FarmOperator item) async {
    await ref.read(adminRepositoryProvider).deleteOperator(item);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);

    return _CatalogScaffold(
      title: session.isAdmin
          ? 'Operarios / Personas'
          : 'Personas del departamento',
      isLoading: _isLoading,
      onRefresh: _load,
      onNew: () => _openForm(),
      children: _items
          .map(
            (item) => Card(
              child: ListTile(
                leading: Icon(
                  item.isActive ? Icons.badge_outlined : Icons.block,
                ),
                title: Text(item.fullName),
                subtitle: Text(
                  'Código: ${item.code} | Departamento: ${_departmentName(item.departmentId)} | Cargo: ${_positionName(item.positionId)} | ${item.isActive ? 'Activo' : 'Inactivo'}',
                ),
                trailing: session.isAdmin
                    ? _EditDeleteActions(
                        onEdit: () => _openForm(item),
                        onDelete: () => _delete(item),
                      )
                    : IconButton(
                        tooltip: 'Editar',
                        onPressed: () => _openForm(item),
                        icon: const Icon(Icons.edit),
                      ),
              ),
            ),
          )
          .toList(),
    );
  }

  String? _defaultDepartmentId() {
    final activeDepartments = _departments
        .where((department) => department.isActive)
        .toList();

    if (activeDepartments.length == 1) {
      return activeDepartments.first.id;
    }

    return null;
  }

  String? _defaultPositionId() {
    for (final position in _positions) {
      if (position.isActive && position.name.toLowerCase() == 'operario') {
        return position.id;
      }
    }

    for (final position in _positions) {
      if (position.isActive) {
        return position.id;
      }
    }

    return null;
  }

  String _departmentName(String? id) {
    if (id == null) {
      return '-';
    }

    for (final department in _departments) {
      if (department.id == id) {
        return department.name;
      }
    }

    return id;
  }

  String _positionName(String? id) {
    if (id == null) {
      return '-';
    }

    for (final position in _positions) {
      if (position.id == id) {
        return position.name;
      }
    }

    return id;
  }
}

class AdminCropsPage extends ConsumerStatefulWidget {
  const AdminCropsPage({super.key});

  @override
  ConsumerState<AdminCropsPage> createState() => _AdminCropsPageState();
}

class _AdminCropsPageState extends ConsumerState<AdminCropsPage> {
  bool _isLoading = false;
  List<Crop> _items = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(adminRepositoryProvider);
      await repository.ensureDevelopmentSeedData();

      final items = await repository.getCrops();

      if (!mounted) {
        return;
      }

      setState(() => _items = items);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openForm([Crop? item]) async {
    final repository = ref.read(adminRepositoryProvider);
    final nameController = TextEditingController(text: item?.name ?? '');
    var isActive = item?.isActive ?? true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(item == null ? 'Nuevo cultivo' : 'Editar cultivo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Activo'),
                  value: isActive,
                  onChanged: (value) {
                    setDialogState(() => isActive = value);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () async {
                  try {
                    await repository.saveCrop(
                      existing: item,
                      name: nameController.text,
                      isActive: isActive,
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } catch (error) {
                    if (context.mounted) {
                      _showError(context, error);
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        );
      },
    );

    if (saved == true) {
      await _load();
    }

    nameController.dispose();
  }

  Future<void> _delete(Crop item) async {
    await ref.read(adminRepositoryProvider).deleteCrop(item);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return _CatalogScaffold(
      title: 'Cultivos',
      isLoading: _isLoading,
      onRefresh: _load,
      onNew: () => _openForm(),
      children: _items
          .map(
            (item) => Card(
              child: ListTile(
                leading: Icon(
                  item.isActive ? Icons.grass_outlined : Icons.block,
                ),
                title: Text(item.name),
                subtitle: Text(item.isActive ? 'Activo' : 'Inactivo'),
                trailing: _EditDeleteActions(
                  onEdit: () => _openForm(item),
                  onDelete: () => _delete(item),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class AdminTasksPage extends ConsumerStatefulWidget {
  const AdminTasksPage({super.key});

  @override
  ConsumerState<AdminTasksPage> createState() => _AdminTasksPageState();
}

class _AdminTasksPageState extends ConsumerState<AdminTasksPage> {
  bool _isLoading = false;
  List<FarmTask> _items = [];
  List<Department> _departments = [];
  List<Crop> _crops = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(adminRepositoryProvider);
      await repository.ensureDevelopmentSeedData();

      final items = await repository.getTasks();
      final departments = await repository.getDepartments();
      final crops = await repository.getCrops();

      if (!mounted) {
        return;
      }

      setState(() {
        _items = items;
        _departments = departments;
        _crops = crops;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openForm([FarmTask? item]) async {
    final repository = ref.read(adminRepositoryProvider);
    final codeController = TextEditingController(text: item?.code ?? '');
    final nameController = TextEditingController(text: item?.name ?? '');
    final detailController = TextEditingController(
      text: item?.defaultDetail ?? '',
    );
    String? departmentId = item?.departmentId ?? _firstActiveDepartmentId();
    var isActive = item?.isActive ?? true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final selectedDepartment = _departmentById(departmentId);
            final cropName = _cropName(selectedDepartment?.cropId);

            return AlertDialog(
              title: Text(item == null ? 'Nueva labor' : 'Editar labor'),
              content: SizedBox(
                width: 460,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: departmentId,
                        decoration: const InputDecoration(
                          labelText: 'Departamento *',
                        ),
                        items: _departments
                            .where(
                              (department) =>
                                  department.isActive ||
                                  department.id == item?.departmentId,
                            )
                            .map(
                              (department) => DropdownMenuItem(
                                value: department.id,
                                child: Text(department.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setDialogState(() => departmentId = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Cultivo asociado: ${cropName ?? '-'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: codeController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          labelText: 'Código de labor *',
                          helperText: 'Debe ser único dentro del departamento',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Descripción de labor *',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: detailController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Detalle por defecto opcional',
                        ),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: const Text('Activo'),
                        value: isActive,
                        onChanged: (value) {
                          setDialogState(() => isActive = value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    try {
                      await repository.saveTask(
                        existing: item,
                        code: codeController.text,
                        name: nameController.text,
                        departmentId: departmentId ?? '',
                        defaultDetail: detailController.text.trim().isEmpty
                            ? null
                            : detailController.text.trim(),
                        isActive: isActive,
                      );

                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    } catch (error) {
                      if (context.mounted) {
                        _showError(context, error);
                      }
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved == true) {
      await _load();
    }

    codeController.dispose();
    nameController.dispose();
    detailController.dispose();
  }

  Future<void> _delete(FarmTask item) async {
    await ref.read(adminRepositoryProvider).deleteTask(item);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return _CatalogScaffold(
      title: 'Labores',
      isLoading: _isLoading,
      onRefresh: _load,
      onNew: () => _openForm(),
      children: _items
          .map(
            (item) => Card(
              child: ListTile(
                leading: Icon(item.isActive ? Icons.work_outline : Icons.block),
                title: Text('${item.code ?? '-'} | ${item.name}'),
                subtitle: Text(
                  'Departamento: ${_departmentName(item.departmentId)} | Cultivo: ${_cropName(item.cropId) ?? '-'} | ${item.isActive ? 'Activo' : 'Inactivo'}',
                ),
                trailing: _EditDeleteActions(
                  onEdit: () => _openForm(item),
                  onDelete: () => _delete(item),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  String? _firstActiveDepartmentId() {
    for (final department in _departments) {
      if (department.isActive && department.cropId != null) {
        return department.id;
      }
    }

    return null;
  }

  Department? _departmentById(String? id) {
    if (id == null) {
      return null;
    }

    for (final department in _departments) {
      if (department.id == id) {
        return department;
      }
    }

    return null;
  }

  String _departmentName(String? id) {
    return _departmentById(id)?.name ?? '-';
  }

  String? _cropName(String? id) {
    if (id == null) {
      return null;
    }

    for (final crop in _crops) {
      if (crop.id == id) {
        return crop.name;
      }
    }

    return id;
  }
}

class AdminDiningRoomsPage extends ConsumerStatefulWidget {
  const AdminDiningRoomsPage({super.key});

  @override
  ConsumerState<AdminDiningRoomsPage> createState() =>
      _AdminDiningRoomsPageState();
}

class _AdminDiningRoomsPageState extends ConsumerState<AdminDiningRoomsPage> {
  bool _isLoading = false;
  List<DiningRoom> _items = [];
  List<Crop> _crops = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(adminRepositoryProvider);
      await repository.ensureDevelopmentSeedData();

      final items = await repository.getDiningRooms();
      final crops = await repository.getCrops();

      if (!mounted) {
        return;
      }

      setState(() {
        _items = items;
        _crops = crops;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openForm([DiningRoom? item]) async {
    final repository = ref.read(adminRepositoryProvider);
    final nameController = TextEditingController(text: item?.name ?? '');
    final lotController = TextEditingController(text: item?.lot ?? '');
    final networkController = TextEditingController(text: item?.network ?? '');
    String? cropId = item?.cropId ?? _firstActiveCropId();
    var isActive = item?.isActive ?? true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(item == null ? 'Nuevo comedor' : 'Editar comedor'),
            content: SizedBox(
              width: 460,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Nombre *'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: cropId,
                      decoration: const InputDecoration(labelText: 'Cultivo *'),
                      items: _crops
                          .where(
                            (crop) => crop.isActive || crop.id == item?.cropId,
                          )
                          .map(
                            (crop) => DropdownMenuItem(
                              value: crop.id,
                              child: Text(crop.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() => cropId = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: lotController,
                      decoration: const InputDecoration(
                        labelText: 'Lote *',
                        helperText:
                            'Puede escribir 4 o Lote 4; se guardará como 4',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: networkController,
                      decoration: const InputDecoration(
                        labelText: 'Red *',
                        helperText:
                            'Puede escribir 2, R2 o Red 2; se guardará como 2',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('Activo'),
                      value: isActive,
                      onChanged: (value) {
                        setDialogState(() => isActive = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () async {
                  try {
                    await repository.saveDiningRoom(
                      existing: item,
                      name: nameController.text,
                      cropId: cropId ?? '',
                      lot: lotController.text,
                      network: networkController.text,
                      isActive: isActive,
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } catch (error) {
                    if (context.mounted) {
                      _showError(context, error);
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        );
      },
    );

    if (saved == true) {
      await _load();
    }

    nameController.dispose();
    lotController.dispose();
    networkController.dispose();
  }

  Future<void> _delete(DiningRoom item) async {
    await ref.read(adminRepositoryProvider).deleteDiningRoom(item);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return _CatalogScaffold(
      title: 'Comedores',
      isLoading: _isLoading,
      onRefresh: _load,
      onNew: () => _openForm(),
      children: _items
          .map(
            (item) => Card(
              child: ListTile(
                leading: Icon(
                  item.isActive ? Icons.restaurant_outlined : Icons.block,
                ),
                title: Text(item.name),
                subtitle: Text(
                  'Cultivo: ${_cropName(item.cropId)} | Lote: ${AgroLocalValueFormatters.compactLot(item.lot ?? '-')} | Red: ${AgroLocalValueFormatters.compactNetwork(item.network ?? '-')} | ${item.isActive ? 'Activo' : 'Inactivo'}',
                ),
                trailing: _EditDeleteActions(
                  onEdit: () => _openForm(item),
                  onDelete: () => _delete(item),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  String? _firstActiveCropId() {
    for (final crop in _crops) {
      if (crop.isActive) {
        return crop.id;
      }
    }

    return null;
  }

  String _cropName(String id) {
    for (final crop in _crops) {
      if (crop.id == id) {
        return crop.name;
      }
    }

    return id;
  }
}

class AdminLocationsPage extends ConsumerStatefulWidget {
  const AdminLocationsPage({super.key});

  @override
  ConsumerState<AdminLocationsPage> createState() => _AdminLocationsPageState();
}

class _AdminLocationsPageState extends ConsumerState<AdminLocationsPage> {
  bool _isLoading = false;
  List<LocationEntry> _items = [];
  List<Crop> _crops = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(adminRepositoryProvider);
      await repository.ensureDevelopmentSeedData();

      final items = await repository.getLocations();
      final crops = await repository.getCrops();

      if (!mounted) {
        return;
      }

      setState(() {
        _items = items;
        _crops = crops;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openForm([LocationEntry? item]) async {
    final repository = ref.read(adminRepositoryProvider);
    String? cropId = item?.cropId ?? _firstActiveCropId();
    final lotController = TextEditingController(text: item?.lot ?? '');
    final networkController = TextEditingController(text: item?.network ?? '');
    final sectorController = TextEditingController(text: item?.sector ?? '');
    final haController = TextEditingController(text: item?.ha.toString() ?? '');
    final diningController = TextEditingController(
      text: item?.suggestedDiningRoom ?? '',
    );
    var isActive = item?.isActive ?? true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(item == null ? 'Nueva ubicación' : 'Editar ubicación'),
            content: SizedBox(
              width: 420,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: cropId,
                      decoration: const InputDecoration(labelText: 'Cultivo'),
                      items: _crops
                          .map(
                            (crop) => DropdownMenuItem(
                              value: crop.id,
                              child: Text(crop.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() => cropId = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: lotController,
                      decoration: const InputDecoration(labelText: 'Lote'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: networkController,
                      decoration: const InputDecoration(labelText: 'Red'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: sectorController,
                      decoration: const InputDecoration(labelText: 'Sector'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: haController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Ha'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: diningController,
                      decoration: const InputDecoration(
                        labelText: 'Comedor sugerido',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('Activo'),
                      value: isActive,
                      onChanged: (value) {
                        setDialogState(() => isActive = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () async {
                  try {
                    final ha = double.tryParse(
                      haController.text.replaceAll(',', '.'),
                    );

                    if (ha == null) {
                      throw Exception('Ingrese Ha válida.');
                    }

                    await repository.saveLocation(
                      existing: item,
                      cropId: cropId ?? '',
                      lot: lotController.text,
                      network: networkController.text,
                      sector: sectorController.text,
                      ha: ha,
                      suggestedDiningRoom: diningController.text.trim().isEmpty
                          ? null
                          : diningController.text.trim(),
                      isActive: isActive,
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } catch (error) {
                    if (context.mounted) {
                      _showError(context, error);
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        );
      },
    );

    if (saved == true) {
      await _load();
    }

    lotController.dispose();
    networkController.dispose();
    sectorController.dispose();
    haController.dispose();
    diningController.dispose();
  }

  Future<void> _delete(LocationEntry item) async {
    await ref.read(adminRepositoryProvider).deleteLocation(item);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return _CatalogScaffold(
      title: 'Ubicaciones / matriz',
      isLoading: _isLoading,
      onRefresh: _load,
      onNew: () => _openForm(),
      children: _items
          .map(
            (item) => Card(
              child: ListTile(
                leading: Icon(item.isActive ? Icons.map_outlined : Icons.block),
                title: Text(
                  '${_cropName(item.cropId)} | ${AgroLocalValueFormatters.compactLot(item.lot)} | ${AgroLocalValueFormatters.compactNetwork(item.network)} | ${AgroLocalValueFormatters.compactSector(item.sector)}',
                ),
                subtitle: Text(
                  'Ha: ${item.ha.toStringAsFixed(2)} | Comedor sugerido: ${item.suggestedDiningRoom ?? '-'} | ${item.isActive ? 'Activo' : 'Inactivo'}',
                ),
                trailing: _EditDeleteActions(
                  onEdit: () => _openForm(item),
                  onDelete: () => _delete(item),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  String? _firstActiveCropId() {
    for (final crop in _crops) {
      if (crop.isActive) {
        return crop.id;
      }
    }

    return null;
  }

  String _cropName(String id) {
    for (final crop in _crops) {
      if (crop.id == id) {
        return crop.name;
      }
    }

    return id;
  }
}

class _CatalogScaffold extends StatelessWidget {
  const _CatalogScaffold({
    required this.title,
    required this.isLoading,
    required this.onRefresh,
    required this.onNew,
    required this.children,
  });

  final String title;
  final bool isLoading;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onNew;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              onRefresh();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          onNew();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: children.isEmpty
                  ? [
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No hay datos.'),
                        ),
                      ),
                    ]
                  : children,
            ),
    );
  }
}

class _EditDeleteActions extends StatelessWidget {
  const _EditDeleteActions({required this.onEdit, required this.onDelete});

  final Future<void> Function() onEdit;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        IconButton(
          onPressed: () {
            onEdit();
          },
          icon: const Icon(Icons.edit),
        ),
        IconButton(
          onPressed: () {
            onDelete();
          },
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }
}

void _showError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
  );
}
