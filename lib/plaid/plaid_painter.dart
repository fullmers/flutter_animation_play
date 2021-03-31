import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class PlaidPainter extends CustomPainter {
  PlaidPainter({
    required this.squareGrid,
  });

  final List<List<Offset>> squareGrid;

  final Random _random = Random();
  final Paint _paint = Paint();
  Canvas? _canvas;
  double r = 0;
  final numColors = palette.length;
  final strokeScale = 30;
  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;

    final width = size.width;
    final numCols = 5;
    final side = width / numCols;
    r = side / 2;

    // square grid:
    for (int i = 0; i < squareGrid.length; i++) {
      _paint.style = PaintingStyle.stroke;
      _paint.color = Colors.orange.withOpacity(.5);
      _paint.strokeWidth = strokeScale * _random.nextDouble();
      _canvas!.drawLine(
        squareGrid[i][0],
        squareGrid[i][squareGrid[i].length - 1],
        _paint,
      );
      _paint.color = Colors.green.withOpacity(.5);
      _paint.strokeWidth = strokeScale * _random.nextDouble();
      final randomOffset = Offset(0, r * _random.nextDouble());
      _canvas!.drawLine(
        squareGrid[i][0] + randomOffset,
        squareGrid[i][squareGrid[i].length - 1] + randomOffset,
        _paint,
      );
    }
    for (int j = 0; j < squareGrid[0].length; j++) {
      _paint.color = Colors.blue.withOpacity(.5);
      _paint.strokeWidth = strokeScale * _random.nextDouble();
      final startPt = squareGrid[0][j] + Offset(0, -r);
      final endPt = squareGrid[squareGrid[0].length][j] + Offset(0, r);
      _canvas!.drawLine(startPt, endPt, _paint);

      _paint.color = Colors.brown.withOpacity(.3);
      _paint.strokeWidth = strokeScale * _random.nextDouble();
      final randomOffset = Offset(r * _random.nextDouble(), 0);
      _canvas!.drawLine(
        startPt + randomOffset,
        endPt + randomOffset,
        _paint,
      );
    }

    _paint.strokeWidth = 20;
    for (int i = 0; i < squareGrid.length; i++) {
      for (int j = 0; j < squareGrid[0].length; j++) {
        _paint.color = Colors.black12;
        _drawCenterParallelLines(squareGrid[i][j] + Offset(r * _random.nextDouble(), r * _random.nextDouble()));
      }
    }

    _paint.style = PaintingStyle.stroke;
  }

  void _drawCenterParallelLines(Offset center) {
    final upStart = Offset(center.dx, center.dy + r);
    final upEnd = Offset(center.dx, center.dy - r);
    final horizontalStart = Offset(center.dx - r, center.dy);
    final horizontalEnd = Offset(center.dx + r, center.dy);
    if (_random.nextBool()) {
      _canvas!.drawLine(horizontalStart, horizontalEnd, _paint);
    } else {
      _canvas!.drawLine(upStart, upEnd, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

final List<Color> palette = [
  Colors.red[500]!,
  Colors.redAccent[700]!,
  Colors.green[500]!,
  Colors.lightGreen[300]!,
  Colors.deepPurpleAccent,
  Colors.deepPurple[200]!,
  Colors.blueAccent[200]!,
  Colors.blueAccent[100]!,
  Colors.orangeAccent,
  Colors.orangeAccent[700]!,
//  Colors.yellow[300]!,
//  Colors.yellow[500]!,
];
