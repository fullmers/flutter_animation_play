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
  Path bigFlowerPath = Path();
  Path mediumFlowerPath = Path();
  Path smallFlowerPath = Path();
  Path bigFlowerStamp = Path();
  Path mediumFlowerStamp = Path();
  Path smallFlowerStamp = Path();
  int _numPetals = 5;

  // it appears that paint is called in desktop every time the mouse moves over a new widget, or in and out of the
  // program screen
  @override
  void paint(Canvas canvas, Size size) {
    petalsPath.reset();
    //  _drawFlowers(canvas: canvas, flowers: flowers);
    bigFlowerStamp = createFlowerStamp(canvas, FlowerType.BigSakura);
    mediumFlowerStamp = createFlowerStamp(canvas, FlowerType.MediumSakura);
    smallFlowerStamp = createFlowerStamp(canvas, FlowerType.SmallSakura);
    _drawBigFlowers(canvas: canvas, flowers: flowers);
  }

  Path createFlowerStamp(Canvas canvas, FlowerType flowerType) {
    Path path = Path();
    double innerRadius = Flower.getInnerRadius(flowerType);
    double ctrlPtHeight = Flower.getCtrlPtHeight(flowerType);
    double theta = 0;
    double innerWidthSweep = 2 * pi / _numPetals;
    double outerWidthDelta = pi / (_numPetals * 8);

    for (int i = 0; i < _numPetals; i++) {
      theta = theta + 2 * pi / _numPetals;
      Offset startPoint = Offset(innerRadius * cos(theta), innerRadius * sin(theta));
      path.moveTo(startPoint.dx, startPoint.dy);

      Offset endPt = Offset(innerRadius * cos(theta + innerWidthSweep), innerRadius * sin(theta + innerWidthSweep));

      Offset pt1 = Offset((innerRadius + ctrlPtHeight) * cos(theta - outerWidthDelta),
          (innerRadius + ctrlPtHeight) * sin(theta - outerWidthDelta));
      Offset pt2 = Offset((innerRadius + ctrlPtHeight) * cos(theta + innerWidthSweep + outerWidthDelta),
          (innerRadius + ctrlPtHeight) * sin(theta + innerWidthSweep + outerWidthDelta));
      path.cubicTo(pt1.dx, pt1.dy, pt2.dx, pt2.dy, endPt.dx, endPt.dy);

      final midTheta = theta + innerWidthSweep / 2;
      final midLineLength = ctrlPtHeight / 4;
      final tempPath = Path();

      final innerMidPt = Offset(innerRadius * cos(midTheta), innerRadius * sin(midTheta));
      final outerMidPt =
          Offset((innerRadius + midLineLength / 2) * cos(midTheta), (innerRadius + midLineLength / 2) * sin(midTheta));
      tempPath.moveTo(innerMidPt.dx, innerMidPt.dy);
      tempPath.lineTo(outerMidPt.dx, outerMidPt.dy);
      path.addPath(tempPath, innerMidPt);
      path.addOval(Rect.fromCircle(center: Offset.zero, radius: innerRadius));
    }
    return path;
  }

  void _drawBigFlowers({
    required Canvas canvas,
    required List<Flower> flowers,
  }) {
    for (int i = 0; i < flowers.length; i++) {
      _createFlowerPaths(
        canvas: canvas,
        flower: flowers[i],
      );
    }
    List<PathMetric> bigPathMetrics = bigFlowerPath.computeMetrics().toList(growable: true);
    for (var pathMetric in bigPathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length,
      );
      _paint.style = PaintingStyle.fill;
      _paint.color = flowers[0].petalFillColor;
      canvas.drawPath(extractPath, _paint);
      _paint.color = flowers[0].flowerStrokeColor;
      _paint.style = PaintingStyle.stroke;
      _paint.strokeWidth = 1;
      _paint.strokeCap = StrokeCap.round;
      canvas.drawPath(extractPath, _paint);
    }

    List<PathMetric> mediumPathMetrics = mediumFlowerPath.computeMetrics().toList(growable: true);
    for (var pathMetric in mediumPathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length,
      );
      _paint.style = PaintingStyle.fill;
      _paint.color = flowers[0].petalFillColor;
      canvas.drawPath(extractPath, _paint);
      _paint.color = flowers[0].flowerStrokeColor;
      _paint.style = PaintingStyle.stroke;
      _paint.strokeWidth = 1;
      _paint.strokeCap = StrokeCap.round;
      canvas.drawPath(extractPath, _paint);
    }

    List<PathMetric> smallPathMetrics = bigFlowerPath.computeMetrics().toList(growable: true);
    for (var pathMetric in smallPathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length,
      );
      _paint.style = PaintingStyle.fill;
      _paint.color = flowers[0].petalFillColor;
      canvas.drawPath(extractPath, _paint);
      _paint.color = flowers[0].flowerStrokeColor;
      _paint.style = PaintingStyle.stroke;
      _paint.strokeWidth = 1;
      _paint.strokeCap = StrokeCap.round;
      canvas.drawPath(extractPath, _paint);
    }
  }

  void _createFlowerPaths({
    required Canvas canvas,
    required Flower flower,
  }) {
    final travelDistance = 200;
    double speedFactor = 1;
    if (flower.flowerType == FlowerType.SmallSakura) {
      speedFactor = 1.2;
    } else if (flower.flowerType == FlowerType.BigSakura) {
      speedFactor = .6;
    }
    final newDx = flower.seed.center.dx + progress * flower.seed.mX * travelDistance * speedFactor + 200;
    final newDy = flower.seed.center.dy + progress * flower.seed.mY * travelDistance * speedFactor + 0;

    switch (flower.flowerType) {
      case FlowerType.SmallSakura:
        smallFlowerPath.addPath(smallFlowerStamp, Offset(newDx, newDy));
        break;
      case FlowerType.MediumSakura:
        mediumFlowerPath.addPath(mediumFlowerStamp, Offset(newDx, newDy));
        break;
      case FlowerType.BigSakura:
        bigFlowerPath.addPath(bigFlowerStamp, Offset(newDx, newDy));
        break;
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
