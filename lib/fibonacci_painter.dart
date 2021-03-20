import 'package:flutter/material.dart';

class FibPainter extends CustomPainter {
  FibPainter({
    required this.rects,
    required this.spiralPath,
  });

  final List<FibRect> rects;
  final Path spiralPath;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.purple;

    for (FibRect fibRect in rects) {
      print(fibRect);
      canvas.drawRect(fibRect.rect, paint);
    }
    canvas.drawPath(spiralPath, paint);
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
