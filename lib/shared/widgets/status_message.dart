import 'package:flutter/material.dart';

enum AppMessageType { info, success, warning, error }

class AppStatusMessage extends StatelessWidget {
  const AppStatusMessage({
    super.key,
    required this.message,
    this.type = AppMessageType.info,
  });

  final String message;
  final AppMessageType type;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = switch (type) {
      AppMessageType.success => (
        background: colorScheme.primaryContainer,
        foreground: colorScheme.onPrimaryContainer,
        icon: Icons.check_circle_outline,
      ),
      AppMessageType.warning => (
        background: colorScheme.tertiaryContainer,
        foreground: colorScheme.onTertiaryContainer,
        icon: Icons.warning_amber_outlined,
      ),
      AppMessageType.error => (
        background: colorScheme.errorContainer,
        foreground: colorScheme.onErrorContainer,
        icon: Icons.error_outline,
      ),
      AppMessageType.info => (
        background: colorScheme.surfaceContainerHighest,
        foreground: colorScheme.onSurfaceVariant,
        icon: Icons.info_outline,
      ),
    };

    return Card(
      color: colors.background,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(colors.icon, color: colors.foreground),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: TextStyle(color: colors.foreground)),
            ),
          ],
        ),
      ),
    );
  }
}

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
