import 'dart:ui';

import 'package:flutter/material.dart';

class FibonacciPainter extends CustomPainter {
  FibonacciPainter({
    required this.spiralPath,
    required this.progress,
    required this.rects,
    this.showRects = false,
  });

  final List<FibRect> rects;
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
      for (FibRect fibRect in rects) {
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

class FibRect {
  const FibRect({
    required this.fibNumber,
    required this.rect,
    required this.direction,
  });

  final Rect rect;
  final Direction direction;
  final int fibNumber;

  @override
  String toString() {
    return 'FibRect from fibNum: $fibNumber\n'
        'center: ${rect.center.dx} ${rect.center.dy}';
  }
}

enum Direction { BOTTOM, RIGHT, TOP, LEFT }
