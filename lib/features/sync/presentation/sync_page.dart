import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_error.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../../../shared/widgets/status_message.dart';
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
  AppMessageType _messageType = AppMessageType.info;
  SyncDashboard? _dashboard;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadDashboard);
  }

  Future<void> _loadDashboard() async {
    if (!mounted) {
      return;
    }

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
        _message = userSafeErrorMessage(
          error,
          fallback: 'No se pudo cargar el estado de sincronización.',
        );
        _messageType = AppMessageType.error;
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
    if (_isSyncing) {
      return;
    }

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
            '${result.message}\nSubidos: ${result.uploaded} · Descargados: ${result.downloaded} · Errores: ${result.failed}';
        _messageType = result.failed == 0
            ? AppMessageType.success
            : AppMessageType.warning;
      });

      await _loadDashboard();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _message = userSafeErrorMessage(
          error,
          fallback:
              'No se pudo completar la sincronización. Se reintentará luego.',
        );
        _messageType = AppMessageType.error;
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

  Future<void> _setMockFailure(bool value) async {
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
      body: ResponsivePage(
        refreshCallback: _loadDashboard,
        children: [
          PageHeader(
            icon: Icons.sync_outlined,
            title: 'Estado offline-first',
            subtitle:
                'La app guarda primero en SQLite. Cuando hay conexión, sube pendientes y descarga cambios del servidor.',
            trailing: FilledButton.icon(
              onPressed: _isSyncing ? null : _syncNow,
              icon: _isSyncing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
              label: Text(_isSyncing ? 'Sincronizando...' : 'Sincronizar'),
            ),
          ),
          if (_message != null) ...[
            const SizedBox(height: 16),
            AppStatusMessage(message: _message!, type: _messageType),
          ],
          const SizedBox(height: 24),
          if (_isLoading && dashboard == null)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (dashboard == null)
            AppEmptyState(
              icon: Icons.cloud_off_outlined,
              title: 'Sin estado disponible',
              message:
                  'Actualiza para volver a consultar la cola local y el último intento de sincronización.',
              action: OutlinedButton.icon(
                onPressed: _loadDashboard,
                icon: const Icon(Icons.refresh),
                label: const Text('Actualizar'),
              ),
            )
          else ...[
            ResponsiveSection(
              maxColumns: 3,
              children: [
                MetricCard(
                  icon: Icons.edit_note,
                  label: 'Registros pendientes',
                  value: dashboard.pendingRecords.toString(),
                  emphasize: dashboard.pendingRecords > 0,
                ),
                MetricCard(
                  icon: Icons.error_outline,
                  label: 'Registros con error',
                  value: dashboard.errorRecords.toString(),
                  emphasize: dashboard.errorRecords > 0,
                ),
                MetricCard(
                  icon: Icons.inventory_2_outlined,
                  label: 'Catálogos pendientes',
                  value: dashboard.pendingCatalogItems.toString(),
                ),
                MetricCard(
                  icon: Icons.warning_amber_outlined,
                  label: 'Catálogos con error',
                  value: dashboard.errorCatalogItems.toString(),
                  emphasize: dashboard.errorCatalogItems > 0,
                ),
                MetricCard(
                  icon: Icons.queue_outlined,
                  label: 'Cola pendiente',
                  value: dashboard.pendingQueueItems.toString(),
                ),
                MetricCard(
                  icon: Icons.sync_problem_outlined,
                  label: 'Cola con error',
                  value: dashboard.errorQueueItems.toString(),
                  emphasize: dashboard.errorQueueItems > 0,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Última sincronización exitosa'),
                subtitle: Text(_formatDateTime(dashboard.lastSuccessfulSyncAt)),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: SwitchListTile(
                title: const Text('Simular servidor sin respuesta'),
                subtitle: const Text(
                  'Sirve para probar reintentos y cola de errores sin perder datos locales.',
                ),
                value: dashboard.mockServerShouldFail,
                onChanged: _isSyncing ? null : _setMockFailure,
              ),
            ),
          ],
          const SizedBox(height: 24),
          const AppStatusMessage(
            type: AppMessageType.info,
            message:
                'Regla de conflicto: los cambios locales pendientes, sincronizando o con error no se sobrescriben con descargas. Si el dato local ya está sincronizado, se aplica la versión remota más reciente.',
          ),
          const SizedBox(height: 12),
          const AppStatusMessage(
            type: AppMessageType.info,
            message:
                'La cola cubre registros, jornales reales, personas, usuarios, departamentos, cultivos, labores, ubicaciones, comedores y asignaciones usuario-departamento.',
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) {
      return 'Todavía no hay sincronizaciones exitosas.';
    }

    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }
}
