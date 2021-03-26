import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// [FlowerPainter] animates some flowers
class FlowerPainter extends CustomPainter {
  FlowerPainter({
    required this.progress,
    required this.numPetals,
    required this.largeFlowerCenters,
    required this.mediumFlowerCenters,
    required this.smallFlowerCenters,
    required this.referenceR,
    required this.referenceCtrlHeight,
  });

  /// a value between 0.0 and 1.0 indicating the total progress of the animation. It comes from
  /// the animation controller in the calling widget
  final double progress;
  final List<Offset> largeFlowerCenters;
  final List<Offset> mediumFlowerCenters;
  final List<Offset> smallFlowerCenters;
  final double referenceR;
  final double referenceCtrlHeight;

  final int numPetals;

  Offset _flowerCenter = Offset.zero;
  final _outerWidthDelta = pi / 24;
  final _paint = Paint();
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

    _drawFlowers(
      canvas: canvas,
      flowerCenters: smallFlowerCenters,
      color: Colors.lightBlue[900]!,
      r: referenceR / 3,
      ctrlPtHeight: referenceCtrlHeight / 4,
    );

    _drawFlowers(
      canvas: canvas,
      flowerCenters: mediumFlowerCenters,
      color: Colors.lightBlue[500]!,
      r: referenceR / 2,
      ctrlPtHeight: referenceCtrlHeight / 2,
    );

    _drawFlowers(
      canvas: canvas,
      flowerCenters: largeFlowerCenters,
      color: Colors.lightBlue[200]!,
      r: referenceR,
      ctrlPtHeight: referenceCtrlHeight,
    );
  }

  void _drawFlowers({
    required Canvas canvas,
    required List<Offset> flowerCenters,
    required double r,
    required double ctrlPtHeight,
    required Color color,
  }) {
    for (int i = 1; i < flowerCenters.length; i++) {
      int colorIndex = (i % 9) * 100;
      if (colorIndex == 0) {
        colorIndex = 100;
      }
      _paint.color = color;
      _flowerCenter = flowerCenters[i];
      _drawFlower(
        canvas: canvas,
        color: color,
        r: r,
        ctrlPtHeight: ctrlPtHeight,
      );
    }
  }

  void _drawPetal(
    Canvas canvas,
    Color color,
    double r,
    double ctrlPtHeight,
  ) {
    _paint.color = color;
    Offset startPoint = _flowerCenter + Offset(r * cos(_theta), r * sin(_theta));

    Offset endPt = _flowerCenter + Offset(r * cos(_theta + _innerWidthSweep), r * sin(_theta + _innerWidthSweep));

    Offset pt1 = _flowerCenter +
        Offset((r + ctrlPtHeight) * cos(_theta - (_outerWidthDelta)),
            (r + ctrlPtHeight) * sin(_theta - (_outerWidthDelta)));
    Offset pt2 = _flowerCenter +
        Offset((r + ctrlPtHeight) * cos(_theta + (_innerWidthSweep + _outerWidthDelta)),
            (r + ctrlPtHeight) * sin(_theta + (_innerWidthSweep + _outerWidthDelta)));

    //  canvas.drawCircle(pt1, 3, _paint);
    // canvas.drawCircle(pt2, 3, _paint);

    petalsPath.moveTo(startPoint.dx, startPoint.dy);
    petalsPath.cubicTo(pt1.dx, pt1.dy, pt2.dx, pt2.dy, endPt.dx, endPt.dy);

    _paint.style = PaintingStyle.fill;
    canvas.drawCircle(_flowerCenter, r, _paint);
    canvas.drawPath(petalsPath, _paint);

    _paint.color = Colors.lightBlue[100]!;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 1.5;
    _paint.strokeCap = StrokeCap.round;
    canvas.drawPath(petalsPath, _paint);
  }

  void _drawInsides({required Canvas canvas, required double r, required double ctrlPtHeight}) {
    _paint.color = Colors.lightBlue[50]!;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 2;
    _paint.strokeCap = StrokeCap.round;
    final midTheta = _theta + _innerWidthSweep / 2;
    final midLineLength = ctrlPtHeight / 4;
    final innerMidPt = _flowerCenter + Offset(r * cos(midTheta), r * sin(midTheta));
    final outerMidPt =
        _flowerCenter + Offset((r + midLineLength / 2) * cos(midTheta), (r + midLineLength / 2) * sin(midTheta));
    final innerLftPt = _flowerCenter + Offset(r * cos(_theta), r * sin(_theta));
    final outerLftPt = _flowerCenter + Offset((r + midLineLength) * cos(_theta), (r + midLineLength) * sin(_theta));
    canvas.drawLine(innerMidPt, outerMidPt, _paint);
    canvas.drawLine(innerLftPt, outerLftPt, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawFlower({
    required Canvas canvas,
    required Color color,
    required double r,
    required double ctrlPtHeight,
  }) {
    petalsPath.reset();

    _paint.color = color;
    for (int i = 0; i < numPetals; i++) {
      _theta = _theta + 2 * pi / numPetals;
      _drawPetal(canvas, color, r, ctrlPtHeight);
    }
    //these need to be separate loops, otherwise the petals draw over all the insides, except one
    for (int i = 0; i < numPetals; i++) {
      _theta = _theta + 2 * pi / numPetals;
      _drawInsides(
        canvas: canvas,
        r: r,
        ctrlPtHeight: ctrlPtHeight,
      );
    }
  }
}
