import 'dart:math';
import 'package:flutter/material.dart';

class TimerPainter extends CustomPainter {
  final double percentage;
  final Color taskColor;
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

    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 20.0 
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    Paint progressPaint = Paint()
      ..color = taskColor
      ..strokeWidth = 20.0 
      ..strokeCap = StrokeCap.round 
      ..style = PaintingStyle.stroke;

    double sweepAngle = 2 * pi * percentage;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, 
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant TimerPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
           oldDelegate.taskColor != taskColor;
  }
}