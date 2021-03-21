import 'dart:ui';

import 'package:flutter/material.dart';

import 'FibonacciSquare.dart';

class FibonacciPainter extends CustomPainter {
  FibonacciPainter({
    required this.spiralPath,
    required this.progress,
    required this.squares,
    this.showRects = false,
  });

  final List<FibonacciSquare> squares;
  final Path spiralPath;
  final double progress;
  final bool showRects;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.purple;

    if (showRects) {
      for (FibonacciSquare fibRect in squares) {
        print(fibRect);
        canvas.drawRect(fibRect.rect, paint);
      }
    }

    List<PathMetric> pathMetrics = spiralPath.computeMetrics().toList(growable: true);
    PathMetric lastPathMetric = pathMetrics.removeLast();
    Path extractPath = lastPathMetric.extractPath(
      0.0,
      lastPathMetric.length * progress,
    );
    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
