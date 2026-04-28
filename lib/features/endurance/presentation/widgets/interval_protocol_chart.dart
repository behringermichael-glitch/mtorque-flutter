import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mtorque_flutter/core/theme/app_theme.dart';

import '../../domain/models/indoor_interval_phase.dart';

class IntervalProtocolChart extends StatelessWidget {
  const IntervalProtocolChart({
    super.key,
    required this.phases,
    required this.axisLabel,
    required this.axisUnit,
    required this.elapsedMs,
    required this.selectedIndex,
    required this.showAddButton,
    this.onAddPhase,
    this.onPhaseSelected,
  });

  final List<IndoorIntervalPhase> phases;
  final String axisLabel;
  final String axisUnit;
  final int elapsedMs;
  final int selectedIndex;
  final bool showAddButton;
  final VoidCallback? onAddPhase;
  final ValueChanged<int>? onPhaseSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: 2.05,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              final hit = _ChartHitTest.resolve(
                size: Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                ),
                localPosition: details.localPosition,
                phases: phases,
                showAddButton: showAddButton,
              );

              switch (hit.type) {
                case _ChartHitType.add:
                  onAddPhase?.call();
                  break;
                case _ChartHitType.phase:
                  final index = hit.phaseIndex;
                  if (index != null) {
                    onPhaseSelected?.call(index);
                  }
                  break;
                case _ChartHitType.none:
                  break;
              }
            },
            child: CustomPaint(
              painter: _IntervalProtocolChartPainter(
                theme: theme,
                phases: phases,
                axisLabel: axisLabel,
                axisUnit: axisUnit,
                elapsedMs: elapsedMs,
                selectedIndex: selectedIndex,
                showAddButton: showAddButton,
              ),
            ),
          );
        },
      ),
    );
  }
}

enum _ChartHitType {
  none,
  add,
  phase,
}

class _ChartHit {
  const _ChartHit({
    required this.type,
    this.phaseIndex,
  });

  final _ChartHitType type;
  final int? phaseIndex;
}

abstract final class _ChartHitTest {
  static _ChartHit resolve({
    required Size size,
    required Offset localPosition,
    required List<IndoorIntervalPhase> phases,
    required bool showAddButton,
  }) {
    final layout = _ChartLayout.fromSize(
      size,
      hasPhases: phases.isNotEmpty,
      showAddButton: showAddButton,
    );

    if (showAddButton && layout.plusRect.contains(localPosition)) {
      return const _ChartHit(type: _ChartHitType.add);
    }

    if (phases.isEmpty) {
      return const _ChartHit(type: _ChartHitType.none);
    }

    final totalSec = _IntervalProtocolChartPainter._totalSec(phases);
    var accumulatedSec = 0;

    for (var i = 0; i < phases.length; i++) {
      final phase = phases[i];
      final durSec = math.max(1, phase.durSec);

      final left = layout.plot.left +
          (accumulatedSec / totalSec) * layout.barsWidth;
      final right = layout.plot.left +
          ((accumulatedSec + durSec) / totalSec) * layout.barsWidth;

      final rect = Rect.fromLTRB(
        left,
        layout.plot.top,
        right,
        layout.plot.bottom,
      );

      if (rect.contains(localPosition)) {
        return _ChartHit(
          type: _ChartHitType.phase,
          phaseIndex: i,
        );
      }

      accumulatedSec += durSec;
    }

    return const _ChartHit(type: _ChartHitType.none);
  }
}

class _IntervalProtocolChartPainter extends CustomPainter {
  const _IntervalProtocolChartPainter({
    required this.theme,
    required this.phases,
    required this.axisLabel,
    required this.axisUnit,
    required this.elapsedMs,
    required this.selectedIndex,
    required this.showAddButton,
  });

  final ThemeData theme;
  final List<IndoorIntervalPhase> phases;
  final String axisLabel;
  final String axisUnit;
  final int elapsedMs;
  final int selectedIndex;
  final bool showAddButton;

  @override
  void paint(Canvas canvas, Size size) {
    final layout = _ChartLayout.fromSize(
      size,
      hasPhases: phases.isNotEmpty,
      showAddButton: showAddButton,
    );

    if (layout.plot.width <= 20 || layout.plot.height <= 20) {
      return;
    }

    final colorScheme = theme.colorScheme;

    final axisPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..color = colorScheme.onSurfaceVariant.withValues(alpha: 0.70);

    final gridPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = colorScheme.onSurfaceVariant.withValues(alpha: 0.35);

    final barPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    final selectedPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = colorScheme.onSurface;

    final plusPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = colorScheme.onSurface.withValues(alpha: 0.85);

    final cursorPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = colorScheme.primary.withValues(alpha: 0.85);

    _drawGrid(canvas, layout.plot, gridPaint);
    _drawAxes(canvas, layout.plot, axisPaint);
    _drawAxisLabels(canvas, layout, colorScheme);
    _drawBars(canvas, layout, barPaint, selectedPaint, colorScheme);
    _drawPlus(canvas, layout, plusPaint);
    _drawCursor(canvas, layout, cursorPaint);
  }

  void _drawGrid(Canvas canvas, Rect plot, Paint paint) {
    final yTop = plot.top;
    final yMid = plot.top + plot.height * 0.5;
    final yBottom = plot.bottom;

    _drawDashedLine(
      canvas,
      Offset(plot.left, yTop),
      Offset(plot.right, yTop),
      paint,
    );
    _drawDashedLine(
      canvas,
      Offset(plot.left, yMid),
      Offset(plot.right, yMid),
      paint,
    );
    _drawDashedLine(
      canvas,
      Offset(plot.left, yBottom),
      Offset(plot.right, yBottom),
      paint,
    );
  }

  void _drawAxes(Canvas canvas, Rect plot, Paint paint) {
    canvas.drawLine(
      Offset(plot.left, plot.top),
      Offset(plot.left, plot.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(plot.left, plot.bottom),
      Offset(plot.right, plot.bottom),
      paint,
    );
  }

  void _drawAxisLabels(
      Canvas canvas,
      _ChartLayout layout,
      ColorScheme colorScheme,
      ) {
    final maxIntensity = _maxIntensity(phases);

    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w600,
    ) ??
        TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );

    final tickStyle = theme.textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    ) ??
        TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 12,
        );

    _drawText(
      canvas,
      text: _formatIntensity(maxIntensity),
      offset: Offset(layout.plot.left - 8, layout.plot.top),
      style: tickStyle,
      align: TextAlign.right,
      anchor: _TextAnchor.middleRight,
    );

    _drawText(
      canvas,
      text: _formatIntensity(maxIntensity * 0.5),
      offset: Offset(layout.plot.left - 8, layout.plot.center.dy),
      style: tickStyle,
      align: TextAlign.right,
      anchor: _TextAnchor.middleRight,
    );

    _drawText(
      canvas,
      text: '0.0',
      offset: Offset(layout.plot.left - 8, layout.plot.bottom),
      style: tickStyle,
      align: TextAlign.right,
      anchor: _TextAnchor.middleRight,
    );

    final axisTitle = axisUnit.trim().isEmpty
        ? axisLabel
        : '$axisLabel [$axisUnit]';

    canvas.save();
    canvas.translate(14, layout.plot.center.dy);
    canvas.rotate(-math.pi / 2);
    _drawText(
      canvas,
      text: axisTitle,
      offset: Offset.zero,
      style: textStyle,
      align: TextAlign.center,
      anchor: _TextAnchor.center,
    );
    canvas.restore();

    final totalSec = phases.isEmpty ? 10 * 60 : _totalSec(phases);
    final midSec = totalSec ~/ 2;

    _drawText(
      canvas,
      text: _formatDuration(0),
      offset: Offset(layout.plot.left, layout.plot.bottom + 22),
      style: tickStyle,
      align: TextAlign.center,
      anchor: _TextAnchor.center,
    );

    _drawText(
      canvas,
      text: _formatDuration(midSec),
      offset: Offset(
        layout.plot.left + layout.barsWidth * 0.5,
        layout.plot.bottom + 22,
      ),
      style: tickStyle,
      align: TextAlign.center,
      anchor: _TextAnchor.center,
    );

    _drawText(
      canvas,
      text: _formatDuration(totalSec),
      offset: Offset(
        layout.plot.left + layout.barsWidth,
        layout.plot.bottom + 22,
      ),
      style: tickStyle,
      align: TextAlign.center,
      anchor: _TextAnchor.center,
    );
  }

  void _drawBars(
      Canvas canvas,
      _ChartLayout layout,
      Paint barPaint,
      Paint selectedPaint,
      ColorScheme colorScheme,
      ) {
    if (phases.isEmpty) {
      return;
    }

    final totalSec = _totalSec(phases);
    final maxIntensity = _maxIntensity(phases);
    var accumulatedSec = 0;

    for (var i = 0; i < phases.length; i++) {
      final phase = phases[i];
      final durSec = math.max(1, phase.durSec);

      final left = layout.plot.left +
          (accumulatedSec / totalSec) * layout.barsWidth;
      final right = layout.plot.left +
          ((accumulatedSec + durSec) / totalSec) * layout.barsWidth;

      final fraction = (phase.intensity / maxIntensity).clamp(0.0, 1.0);
      final top = layout.plot.bottom - fraction * layout.plot.height;

      final rect = Rect.fromLTRB(
        left,
        top,
        right,
        layout.plot.bottom,
      );

      barPaint.color = _barColor(
        colorScheme: colorScheme,
        fraction: fraction,
      );

      canvas.drawRect(rect, barPaint);

      if (i == selectedIndex) {
        canvas.drawRect(rect, selectedPaint);
      }

      accumulatedSec += durSec;
    }
  }

  void _drawPlus(
      Canvas canvas,
      _ChartLayout layout,
      Paint paint,
      ) {
    if (!showAddButton) {
      return;
    }

    final center = layout.plusRect.center;
    final half = math.min(layout.plusRect.width, layout.plusRect.height) * 0.30;

    canvas.drawLine(
      Offset(center.dx - half, center.dy),
      Offset(center.dx + half, center.dy),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx, center.dy - half),
      Offset(center.dx, center.dy + half),
      paint,
    );
  }

  void _drawCursor(
      Canvas canvas,
      _ChartLayout layout,
      Paint paint,
      ) {
    if (elapsedMs <= 0 || phases.isEmpty) {
      return;
    }

    final totalMs = _totalSec(phases) * 1000;
    final fraction = (elapsedMs / totalMs).clamp(0.0, 1.0);
    final x = layout.plot.left + fraction * layout.barsWidth;

    _drawDashedLine(
      canvas,
      Offset(x, layout.plot.top),
      Offset(x, layout.plot.bottom),
      paint,
    );
  }

  static Color _barColor({
    required ColorScheme colorScheme,
    required double fraction,
  }) {
    return AppTheme.enduranceIntensityColor(fraction);
  }

  static void _drawDashedLine(
      Canvas canvas,
      Offset start,
      Offset end,
      Paint paint,
      ) {
    const dashLength = 6.0;
    const gapLength = 4.0;

    final delta = end - start;
    final distance = delta.distance;

    if (distance <= 0) {
      return;
    }

    final direction = delta / distance;
    var current = 0.0;

    while (current < distance) {
      final dashEnd = math.min(current + dashLength, distance);
      canvas.drawLine(
        start + direction * current,
        start + direction * dashEnd,
        paint,
      );
      current += dashLength + gapLength;
    }
  }

  static double _maxIntensity(List<IndoorIntervalPhase> phases) {
    if (phases.isEmpty) {
      return 1.0;
    }

    var maxValue = 1.0;
    for (final phase in phases) {
      if (phase.intensity > maxValue) {
        maxValue = phase.intensity;
      }
    }
    return maxValue;
  }

  static int _totalSec(List<IndoorIntervalPhase> phases) {
    var total = 0;
    for (final phase in phases) {
      total += math.max(1, phase.durSec);
    }
    return math.max(1, total);
  }

  static String _formatIntensity(double value) {
    if (value.abs() >= 100) {
      return value.round().toString();
    }
    return value.toStringAsFixed(1);
  }

  static String _formatDuration(int totalSec) {
    final hours = totalSec ~/ 3600;
    final minutes = (totalSec % 3600) ~/ 60;
    final seconds = totalSec % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static void _drawText(
      Canvas canvas, {
        required String text,
        required Offset offset,
        required TextStyle style,
        required TextAlign align,
        required _TextAnchor anchor,
      }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      textAlign: align,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    final dx = switch (anchor) {
      _TextAnchor.center => offset.dx - painter.width / 2,
      _TextAnchor.middleRight => offset.dx - painter.width,
    };

    final dy = switch (anchor) {
      _TextAnchor.center => offset.dy - painter.height / 2,
      _TextAnchor.middleRight => offset.dy - painter.height / 2,
    };

    painter.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant _IntervalProtocolChartPainter oldDelegate) {
    return oldDelegate.theme != theme ||
        oldDelegate.phases != phases ||
        oldDelegate.axisLabel != axisLabel ||
        oldDelegate.axisUnit != axisUnit ||
        oldDelegate.elapsedMs != elapsedMs ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.showAddButton != showAddButton;
  }
}

enum _TextAnchor {
  center,
  middleRight,
}

class _ChartLayout {
  const _ChartLayout({
    required this.plot,
    required this.plusRect,
    required this.barsWidth,
  });

  final Rect plot;
  final Rect plusRect;
  final double barsWidth;

  static _ChartLayout fromSize(
      Size size, {
        required bool hasPhases,
        required bool showAddButton,
      }) {
    const padLeft = 58.0;
    const padRight = 14.0;
    const padTop = 16.0;
    const padBottom = 38.0;

    final plot = Rect.fromLTRB(
      padLeft,
      padTop,
      math.max(padLeft + 1, size.width - padRight),
      math.max(padTop + 1, size.height - padBottom),
    );

    final plusWidth = hasPhases && showAddButton
        ? math.max(44.0, plot.width * 0.12)
        : 0.0;

    final barsWidth = math.max(1.0, plot.width - plusWidth);

    final plusRect = hasPhases && showAddButton
        ? Rect.fromCenter(
      center: Offset(
        plot.left + barsWidth + plusWidth * 0.5,
        plot.center.dy,
      ),
      width: 52,
      height: 52,
    )
        : Rect.fromCenter(
      center: plot.center,
      width: 52,
      height: 52,
    );

    return _ChartLayout(
      plot: plot,
      plusRect: plusRect,
      barsWidth: barsWidth,
    );
  }
}