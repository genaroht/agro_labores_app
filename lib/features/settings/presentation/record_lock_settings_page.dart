import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/session_provider.dart';
import '../data/record_lock_config.dart';

class RecordLockSettingsPage extends ConsumerStatefulWidget {
  const RecordLockSettingsPage({super.key});

  @override
  ConsumerState<RecordLockSettingsPage> createState() =>
      _RecordLockSettingsPageState();
}

class _RecordLockSettingsPageState
    extends ConsumerState<RecordLockSettingsPage> {
  final _messageController = TextEditingController();

  bool _isLoading = false;
  bool _isSaving = false;

  bool _globalLockEnabled = false;
  bool _allowAdminOverride = true;
  TimeOfDay? _cutoffTime;

  RecordLockConfig? _loadedConfig;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadConfig);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    final session = ref.read(sessionProvider);
    final activeDepartment = session.activeDepartment;

    if (activeDepartment == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ref.read(recordLockRepositoryProvider);
      final config = await repository.getConfig(activeDepartment.id);

      if (!mounted) {
        return;
      }

      setState(() {
        _loadedConfig = config;
        _globalLockEnabled = config.globalLockEnabled;
        _allowAdminOverride = config.allowAdminOverride;
        _cutoffTime = _parseTimeOfDay(config.cutoffTime);
        _messageController.text = config.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickCutoffTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _cutoffTime ?? TimeOfDay.now(),
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _cutoffTime = selected;
    });
  }

  Future<void> _saveConfig() async {
    final session = ref.read(sessionProvider);
    final activeDepartment = session.activeDepartment;

    if (!session.isAdmin) {
      _showMessage('Solo el administrador puede modificar esta configuración.');
      return;
    }

    if (activeDepartment == null) {
      _showMessage('No hay departamento activo.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(recordLockRepositoryProvider);

      final config = RecordLockConfig(
        departmentId: activeDepartment.id,
        globalLockEnabled: _globalLockEnabled,
        cutoffTime: _cutoffTime == null ? null : _formatTimeValue(_cutoffTime!),
        allowAdminOverride: _allowAdminOverride,
        message: _messageController.text.trim().isEmpty
            ? 'Los registros están bloqueados por administración.'
            : _messageController.text.trim(),
        updatedAt: DateTime.now(),
        syncStatus: 'pendiente',
      );

      await repository.saveConfig(config);

      if (!mounted) {
        return;
      }

      setState(() {
        _loadedConfig = config.copyWith(
          updatedAt: DateTime.now(),
          syncStatus: 'pendiente',
        );
      });

      _showMessage('Configuración de bloqueo guardada.');
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

  void _clearCutoffTime() {
    setState(() {
      _cutoffTime = null;
    });
  }

  TimeOfDay? _parseTimeOfDay(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final parts = value.split(':');

    if (parts.length != 2) {
      return null;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) {
      return null;
    }

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTimeValue(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String _displayTime(TimeOfDay? time) {
    if (time == null) {
      return 'Sin horario límite';
    }

    return _formatTimeValue(time);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final activeDepartment = session.activeDepartment;

    if (!session.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bloqueo de registros')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Solo el administrador puede acceder a esta configuración.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (activeDepartment == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bloqueo de registros')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('No hay departamento activo.'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bloqueo de registros')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Departamento: ${activeDepartment.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Bloquear registros globalmente'),
                  subtitle: const Text(
                    'Si está activo, los usuarios normales no podrán crear ni editar registros.',
                  ),
                  value: _globalLockEnabled,
                  onChanged: (value) {
                    setState(() {
                      _globalLockEnabled = value;
                    });
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('Horario límite de registro'),
                  subtitle: Text(_displayTime(_cutoffTime)),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      TextButton(
                        onPressed: _clearCutoffTime,
                        child: const Text('Quitar'),
                      ),
                      FilledButton(
                        onPressed: _pickCutoffTime,
                        child: const Text('Elegir'),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Permitir excepción para admin'),
                  subtitle: const Text(
                    'Si está activo, el administrador podrá crear y editar aunque exista bloqueo.',
                  ),
                  value: _allowAdminOverride,
                  onChanged: (value) {
                    setState(() {
                      _allowAdminOverride = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _messageController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Mensaje para el usuario',
                    hintText:
                        'Ejemplo: Los registros fueron cerrados por administración.',
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.sync),
                    title: const Text('Estado de sincronización'),
                    subtitle: Text(
                      _loadedConfig == null
                          ? 'Sin configuración guardada'
                          : 'Estado: ${_loadedConfig!.syncStatus}\n'
                                'Actualizado: ${_loadedConfig!.updatedAt}',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _isSaving ? null : _saveConfig,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Guardar configuración'),
                ),
              ],
            ),
    );
  }
}
