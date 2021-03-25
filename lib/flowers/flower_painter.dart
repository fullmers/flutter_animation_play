import 'dart:ui';

import 'package:flutter/material.dart';

/// [FlowerPainter] animates some flowers
class FlowerPainter extends CustomPainter {
  FlowerPainter({
    required this.progress,
  });

  /// a value between 0.0 and 1.0 indicating the total progress of the animation. It comes from
  /// the animation controller in the calling widget
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;

    paint.strokeWidth = 4;
    paint.color = Colors.pink[300]!;
    canvas.drawCircle(Offset(300, 300), 100, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
