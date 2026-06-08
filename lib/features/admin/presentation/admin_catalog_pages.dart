import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(adminRepositoryProvider);
      await repository.ensureDemoData();

      final items = await repository.getDepartments();

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

  Future<void> _openForm([Department? item]) async {
    final repository = ref.read(adminRepositoryProvider);
    final nameController = TextEditingController(text: item?.name ?? '');
    var isActive = item?.isActive ?? true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(
              item == null ? 'Nuevo departamento' : 'Editar departamento',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
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
                    await repository.saveDepartment(
                      existing: item,
                      name: nameController.text,
                      isActive: isActive,
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } catch (error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            error.toString().replaceFirst('Exception: ', ''),
                          ),
                        ),
                      );
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
    if (!ref.watch(sessionProvider).isAdmin) {
      return _adminOnlyScaffold('Departamentos');
    }

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

class AdminOperatorsPage extends ConsumerStatefulWidget {
  const AdminOperatorsPage({super.key});

  @override
  ConsumerState<AdminOperatorsPage> createState() => _AdminOperatorsPageState();
}

class _AdminOperatorsPageState extends ConsumerState<AdminOperatorsPage> {
  bool _isLoading = false;
  List<FarmOperator> _items = [];
  List<Department> _departments = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(adminRepositoryProvider);
      await repository.ensureDemoData();

      final items = await repository.getOperators();
      final departments = await repository.getDepartments();

      if (!mounted) {
        return;
      }

      setState(() {
        _items = items;
        _departments = departments;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openForm([FarmOperator? item]) async {
    final repository = ref.read(adminRepositoryProvider);

    final codeController = TextEditingController(text: item?.code ?? '');
    final nameController = TextEditingController(text: item?.fullName ?? '');

    String? departmentId = item?.departmentId;
    var isActive = item?.isActive ?? true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(item == null ? 'Nuevo operario' : 'Editar operario'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: codeController,
                    decoration: const InputDecoration(labelText: 'Código'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
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
                    await repository.saveOperator(
                      existing: item,
                      code: codeController.text,
                      fullName: nameController.text,
                      departmentId: departmentId,
                      isActive: isActive,
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } catch (error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            error.toString().replaceFirst('Exception: ', ''),
                          ),
                        ),
                      );
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
    if (!ref.watch(sessionProvider).isAdmin) {
      return _adminOnlyScaffold('Operarios');
    }

    return _CatalogScaffold(
      title: 'Operarios',
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
                  'Código: ${item.code} | Departamento: ${_departmentName(item.departmentId)} | ${item.isActive ? 'Activo' : 'Inactivo'}',
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
      await repository.ensureDemoData();

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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            error.toString().replaceFirst('Exception: ', ''),
                          ),
                        ),
                      );
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
    if (!ref.watch(sessionProvider).isAdmin) {
      return _adminOnlyScaffold('Cultivos');
    }

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

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(adminRepositoryProvider);
      await repository.ensureDemoData();

      final items = await repository.getTasks();
      final departments = await repository.getDepartments();

      if (!mounted) {
        return;
      }

      setState(() {
        _items = items;
        _departments = departments;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openForm([FarmTask? item]) async {
    final repository = ref.read(adminRepositoryProvider);

    final nameController = TextEditingController(text: item?.name ?? '');
    final detailController = TextEditingController(
      text: item?.defaultDetail ?? '',
    );

    String? departmentId = item?.departmentId;
    var isActive = item?.isActive ?? true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(item == null ? 'Nueva labor' : 'Editar labor'),
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
                    initialValue: departmentId,
                    decoration: const InputDecoration(
                      labelText: 'Departamento',
                    ),
                    items: _departments
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
                  TextField(
                    controller: detailController,
                    decoration: const InputDecoration(
                      labelText: 'Detalle por defecto',
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
                      name: nameController.text,
                      departmentId: departmentId,
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            error.toString().replaceFirst('Exception: ', ''),
                          ),
                        ),
                      );
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
    detailController.dispose();
  }

  Future<void> _delete(FarmTask item) async {
    await ref.read(adminRepositoryProvider).deleteTask(item);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(sessionProvider).isAdmin) {
      return _adminOnlyScaffold('Labores');
    }

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
                title: Text(item.name),
                subtitle: Text(
                  'Departamento: ${_departmentName(item.departmentId)} | ${item.isActive ? 'Activo' : 'Inactivo'}',
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
      await repository.ensureDemoData();

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

    String? cropId = item?.cropId ?? (_crops.isEmpty ? null : _crops.first.id);

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

                    if (cropId == null) {
                      throw Exception('Seleccione cultivo.');
                    }

                    if (ha == null) {
                      throw Exception('Ingrese Ha válida.');
                    }

                    await repository.saveLocation(
                      existing: item,
                      cropId: cropId!,
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            error.toString().replaceFirst('Exception: ', ''),
                          ),
                        ),
                      );
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
    if (!ref.watch(sessionProvider).isAdmin) {
      return _adminOnlyScaffold('Ubicaciones');
    }

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
                  '${_cropName(item.cropId)} | ${item.lot} | ${item.network} | ${item.sector}',
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

Widget _adminOnlyScaffold(String title) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: const Center(child: Text('Solo el administrador puede acceder.')),
  );
}
