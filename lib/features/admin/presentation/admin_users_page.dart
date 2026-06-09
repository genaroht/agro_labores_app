import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../shared/providers/session_provider.dart';
import '../data/admin_repository.dart';

class AdminUsersPage extends ConsumerStatefulWidget {
  const AdminUsersPage({super.key});

  @override
  ConsumerState<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends ConsumerState<AdminUsersPage> {
  bool _isLoading = false;
  List<LocalUser> _users = [];
  List<LocalRole> _roles = [];
  List<Department> _departments = [];
  List<FarmOperator> _operators = [];
  List<OperatorPosition> _positions = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
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

      final users = await repository.getUsers();
      final roles = await repository.getRoles();
      final departments = await repository.getDepartments();
      final operators = await repository.getOperators();
      final positions = await repository.getPositions();

      if (!mounted) {
        return;
      }

      setState(() {
        _users = users;
        _roles = roles;
        _departments = departments;
        _operators = operators;
        _positions = positions;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openForm([LocalUser? user]) async {
    final repository = ref.read(adminRepositoryProvider);

    final codeController = TextEditingController(text: user?.code ?? '');
    final nameController = TextEditingController(text: user?.fullName ?? '');
    final pinController = TextEditingController();
    final operatorSearchController = TextEditingController();

    String? selectedRoleId =
        user?.roleId ?? (_roles.isEmpty ? null : _roles.first.id);
    String? selectedOperatorId = user?.operatorId;
    bool createFromOperator = selectedOperatorId != null;
    bool isActive = user?.isActive ?? true;
    String operatorSearch = '';

    final selectedDepartmentIds = <String>{};

    if (user != null) {
      selectedDepartmentIds.addAll(
        await repository.getDepartmentIdsForUser(user.id),
      );
    }

    if (!mounted) {
      return;
    }

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final selectedRole = _roleById(selectedRoleId);
            final selectedRoleIsAdmin = selectedRole?.isAdmin ?? false;
            final selectedOperator = _operatorById(selectedOperatorId);
            final filteredOperators = _filteredOperators(operatorSearch);

            return AlertDialog(
              title: Text(user == null ? 'Nuevo usuario' : 'Editar usuario'),
              content: SizedBox(
                width: 620,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment<bool>(
                            value: false,
                            icon: Icon(Icons.edit_outlined),
                            label: Text('Manual'),
                          ),
                          ButtonSegment<bool>(
                            value: true,
                            icon: Icon(Icons.badge_outlined),
                            label: Text('Desde persona'),
                          ),
                        ],
                        selected: {createFromOperator},
                        onSelectionChanged: (values) {
                          setDialogState(() {
                            createFromOperator = values.first;
                            if (!createFromOperator) {
                              selectedOperatorId = null;
                              operatorSearch = '';
                              operatorSearchController.clear();
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      if (createFromOperator) ...[
                        TextField(
                          controller: operatorSearchController,
                          decoration: const InputDecoration(
                            labelText: 'Buscar persona/operario',
                            prefixIcon: Icon(Icons.search),
                            helperText: 'Buscar por código o nombre',
                          ),
                          onChanged: (value) {
                            setDialogState(() => operatorSearch = value);
                          },
                        ),
                        const SizedBox(height: 8),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 190),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: filteredOperators.isEmpty
                                ? const [
                                    ListTile(
                                      title: Text(
                                        'No hay personas disponibles.',
                                      ),
                                    ),
                                  ]
                                : filteredOperators.map((operator) {
                                    final isSelected =
                                        operator.id == selectedOperatorId;

                                    return ListTile(
                                      leading: Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                      ),
                                      title: Text(operator.fullName),
                                      subtitle: Text(
                                        'Código: ${operator.code} | Departamento: ${_departmentName(operator.departmentId)} | Cargo: ${_positionName(operator.positionId)}',
                                      ),
                                      selected: isSelected,
                                      onTap: () {
                                        setDialogState(() {
                                          selectedOperatorId = operator.id;
                                          codeController.text = operator.code;
                                          nameController.text =
                                              operator.fullName;

                                          if (!selectedRoleIsAdmin &&
                                              operator.departmentId != null) {
                                            selectedDepartmentIds.add(
                                              operator.departmentId!,
                                            );
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                          ),
                        ),
                        if (selectedOperator != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Seleccionado: ${selectedOperator.fullName} (${selectedOperator.code})',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                        const Divider(height: 28),
                      ],
                      TextField(
                        controller: codeController,
                        enabled: !createFromOperator,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Código de usuario',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nameController,
                        enabled: !createFromOperator,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: pinController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: user == null
                              ? 'Contraseña'
                              : 'Nueva contraseña',
                          helperText: user == null
                              ? 'Obligatoria para crear usuario'
                              : 'Dejar vacío para mantener la contraseña actual',
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRoleId,
                        decoration: const InputDecoration(
                          labelText: 'Cargo / acceso',
                          helperText:
                              'Define si la persona entra como administrador o supervisor',
                        ),
                        items: _roles
                            .map(
                              (role) => DropdownMenuItem(
                                value: role.id,
                                child: Text(role.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedRoleId = value;
                            final role = _roleById(value);

                            if (role?.isAdmin == true) {
                              selectedDepartmentIds.clear();
                            } else if (selectedOperator?.departmentId != null) {
                              selectedDepartmentIds.add(
                                selectedOperator!.departmentId!,
                              );
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: const Text('Usuario activo'),
                        value: isActive,
                        onChanged: (value) {
                          setDialogState(() {
                            isActive = value;
                          });
                        },
                      ),
                      const Divider(),
                      if (selectedRoleIsAdmin)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'El administrador tiene acceso global a todos los departamentos activos.',
                          ),
                        )
                      else ...[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Departamentos asignados al supervisor',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._departments.map(
                          (department) => CheckboxListTile(
                            value: selectedDepartmentIds.contains(
                              department.id,
                            ),
                            title: Text(department.name),
                            subtitle: Text(
                              'Cultivo: ${_cropIdLabel(department.cropId)}',
                            ),
                            onChanged: (checked) {
                              setDialogState(() {
                                if (checked == true) {
                                  selectedDepartmentIds.add(department.id);
                                } else {
                                  selectedDepartmentIds.remove(department.id);
                                }
                              });
                            },
                          ),
                        ),
                      ],
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
                      if (createFromOperator && selectedOperatorId == null) {
                        throw Exception('Seleccione una persona/operario.');
                      }

                      await repository.saveUser(
                        existing: user,
                        code: codeController.text,
                        fullName: nameController.text,
                        passwordPin: pinController.text,
                        roleId: selectedRoleId ?? '',
                        isActive: isActive,
                        departmentIds: selectedDepartmentIds.toList(),
                        operatorId: createFromOperator
                            ? selectedOperatorId
                            : null,
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
    pinController.dispose();
    operatorSearchController.dispose();
  }

  Future<void> _delete(LocalUser user) async {
    final repository = ref.read(adminRepositoryProvider);

    await repository.deleteUser(user);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);

    if (!session.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Usuarios')),
        body: const Center(child: Text('Acceso solo para admin.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: _users.isEmpty
                  ? const [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No hay usuarios.'),
                        ),
                      ),
                    ]
                  : _users
                        .map(
                          (user) => Card(
                            child: ListTile(
                              leading: Icon(
                                user.isActive
                                    ? Icons.person_outline
                                    : Icons.person_off_outlined,
                              ),
                              title: Text(user.fullName),
                              subtitle: Text(
                                'Código: ${user.code} | Cargo/acceso: ${_roleName(user.roleId)} | Vinculado a persona: ${_operatorName(user.operatorId)} | Estado: ${user.isActive ? 'Activo' : 'Inactivo'}',
                              ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                    onPressed: () => _openForm(user),
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () => _delete(user),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
            ),
    );
  }

  List<FarmOperator> _filteredOperators(String query) {
    final cleanQuery = query.trim().toLowerCase();
    final activeOperators = _operators.where((operator) => operator.isActive);

    if (cleanQuery.isEmpty) {
      return activeOperators.take(30).toList();
    }

    return activeOperators
        .where(
          (operator) =>
              operator.code.contains(cleanQuery) ||
              operator.fullName.toLowerCase().contains(cleanQuery),
        )
        .take(30)
        .toList();
  }

  LocalRole? _roleById(String? roleId) {
    if (roleId == null) {
      return null;
    }

    for (final role in _roles) {
      if (role.id == roleId) {
        return role;
      }
    }

    return null;
  }

  FarmOperator? _operatorById(String? operatorId) {
    if (operatorId == null) {
      return null;
    }

    for (final operator in _operators) {
      if (operator.id == operatorId) {
        return operator;
      }
    }

    return null;
  }

  String _roleName(String roleId) {
    return _roleById(roleId)?.name ?? roleId;
  }

  String _operatorName(String? operatorId) {
    if (operatorId == null) {
      return '-';
    }

    return _operatorById(operatorId)?.fullName ?? operatorId;
  }

  String _departmentName(String? departmentId) {
    if (departmentId == null) {
      return '-';
    }

    for (final department in _departments) {
      if (department.id == departmentId) {
        return department.name;
      }
    }

    return departmentId;
  }

  String _positionName(String? positionId) {
    if (positionId == null) {
      return '-';
    }

    for (final position in _positions) {
      if (position.id == positionId) {
        return position.name;
      }
    }

    return positionId;
  }

  String _cropIdLabel(String? cropId) => cropId ?? '-';
}

void _showError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
  );
}
