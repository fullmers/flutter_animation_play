import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// [WavePainter] paints some background waves
class WavePainter extends CustomPainter {
  WavePainter({
    required this.waveColor,
  });

  final Color waveColor;

  final _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    _drawWaves(canvas: canvas, size: size);
  }

  void _drawWaves({required Canvas canvas, required Size size}) {
    int numCols = 10;
    final width = size.width;
    final colWidth = .8 * width / numCols;
    numCols = numCols + 5;
    int numRows = (size.height / colWidth).ceil() * 3 + 1;
    final r0 = 2 * colWidth / 32;
    final r1 = 6 * colWidth / 32;
    final r2 = 10 * colWidth / 32;
    final r3 = 14 * colWidth / 32;
    final r4 = 35 * colWidth / 64;
    final refStartAngle = -pi / 6;
    final refSweepAngle = -2 * pi / 3;

    double dy;
    double dx;
    for (int j = 0; j < numRows; j++) {
      for (int i = 0; i < numCols + 1; i++) {
        if (j % 2 == 0) {
          dx = i * colWidth + colWidth / 2;
        } else {
          dx = i * colWidth;
        }
        dy = colWidth * j / 3;

        _paint.color = waveColor;
        _paint.style = PaintingStyle.stroke;
        _paint.strokeWidth = 1;

        canvas.drawArc(Rect.fromCircle(center: Offset(dx, dy), radius: r0), refStartAngle + 3 * pi / 16,
            refSweepAngle - 3 * pi / 8, false, _paint);
        canvas.drawArc(
            Rect.fromCircle(center: Offset(dx, dy), radius: r1), refStartAngle, refSweepAngle, false, _paint);
        canvas.drawArc(Rect.fromCircle(center: Offset(dx, dy), radius: r2), refStartAngle - pi / 128,
            refSweepAngle + pi / 64, false, _paint);
        canvas.drawArc(Rect.fromCircle(center: Offset(dx, dy), radius: r3), refStartAngle + pi / 64,
            refSweepAngle - pi / 32, false, _paint);
        canvas.drawArc(Rect.fromCircle(center: Offset(dx, dy), radius: r4), refStartAngle + pi / 32,
            refSweepAngle - pi / 16, false, _paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
