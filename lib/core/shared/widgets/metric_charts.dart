import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../features/analytics/application/business_metrics.dart';
import '../../helpers/app_formatters.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import 'empty_state_widget.dart';
import 'glass_card.dart';

class LineMetricChart extends StatelessWidget {
  const LineMetricChart({
    required this.title,
    required this.points,
    super.key,
    this.icon = Icons.show_chart_rounded,
  });

  final String title;
  final List<ChartPoint> points;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final hasData = points.any((ChartPoint point) => point.value != 0);
    return _ChartShell(
      title: title,
      icon: icon,
      child:
          hasData
              ? SizedBox(
                height: 180,
                child: CustomPaint(
                  painter: _LineChartPainter(
                    points: points,
                    color: Theme.of(context).colorScheme.primary,
                    gridColor: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.18),
                  ),
                  child: const SizedBox.expand(),
                ),
              )
              : const EmptyStateWidget(
                title: 'No Data',
                message: 'Values will appear after entries are added.',
                icon: Icons.query_stats_outlined,
              ),
    );
  }
}

class BarMetricChart extends StatelessWidget {
  const BarMetricChart({
    required this.title,
    required this.items,
    super.key,
    this.icon = Icons.bar_chart_rounded,
    this.currency = true,
  });

  final String title;
  final List<CategoryMetric> items;
  final IconData icon;
  final bool currency;

  @override
  Widget build(BuildContext context) {
    final visible =
        items.where((CategoryMetric item) => item.value > 0).toList();
    if (visible.isEmpty) {
      return _ChartShell(
        title: title,
        icon: icon,
        child: const EmptyStateWidget(title: 'No Data'),
      );
    }
    final maxValue =
        visible
            .map((CategoryMetric item) => item.value)
            .reduce(math.max)
            .toDouble();
    return _ChartShell(
      title: title,
      icon: icon,
      child: Column(
        children: visible
            .map((CategoryMetric item) {
              final percent = maxValue == 0 ? 0.0 : item.value / maxValue;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            item.label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          currency
                              ? AppFormatters.currency(item.value)
                              : item.value.toInt().toString(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: LinearProgressIndicator(
                        value: percent.clamp(0, 1),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}

class DonutMetricChart extends StatelessWidget {
  const DonutMetricChart({
    required this.title,
    required this.items,
    super.key,
    this.icon = Icons.donut_large_rounded,
    this.currency = false,
  });

  final String title;
  final List<CategoryMetric> items;
  final IconData icon;
  final bool currency;

  @override
  Widget build(BuildContext context) {
    final visible =
        items.where((CategoryMetric item) => item.value > 0).toList();
    if (visible.isEmpty) {
      return _ChartShell(
        title: title,
        icon: icon,
        child: const EmptyStateWidget(title: 'No Data'),
      );
    }
    final colors = <Color>[
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.error,
      Theme.of(context).colorScheme.inversePrimary,
    ];
    return _ChartShell(
      title: title,
      icon: icon,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 132,
            height: 132,
            child: CustomPaint(
              painter: _DonutChartPainter(items: visible, colors: colors),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              children: List<Widget>.generate(visible.length, (int index) {
                final item = visible[index];
                final color = colors[index % colors.length];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: const SizedBox(width: 10, height: 10),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          item.label,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        currency
                            ? AppFormatters.currency(item.value)
                            : item.value.toInt().toString(),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartShell extends StatelessWidget {
  const _ChartShell({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({
    required this.points,
    required this.color,
    required this.gridColor,
  });

  final List<ChartPoint> points;
  final Color color;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final maxValue =
        points
            .map((ChartPoint point) => point.value.abs())
            .fold<num>(0, math.max)
            .toDouble();
    final chartHeight = size.height - 28;
    final gridPaint =
        Paint()
          ..color = gridColor
          ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = chartHeight * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    if (points.length < 2 || maxValue == 0) {
      return;
    }
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final normalized = points[i].value / maxValue;
      final y = chartHeight - (normalized * chartHeight);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.color != color ||
        oldDelegate.gridColor != gridColor;
  }
}

class _DonutChartPainter extends CustomPainter {
  const _DonutChartPainter({required this.items, required this.colors});

  final List<CategoryMetric> items;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final total = items.fold<num>(0, (num sum, item) => sum + item.value);
    if (total <= 0) {
      return;
    }
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    for (var i = 0; i < items.length; i++) {
      final sweep = (items[i].value / total) * math.pi * 2;
      canvas.drawArc(
        rect.deflate(8),
        start,
        sweep,
        false,
        Paint()
          ..color = colors[i % colors.length]
          ..strokeWidth = 22
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.items != items || oldDelegate.colors != colors;
  }
}
