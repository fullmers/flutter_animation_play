import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// [FlowerPainter] animates some flowers
class FlowerPainter extends CustomPainter {
  FlowerPainter({
    required this.progress,
    required this.numPetals,
    required this.center,
    required this.width,
    required this.height,
  });

  /// a value between 0.0 and 1.0 indicating the total progress of the animation. It comes from
  /// the animation controller in the calling widget
  final double progress;
  final double width;
  final double height;

  final Offset center;
  final int numPetals;

  Offset _flowerCenter = Offset.zero;
  final _ctrlPtHeight = 100.0;
  final _outerWidthDelta = pi / 24;
  final _r = 10.0;
  final _numFlowers = 20;
  final _paint = Paint();
  final _random = Random();
  Path petalsPath = Path();

  double _theta = 0;
  double _innerWidthSweep = 0;

  // it appears that paint is called in desktop every time the mouse moves over a new widget, or in and out of the
  // program screen
  @override
  void paint(Canvas canvas, Size size) {
    print('calling paint');
    petalsPath.reset();
    _innerWidthSweep = 2 * pi / (numPetals);

    _paint.color = Colors.pink[300]!;

    _flowerCenter = center;
    canvas.drawCircle(_flowerCenter, _r / 2, _paint);

    for (int i = 1; i < _numFlowers; i++) {
      int colorIndex = (i % 9) * 100;
      if (colorIndex == 0) {
        colorIndex = 100;
      }
      print('i: $i, colorIndex: $colorIndex');
      _paint.color = Colors.green[colorIndex]!;
      _drawFlower(canvas, Colors.green[colorIndex]!);
    }
  }

  void _drawPetal(Canvas canvas, Color color) {
    _paint.color = color;
    Offset startPoint = _flowerCenter + Offset(_r * cos(_theta), _r * sin(_theta));

    Offset endPt = _flowerCenter + Offset(_r * cos(_theta + _innerWidthSweep), _r * sin(_theta + _innerWidthSweep));

    Offset pt1 = _flowerCenter +
        Offset((_r + _ctrlPtHeight) * cos(_theta - (_outerWidthDelta)),
            (_r + _ctrlPtHeight) * sin(_theta - (_outerWidthDelta)));
    Offset pt2 = _flowerCenter +
        Offset((_r + _ctrlPtHeight) * cos(_theta + (_innerWidthSweep + _outerWidthDelta)),
            (_r + _ctrlPtHeight) * sin(_theta + (_innerWidthSweep + _outerWidthDelta)));

    canvas.drawCircle(pt1, 3, _paint);
    canvas.drawCircle(pt2, 3, _paint);

    petalsPath.moveTo(startPoint.dx, startPoint.dy);
    petalsPath.cubicTo(pt1.dx, pt1.dy, pt2.dx, pt2.dy, endPt.dx, endPt.dy);

    _paint.style = PaintingStyle.fill;
    canvas.drawPath(petalsPath, _paint);

    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 2.5;
    _paint.color = Colors.yellowAccent[100]!;
    canvas.drawPath(petalsPath, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawFlower(Canvas canvas, Color color) {
    petalsPath.reset();
    _paint.color = color;
    double dx = _random.nextDouble() * width;
    double dy = _random.nextDouble() * height;
    _flowerCenter = Offset(dx, dy);

    _paint.style = PaintingStyle.fill;
    canvas.drawCircle(_flowerCenter, _r, _paint);

    _paint.style = PaintingStyle.stroke;

    for (int i = 0; i < numPetals; i++) {
      _theta = _theta + 2 * pi / numPetals;
      _drawPetal(canvas, color);
    }
  }
}
