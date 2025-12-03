import 'dart:math';
import 'package:flutter/material.dart';

class TimerPainter extends CustomPainter {
  // The progress (0.0 to 1.0)
  final double percentage;
  // The color of the progress arc (e.g., Red for work, Green for break)
  final Color taskColor;
  // The faint background circle color
  final Color backgroundColor;

  TimerPainter({
    required this.percentage,
    required this.taskColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    // 1. Draw Background Circle (the track)
    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 20.0 // Thickness of the ring
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // 2. Draw Progress Arc
    Paint progressPaint = Paint()
      ..color = taskColor
      ..strokeWidth = 20.0 // Thickness of the progress arc
      ..strokeCap = StrokeCap.round // Rounded ends look nicer
      ..style = PaintingStyle.stroke;

    // Calculate the sweep angle based on percentage
    double sweepAngle = 2 * pi * percentage;

    // Draw the arc starting from the top (-pi/2)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start at top center
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant TimerPainter oldDelegate) {
    // Repaint if percentage or colors change
    return oldDelegate.percentage != percentage ||
           oldDelegate.taskColor != taskColor;
  }
}