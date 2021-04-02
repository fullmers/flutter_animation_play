import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'flower.dart';

/// [SingleFlowerPainter] paints a single flower
class SingleFlowerPainter extends CustomPainter {
  SingleFlowerPainter({
    required this.flower,
    required this.colorScheme,
    required this.numPetals,
  });

  final Flower flower;
  final FlowerColorScheme colorScheme;

  /// number of petals on the given flower. can range from 4-10.
  final int numPetals;

  final _paint = Paint();
  Path _flowerStamp = Path();

  // it appears that paint is called in desktop every time the mouse moves over a new widget, or in and out of the
  // program screen
  @override
  void paint(Canvas canvas, Size size) {
    _flowerStamp = _createFlowerStamp(canvas, flower.flowerType);
    _drawFlower(canvas: canvas, flower: flower);
  }

  Path _createFlowerStamp(Canvas canvas, FlowerType flowerType) {
    Path path = Path();
    double innerRadius = Flower.getInnerRadius(flowerType);
    double ctrlPtHeight = Flower.getCtrlPtHeight(flowerType);
    double theta = 0;
    double innerWidthSweep = Flower.getInnerSweep(numPetals);
    double outerWidthDelta = Flower.outerWidthDelta(numPetals);
    Offset center = Offset(flower.seed.center.dx, flower.seed.center.dy);

    for (int i = 0; i < numPetals; i++) {
      theta = theta + 2 * pi / numPetals;
      Offset startPoint = Offset(innerRadius * cos(theta), innerRadius * sin(theta)) + center;
      path.moveTo(startPoint.dx, startPoint.dy);

      Offset endPt =
          Offset(innerRadius * cos(theta + innerWidthSweep), innerRadius * sin(theta + innerWidthSweep)) + center;

      Offset pt1 = Offset((innerRadius + ctrlPtHeight) * cos(theta - outerWidthDelta),
              (innerRadius + ctrlPtHeight) * sin(theta - outerWidthDelta)) +
          center;
      Offset pt2 = Offset((innerRadius + ctrlPtHeight) * cos(theta + innerWidthSweep + outerWidthDelta),
              (innerRadius + ctrlPtHeight) * sin(theta + innerWidthSweep + outerWidthDelta)) +
          center;
      path.cubicTo(pt1.dx, pt1.dy, pt2.dx, pt2.dy, endPt.dx, endPt.dy);
    }

    path.addPath(
        _insidePath(
          flower.flowerType,
          center,
        ),
        Offset.zero);
    return path;
  }

  Path _insidePath(
    FlowerType flowerType,
    Offset center,
  ) {
    Path path = Path();
    double theta = 0;
    double innerRadius = Flower.getInnerRadius(flowerType);
    for (int i = 0; i < numPetals; i++) {
      theta = theta + 2 * pi / numPetals;
      double ctrlPtHeight = Flower.getCtrlPtHeight(flowerType);
      double innerWidthSweep = Flower.getInnerSweep(numPetals);
      final midTheta = theta + innerWidthSweep / 2;
      final midLineLength = ctrlPtHeight / 4;

      final innerMidPt = Offset(innerRadius * cos(midTheta), innerRadius * sin(midTheta)) + center;
      final outerMidPt =
          Offset((innerRadius + midLineLength / 2) * cos(midTheta), (innerRadius + midLineLength / 2) * sin(midTheta)) +
              center;
      path.moveTo(innerMidPt.dx, innerMidPt.dy);
      path.lineTo(outerMidPt.dx, outerMidPt.dy);
    }
    path.addOval(Rect.fromCircle(center: center, radius: innerRadius));
    return path;
  }

  void _drawFlower({
    required Canvas canvas,
    required Flower flower,
  }) {
    final bigTheme = FlowerTheme(
      type: flower.flowerType,
      colorScheme: colorScheme,
    );
    _paint.style = PaintingStyle.fill;
    _paint.color = bigTheme.petalFillColor;
    canvas.drawPath(_flowerStamp, _paint);
    _paint.color = bigTheme.flowerStrokeColor;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 1;
    _paint.strokeCap = StrokeCap.round;
    canvas.drawPath(_flowerStamp, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
