import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class TilesPainter extends CustomPainter {
  TilesPainter({
    required this.hexGrid,
    required this.squareGrid,
    required this.useSquares,
  });

  final List<List<Offset>> hexGrid;
  final List<List<Offset>> squareGrid;
  final bool useSquares;

  final Random _random = Random();
  final Paint _paint = Paint();
  Canvas? _canvas;
  double r = 0;
  final numColors = palette.length;
  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;

    final width = size.width;
    final numCols = 5;
    final side = width / numCols;
    r = side / 2;

    // square grid:
    if (useSquares) {
      for (int i = 0; i < squareGrid.length; i++) {
        for (int j = 0; j < squareGrid[0].length; j++) {
          if (_random.nextBool()) {
            if (_random.nextBool()) {
              _drawColorCircle(squareGrid[i][j]);
            }
          } else {
            if (_random.nextBool()) {
              _drawColorSquares(squareGrid[i][j]);
            }
          }
        }
      }
    } else {
      for (int i = 0; i < hexGrid.length; i++) {
        for (int j = 0; j < hexGrid[0].length; j++) {
          if (_random.nextBool()) {
            if (_random.nextBool()) {
              _drawColorCircle(hexGrid[i][j]);
            }
          } else {
            if (_random.nextBool()) {
              _drawColorSquares(hexGrid[i][j]);
            }
          }
        }
      }
    }

    _paint.style = PaintingStyle.stroke;
  }

  void _drawColorCircle(Offset center) {
    _paint.style = PaintingStyle.fill;
    _paint.color = palette[_random.nextInt(numColors)].withOpacity(.3);

    final bigR = r * _random.nextDouble() * 3;
    final r2 = bigR * _random.nextDouble();
    final r3 = bigR * _random.nextDouble();
    final mediumR = r2 > r3 ? r2 : r3;
    final smallR = mediumR == r2 ? r3 : r2;
    _canvas!.drawCircle(Offset(center.dx, center.dy), bigR * _random.nextDouble(), _paint);
    _paint.color = palette[_random.nextInt(numColors)].withOpacity(.5);
    _canvas!.drawCircle(Offset(center.dx, center.dy), mediumR * _random.nextDouble(), _paint);
    _paint.color = palette[_random.nextInt(numColors)].withOpacity(.7);
    _canvas!.drawCircle(Offset(center.dx, center.dy), smallR * _random.nextDouble(), _paint);
  }

  void _drawColorSquares(Offset center) {
    _paint.style = PaintingStyle.fill;
    _paint.color = palette[_random.nextInt(numColors)].withOpacity(.3);

    final bigR = r * _random.nextDouble() * 1.5;
    final r2 = bigR * _random.nextDouble();
    final r3 = bigR * _random.nextDouble();
    final mediumR = r2 > r3 ? r2 : r3;
    final smallR = mediumR == r2 ? r3 : r2;
    _canvas!.drawRect(Rect.fromCircle(center: center, radius: bigR), _paint);
    _paint.color = palette[_random.nextInt(numColors)].withOpacity(.5);
    _canvas!.drawRect(Rect.fromCircle(center: center, radius: mediumR), _paint);
    _paint.color = palette[_random.nextInt(numColors)];
    _canvas!.drawRect(Rect.fromCircle(center: center, radius: smallR), _paint);
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

  void _drawDiagonalLines(Offset center) {
    final upLft = Offset(center.dx - r, center.dy - r);
    final bottomRt = Offset(center.dx + r, center.dy + r);
    final upRt = Offset(center.dx + r, center.dy - r);
    final bottomLft = Offset(center.dx - r, center.dy + r);
    if (_random.nextBool()) {
      _canvas!.drawLine(upLft, bottomRt, _paint);
    } else {
      _canvas!.drawLine(upRt, bottomLft, _paint);
    }
  }

  void _drawCurvyLines(Offset center) {
    final up = Offset(center.dx, center.dy - r);
    final bottom = Offset(center.dx, center.dy + r);
    final rt = Offset(center.dx + r, center.dy);
    final lft = Offset(center.dx - r, center.dy);
    Path path = Path();
    Offset startPt1;
    Offset endPt1;
    Offset ctrlPt = center;
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
    _canvas!.drawPath(path, _paint);
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
