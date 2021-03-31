import 'package:flutter/material.dart';

class Painter extends CustomPainter {
  const Painter({
    required this.circleColor,
    required this.circleCenter,
  });

  final Color circleColor;
  final Offset circleCenter;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = circleColor;
    canvas.drawCircle(circleCenter, 80, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
