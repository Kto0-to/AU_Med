import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' show LucideIcons;

import 'package:au_med/src/theme/app_color_tokens.dart';

class DayProgressPainter extends CustomPainter {
  final int taken;
  final int skipped;
  final int missed;
  final int pending;
  final Color takenColor;
  final Color skippedColor;
  final Color missedColor;

  DayProgressPainter({
    required this.taken,
    required this.skipped,
    required this.missed,
    required this.pending,
    required this.takenColor,
    required this.skippedColor,
    required this.missedColor,
  });

  int get _total => taken + skipped + missed + pending;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2 - 6);

    if (_total == 0) {
      final paint = Paint()
        ..color = Colors.grey.withAlpha(50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round;
      canvas.drawCircle(center, radius, paint);
      return;
    }

    const gapAngle = 0.04;
    final totalArc = 2 * math.pi - gapAngle * 4;
    double startAngle = -math.pi / 2;

    void drawArc(int count, Color color) {
      if (count == 0) return;
      final sweep = totalArc * count / _total - gapAngle;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + gapAngle / 2,
        sweep,
        false,
        paint,
      );
      startAngle += gapAngle + sweep + gapAngle;
    }

    drawArc(taken, takenColor);
    drawArc(skipped, skippedColor);
    drawArc(missed, missedColor);
    drawArc(pending, Colors.grey);
  }

  @override
  bool shouldRepaint(covariant DayProgressPainter old) =>
      taken != old.taken ||
      skipped != old.skipped ||
      missed != old.missed ||
      pending != old.pending ||
      takenColor != old.takenColor ||
      skippedColor != old.skippedColor ||
      missedColor != old.missedColor;
}

class ProgressSummary extends StatelessWidget {
  final int taken;
  final int skipped;
  final int missed;
  final int pending;
  final int total;
  final int prnTaken;
  final DateTime date;
  final int streak;

  const ProgressSummary({
    super.key,
    required this.taken,
    required this.skipped,
    required this.missed,
    required this.pending,
    required this.total,
    required this.prnTaken,
    required this.date,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final isToday =
        DateTime(date.year, date.month, date.day) ==
        DateTime(now.year, now.month, now.day);

    String dayLabel(int n) {
      if (n % 10 == 1 && n % 100 != 11) return 'день';
      if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) {
        return 'дня';
      }
      return 'дней';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$taken/$total",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isToday
                        ? 'принято сегодня'
                        : "принято ${DateFormat('d MMM', 'ru').format(date)}",
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  if (prnTaken > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.squareCheck,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'По надобности: $prnTaken',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(
              width: 64,
              height: 64,
              child: CustomPaint(
                painter: DayProgressPainter(
                  taken: taken,
                  skipped: skipped,
                  missed: missed,
                  pending: pending,
                  takenColor: context.appColors.success,
                  skippedColor: context.appColors.warning,
                  missedColor: context.appColors.error,
                ),
                child: Center(
                  child: Text(
                    total > 0 ? '${(taken * 100 ~/ total)}%' : '0%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: total == 0
                          ? Colors.grey
                          : context.appColors.success,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 26),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.flame,
                      color: streak > 0 ? Colors.orange : Colors.grey,
                      size: 38,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$streak',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: streak > 0 ? Colors.orange : Colors.grey,
                      ),
                    ),
                  ],
                ),
                Text(
                  dayLabel(streak),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
