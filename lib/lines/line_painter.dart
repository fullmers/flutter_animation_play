import 'dart:ui';

import 'package:animaplay/lines/lines.dart';
import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  LinePainter({
    required this.directions,
    required this.squareGrid,
    required this.designType,
    required this.r,
  });

  final List<List<bool>> directions;
  final DesignType designType;
  final List<List<Offset>> squareGrid;
  final double r;

  final Paint _paint = Paint();
  Canvas? _canvas;
  int paintIterations = 1;

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 8;
    _paint.strokeCap = StrokeCap.round;

    _paint.color = Colors.deepPurple;
    switch (designType) {
      case DesignType.DiagonalLines:
        _drawDiagonalLines();
        break;
      case DesignType.ParallelLines:
        _drawCenterParallelLines();
        break;
    }
  }

  void _drawCenterParallelLines() {
    for (int i = 0; i < directions.length; i++) {
      for (int j = 0; j < directions[0].length; j++) {
        final startPt1 = Offset(squareGrid[i][j].dx, squareGrid[i][j].dy + r);
        final endPt1 = Offset(squareGrid[i][j].dx, squareGrid[i][j].dy - r);
        final startPt2 = Offset(squareGrid[i][j].dx - r, squareGrid[i][j].dy);
        final endPt2 = Offset(squareGrid[i][j].dx + r, squareGrid[i][j].dy);
        if (directions[i][j]) {
          _canvas!.drawLine(startPt1, endPt1, _paint);
        } else {
          _canvas!.drawLine(startPt2, endPt2, _paint);
        }
      }
    }
  }

  void _drawDiagonalLines() {
    for (int i = 0; i < directions.length; i++) {
      for (int j = 0; j < directions[0].length; j++) {
        final startPt1 = Offset(squareGrid[i][j].dx - r, squareGrid[i][j].dy - r);
        final endPt1 = Offset(squareGrid[i][j].dx + r, squareGrid[i][j].dy + r);
        final startPt2 = Offset(squareGrid[i][j].dx + r, squareGrid[i][j].dy - r);
        final endPt2 = Offset(squareGrid[i][j].dx - r, squareGrid[i][j].dy + r);
        if (directions[i][j]) {
          _canvas!.drawLine(startPt1, endPt1, _paint);
        } else {
          _canvas!.drawLine(startPt2, endPt2, _paint);
        }
      }
    }
  }

/*
  void _drawCurvyLines(List<List<Offset>> squareGrid) {
    for (int i = 0; i < squareGrid.length; i++) {
      for (int j = 0; j < squareGrid[0].length; j++) {
        /*
        final up = Offset(squareGrid[i][j].dx, squareGrid[i][j].dy - r);
        final bottom = Offset(squareGrid[i][j].dx, squareGrid[i][j].dy + r);
        final rt = Offset(squareGrid[i][j].dx + r, squareGrid[i][j].dy);
        final lft = Offset(squareGrid[i][j].dx - r, squareGrid[i][j].dy);
        Path path = Path();
        Offset startPt1;
        Offset endPt1;
        Offset ctrlPt = squareGrid[i][j];
        Offset startPt2;
        Offset endPt2;
        if (_random.nextBool()) {
          startPt1 = up;
          endPt1 = lft;
          startPt2 = rt;
          endPt2 = bottom;
        } else {
          startPt1 = up;
          endPt1 = rt;
          startPt2 = lft;
          endPt2 = bottom;
        }
        path.moveTo(startPt1.dx, startPt1.dy);
        path.quadraticBezierTo(ctrlPt.dx, ctrlPt.dy, endPt1.dx, endPt1.dy);
        path.moveTo(startPt2.dx, startPt2.dy);
        path.quadraticBezierTo(ctrlPt.dx, ctrlPt.dy, endPt2.dx, endPt2.dy);
        _canvas!.drawPath(path, _paint); */
      }
    }
  }
 */
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
