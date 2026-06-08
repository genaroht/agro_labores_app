import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sync_service.dart';

class SyncPage extends ConsumerStatefulWidget {
  const SyncPage({super.key});

  @override
  ConsumerState<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends ConsumerState<SyncPage> {
  bool _isLoading = false;
  bool _isSyncing = false;
  String? _message;
  SyncDashboard? _dashboard;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadDashboard);
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(syncServiceProvider);
      final dashboard = await service.getDashboard();

      if (!mounted) {
        return;
      }

      setState(() {
        _dashboard = dashboard;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _message = 'Error: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _syncNow() async {
    setState(() {
      _isSyncing = true;
      _message = null;
    });

    try {
      final service = ref.read(syncServiceProvider);
      final result = await service.synchronize();

      if (!mounted) {
        return;
      }

      setState(() {
        _message =
            '${result.message}\nSubidos: ${result.uploaded}\nDescargados: ${result.downloaded}\nErrores: ${result.failed}';
      });

      await _loadDashboard();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _message = 'Error de sincronización: $error';
      });

      await _loadDashboard();
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  Future<void> _setMockServerFailure(bool value) async {
    final service = ref.read(syncServiceProvider);

    await service.setMockServerFailure(value);
    await _loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = _dashboard;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronización'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _isLoading ? null : _loadDashboard,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboard,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Estado offline-first',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Los registros se guardan primero en el celular. Luego se suben cuando hay conexión.',
            ),
            const SizedBox(height: 24),
            if (_message != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_message!),
                ),
              ),
            const SizedBox(height: 16),
            if (_isLoading && dashboard == null)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (dashboard != null)
              Card(
                child: Column(
                  children: [
                    _InfoTile(
                      label: 'Registros pendientes',
                      value: dashboard.pendingRecords.toString(),
                    ),
                    const Divider(height: 1),
                    _InfoTile(
                      label: 'Registros con error',
                      value: dashboard.errorRecords.toString(),
                    ),
                    const Divider(height: 1),
                    _InfoTile(
                      label: 'Cola pendiente',
                      value: dashboard.pendingQueueItems.toString(),
                    ),
                    const Divider(height: 1),
                    _InfoTile(
                      label: 'Cola con error',
                      value: dashboard.errorQueueItems.toString(),
                    ),
                    const Divider(height: 1),
                    _InfoTile(
                      label: 'Última sync exitosa',
                      value: dashboard.lastSuccessfulSyncAt?.toString() ?? '-',
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isSyncing ? null : _syncNow,
              icon: _isSyncing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
              label: const Text('Sincronizar ahora'),
            ),
            const SizedBox(height: 24),
            if (dashboard != null)
              Card(
                child: SwitchListTile(
                  title: const Text('Simular error de servidor'),
                  subtitle: const Text(
                    'Úsalo para probar que los registros queden en error.',
                  ),
                  value: dashboard.mockServerShouldFail,
                  onChanged: _setMockServerFailure,
                ),
              ),
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Descargas preparadas: usuarios, roles/permisos, departamentos, operarios, labores, cultivos, ubicaciones, formularios y bloqueos.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
