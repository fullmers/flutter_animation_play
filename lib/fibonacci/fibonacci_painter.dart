import 'dart:ui';

import 'package:flutter/material.dart';

import 'fibonacci_square.dart';

/// [FibonacciPainter] animates a Fibonacci spiral and optionally paints the squares framing the spiral.
class FibonacciPainter extends CustomPainter {
  FibonacciPainter({
    required this.spiralPath,
    required this.progress,
    required this.squares,
    this.showSquares = false,
  });

  /// the squares that define the spiral to be animated. visibility can be toggled.
  final List<FibonacciSquare> squares;

  /// the path of the fibonacci spiral
  final Path spiralPath;

  /// a value between 0.0 and 1.0 indicating the total progress of the animation. It comes from
  /// the animation controller in the calling widget and is used to control the path length,
  /// so it looks as though it is growing.
  final double progress;

  /// toggle the visibility of the squares forming the fibonacci spiral
  final bool showSquares;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;

    if (showSquares) {
      paint.strokeWidth = 2;
      paint.color = Colors.pink[200]!;
      for (FibonacciSquare fibRect in squares) {
        canvas.drawRect(fibRect.square, paint);
      }
    }
    paint.strokeWidth = 4;
    paint.color = Colors.pink[300]!;
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
