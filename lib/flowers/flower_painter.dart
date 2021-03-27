import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'flower.dart';

/// [FlowerPainter] animates some flowers
class FlowerPainter extends CustomPainter {
  FlowerPainter({
    required this.progress,
    required this.flowers,
  });

  /// a value between 0.0 and 1.0 indicating the total progress of the animation. It comes from
  /// the animation controller in the calling widget
  final double progress;
  final List<Flower> flowers;

  final _paint = Paint();
  Path petalsPath = Path();

  // it appears that paint is called in desktop every time the mouse moves over a new widget, or in and out of the
  // program screen
  @override
  void paint(Canvas canvas, Size size) {
    petalsPath.reset();
    _drawFlowers(canvas: canvas, flowers: flowers);
  }

  void _drawFlowers({
    required Canvas canvas,
    required List<Flower> flowers,
  }) {
    for (int i = 0; i < flowers.length; i++) {
      _drawFlower(
        canvas: canvas,
        flower: flowers[i],
      );
    }
  }

  void _drawFlower({
    required Canvas canvas,
    required Flower flower,
  }) {
    petalsPath.reset();
    final travelDistance = 500;
    double speedFactor = 1;
    if (flower.flowerType == FlowerTypes.SmallSakura) {
      speedFactor = 1.2;
    } else if (flower.flowerType == FlowerTypes.BigSakura) {
      speedFactor = .6;
    }
    final newDx = flower.center.dx + progress * flower.vx * travelDistance * speedFactor;
    final newDy = flower.center.dy + progress * flower.vy * travelDistance * speedFactor;
    final newFlower = flower.copyWith(center: Offset(newDx, newDy));

    double theta = 0;
    for (int i = 0; i < flower.numPetals; i++) {
      theta = theta + 2 * pi / flower.numPetals;
      _drawPetal(
        canvas: canvas,
        flower: newFlower,
        theta: theta,
      );
    }
    //these need to be separate loops, otherwise the petals draw over all the insides, except one
    theta = 0;
    for (int i = 0; i < flower.numPetals; i++) {
      theta = theta + 2 * pi / flower.numPetals;
      _drawInsides(
        canvas: canvas,
        flower: newFlower,
        theta: theta,
      );
    }
  }

  void _drawPetal({
    required Canvas canvas,
    required Flower flower,
    required double theta,
  }) {
    _paint.color = flower.color;
    Offset startPoint = flower.center + Offset(flower.innerRadius * cos(theta), flower.innerRadius * sin(theta));

    Offset endPt = flower.center +
        Offset(flower.innerRadius * cos(theta + flower.innerWidthSweep),
            flower.innerRadius * sin(theta + flower.innerWidthSweep));

    Offset pt1 = flower.center +
        Offset((flower.innerRadius + flower.ctrlPtHeight) * cos(theta - flower.outerWidthDelta),
            (flower.innerRadius + flower.ctrlPtHeight) * sin(theta - flower.outerWidthDelta));
    Offset pt2 = flower.center +
        Offset(
            (flower.innerRadius + flower.ctrlPtHeight) * cos(theta + flower.innerWidthSweep + flower.outerWidthDelta),
            (flower.innerRadius + flower.ctrlPtHeight) * sin(theta + flower.innerWidthSweep + flower.outerWidthDelta));

    petalsPath.moveTo(startPoint.dx, startPoint.dy);
    petalsPath.cubicTo(pt1.dx, pt1.dy, pt2.dx, pt2.dy, endPt.dx, endPt.dy);

    _paint.style = PaintingStyle.fill;
    canvas.drawCircle(flower.center, flower.innerRadius, _paint);
    canvas.drawPath(petalsPath, _paint);

    _paint.color = flower.flowerStrokeColor;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 1.5;
    _paint.strokeCap = StrokeCap.round;
    canvas.drawPath(petalsPath, _paint);
  }

  void _drawInsides({required Canvas canvas, required Flower flower, required double theta}) {
    _paint.color = flower.flowerStrokeColor;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 2;
    _paint.strokeCap = StrokeCap.round;
    final midTheta = theta + flower.innerWidthSweep / 2;
    final midLineLength = flower.ctrlPtHeight / 4;
    final innerMidPt = flower.center + Offset(flower.innerRadius * cos(midTheta), flower.innerRadius * sin(midTheta));
    final outerMidPt = flower.center +
        Offset((flower.innerRadius + midLineLength / 2) * cos(midTheta),
            (flower.innerRadius + midLineLength / 2) * sin(midTheta));
    final innerLftPt = flower.center + Offset(flower.innerRadius * cos(theta), flower.innerRadius * sin(theta));
    final outerLftPt = flower.center +
        Offset((flower.innerRadius + midLineLength * .8) * cos(theta),
            (flower.innerRadius + midLineLength * .8) * sin(theta));
    canvas.drawLine(innerMidPt, outerMidPt, _paint);
    canvas.drawLine(innerLftPt, outerLftPt, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
