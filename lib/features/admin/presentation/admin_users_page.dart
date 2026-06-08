import 'package:flutter/material.dart';
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

      await repository.ensureDemoData();

      final users = await repository.getUsers();
      final roles = await repository.getRoles();
      final departments = await repository.getDepartments();

      if (!mounted) {
        return;
      }

      setState(() {
        _users = users;
        _roles = roles;
        _departments = departments;
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
    final pinController = TextEditingController(
      text: user?.passwordPin ?? '123456',
    );

    String? selectedRoleId =
        user?.roleId ?? (_roles.isEmpty ? null : _roles.first.id);

    bool isActive = user?.isActive ?? true;

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
            return AlertDialog(
              title: Text(user == null ? 'Nuevo usuario' : 'Editar usuario'),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
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
                      TextField(
                        controller: pinController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña de 6 dígitos',
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRoleId,
                        decoration: const InputDecoration(labelText: 'Rol'),
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
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Departamentos asignados',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ..._departments.map(
                        (department) => CheckboxListTile(
                          value: selectedDepartmentIds.contains(department.id),
                          title: Text(department.name),
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
                      await repository.saveUser(
                        existing: user,
                        code: codeController.text,
                        fullName: nameController.text,
                        passwordPin: pinController.text,
                        roleId: selectedRoleId ?? '',
                        isActive: isActive,
                        departmentIds: selectedDepartmentIds.toList(),
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
              children: _users
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
                          'Código: ${user.code} | Rol: ${user.roleId} | Estado: ${user.isActive ? 'Activo' : 'Inactivo'}',
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
}
