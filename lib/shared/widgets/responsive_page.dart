import 'package:flutter/material.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({
    super.key,
    required this.children,
    this.maxWidth = 1120,
    this.padding = const EdgeInsets.all(24),
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.refreshCallback,
  });

  final List<Widget> children;
  final double maxWidth;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment crossAxisAlignment;
  final Future<void> Function()? refreshCallback;

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: padding,
          children: [
            Column(crossAxisAlignment: crossAxisAlignment, children: children),
          ],
        ),
      ),
    );

    if (refreshCallback == null) {
      return content;
    }

    return RefreshIndicator(onRefresh: refreshCallback!, child: content);
  }
}

class ResponsiveSection extends StatelessWidget {
  const ResponsiveSection({
    super.key,
    required this.children,
    this.spacing = 16,
    this.minItemWidth = 260,
    this.maxColumns,
  });

  final List<Widget> children;
  final double spacing;
  final double minItemWidth;
  final int? maxColumns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final calculatedColumns = (width / minItemWidth).floor().clamp(1, 6);
        final columns = maxColumns == null
            ? calculatedColumns
            : calculatedColumns.clamp(1, maxColumns!);
        final itemWidth = (width - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: colorScheme.onPrimaryContainer),
            ),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.headlineSmall),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 16), trailing!],
      ],
    );
  }
}
