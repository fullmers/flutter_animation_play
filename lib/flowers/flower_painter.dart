import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'flower.dart';

/// [FlowerPainter] animates some flowers
class FlowerPainter extends CustomPainter {
  FlowerPainter({
    required this.progress,
    required this.flowers,
    required this.waveColor,
  });

  /// a value between 0.0 and 1.0 indicating the total progress of the animation. It comes from
  /// the animation controller in the calling widget
  final double progress;
  final List<Flower> flowers;
  final Color waveColor;

  final _paint = Paint();
  Path petalsPath = Path();

  // it appears that paint is called in desktop every time the mouse moves over a new widget, or in and out of the
  // program screen
  @override
  void paint(Canvas canvas, Size size) {
    petalsPath.reset();
    _drawWaves(canvas: canvas, size: size);
    _drawFlowers(canvas: canvas, flowers: flowers);
  }

  void _drawWaves({required Canvas canvas, required Size size}) {
    int numCols = 16;
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
    final travelDistance = 200;
    double speedFactor = 1;
    if (flower.flowerType == FlowerType.SmallSakura) {
      speedFactor = 1.2;
    } else if (flower.flowerType == FlowerType.BigSakura) {
      speedFactor = .6;
    }
    final newDx = flower.seed.center.dx + progress * flower.seed.mX * travelDistance * speedFactor;
    final newDy = flower.seed.center.dy + progress * flower.seed.mY * travelDistance * speedFactor;
    final newSeed = flower.seed.copyWith(
      center: Offset(newDx, newDy),
    );
    final newFlower = flower.copyWith(
      seed: newSeed,
    );

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
    _paint.color = flower.petalFillColor;
    Offset startPoint = flower.seed.center + Offset(flower.innerRadius * cos(theta), flower.innerRadius * sin(theta));

    Offset endPt = flower.seed.center +
        Offset(flower.innerRadius * cos(theta + flower.innerWidthSweep),
            flower.innerRadius * sin(theta + flower.innerWidthSweep));

    Offset pt1 = flower.seed.center +
        Offset((flower.innerRadius + flower.ctrlPtHeight) * cos(theta - flower.outerWidthDelta),
            (flower.innerRadius + flower.ctrlPtHeight) * sin(theta - flower.outerWidthDelta));
    Offset pt2 = flower.seed.center +
        Offset(
            (flower.innerRadius + flower.ctrlPtHeight) * cos(theta + flower.innerWidthSweep + flower.outerWidthDelta),
            (flower.innerRadius + flower.ctrlPtHeight) * sin(theta + flower.innerWidthSweep + flower.outerWidthDelta));

    petalsPath.moveTo(startPoint.dx, startPoint.dy);
    petalsPath.cubicTo(pt1.dx, pt1.dy, pt2.dx, pt2.dy, endPt.dx, endPt.dy);

    _paint.style = PaintingStyle.fill;
    canvas.drawCircle(flower.seed.center, flower.innerRadius, _paint);
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
    final innerMidPt =
        flower.seed.center + Offset(flower.innerRadius * cos(midTheta), flower.innerRadius * sin(midTheta));
    final outerMidPt = flower.seed.center +
        Offset((flower.innerRadius + midLineLength / 2) * cos(midTheta),
            (flower.innerRadius + midLineLength / 2) * sin(midTheta));
    final innerLftPt = flower.seed.center + Offset(flower.innerRadius * cos(theta), flower.innerRadius * sin(theta));
    final outerLftPt = flower.seed.center +
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
