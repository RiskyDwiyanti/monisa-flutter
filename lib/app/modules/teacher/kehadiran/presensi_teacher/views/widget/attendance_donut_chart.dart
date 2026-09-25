import 'dart:math';

import 'package:flutter/material.dart';

class AttendanceDonutChart extends StatelessWidget {
  final double percentage; // 0..1 = porsi hadir
  final Color hadirColor;
  final Color tidakHadirColor;
  final double size;

  const AttendanceDonutChart({
    super.key,
    required this.percentage,
    required this.hadirColor,
    required this.tidakHadirColor,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DonutPainter(
          percentage: percentage,
          hadirColor: hadirColor,
          tidakHadirColor: tidakHadirColor,
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double percentage;
  final Color hadirColor;
  final Color tidakHadirColor;

  _DonutPainter({
    required this.percentage,
    required this.hadirColor,
    required this.tidakHadirColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.22;
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final basePaint = Paint()
      ..color = tidakHadirColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, 0, 2 * pi, false, basePaint);

    final hadirPaint = Paint()
      ..color = hadirColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, -pi / 2, 2 * pi * percentage.clamp(0, 1), false, hadirPaint);
  }
  
  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.hadirColor != hadirColor ||
        oldDelegate.tidakHadirColor != tidakHadirColor;
  }
}