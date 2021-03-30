import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'flower.dart';

/// [FlowerPainter] animates some flowers
class FlowerPainter extends CustomPainter {
  FlowerPainter({
    required this.progress,
    required this.flowers,
    required this.colorScheme,
    required this.numPetals,
  });

  /// a value between 0.0 and 1.0 indicating the total progress of the animation. It comes from
  /// the animation controller in the calling widget
  final double progress;
  final List<Flower> flowers;
  final FlowerColorScheme colorScheme;

  /// number of petals on the given flower. can range from 4-10.
  final int numPetals;

  final _paint = Paint();
  Path bigFlowerPath = Path();
  Path mediumFlowerPath = Path();
  Path smallFlowerPath = Path();
  Path bigFlowerStamp = Path();
  Path mediumFlowerStamp = Path();
  Path smallFlowerStamp = Path();

  // it appears that paint is called in desktop every time the mouse moves over a new widget, or in and out of the
  // program screen
  @override
  void paint(Canvas canvas, Size size) {
    _createFlowerStamps(canvas);
    _createFlowerPaths(canvas);
    _drawFlowers(canvas: canvas, flowers: flowers);
  }

  void _createFlowerStamps(Canvas canvas) {
    bigFlowerStamp = _createFlowerStamp(canvas, FlowerType.BigSakura);
    mediumFlowerStamp = _createFlowerStamp(canvas, FlowerType.MediumSakura);
    smallFlowerStamp = _createFlowerStamp(canvas, FlowerType.SmallSakura);
  }

  void _createFlowerPaths(Canvas canvas) {
    for (int i = 0; i < flowers.length; i++) {
      _createFlowerPath(
        canvas: canvas,
        flower: flowers[i],
      );
    }
  }

  Path _createFlowerStamp(Canvas canvas, FlowerType flowerType) {
    Path path = Path();
    double innerRadius = Flower.getInnerRadius(flowerType);
    double ctrlPtHeight = Flower.getCtrlPtHeight(flowerType);
    double theta = 0;
    double innerWidthSweep = Flower.getInnerSweep(numPetals);
    double outerWidthDelta = Flower.outerWidthDelta(numPetals);

    for (int i = 0; i < numPetals; i++) {
      theta = theta + 2 * pi / numPetals;
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

  void _drawFlowers({
    required Canvas canvas,
    required List<Flower> flowers,
  }) {
    List<PathMetric> bigPathMetrics = bigFlowerPath.computeMetrics().toList(growable: true);
    final bigTheme = FlowerTheme(
      type: FlowerType.BigSakura,
      colorScheme: colorScheme,
    );
    _paintFlowers(canvas: canvas, pathMetrics: bigPathMetrics, flowerTheme: bigTheme);

    List<PathMetric> mediumPathMetrics = mediumFlowerPath.computeMetrics().toList(growable: true);
    final mediumTheme = FlowerTheme(
      type: FlowerType.MediumSakura,
      colorScheme: colorScheme,
    );
    _paintFlowers(canvas: canvas, pathMetrics: mediumPathMetrics, flowerTheme: mediumTheme);

    List<PathMetric> smallPathMetrics = smallFlowerPath.computeMetrics().toList(growable: true);
    final smallTheme = FlowerTheme(
      type: FlowerType.SmallSakura,
      colorScheme: colorScheme,
    );
    _paintFlowers(canvas: canvas, pathMetrics: smallPathMetrics, flowerTheme: smallTheme);
  }

  void _paintFlowers({
    required Canvas canvas,
    required List<PathMetric> pathMetrics,
    required FlowerTheme flowerTheme,
  }) {
    for (var pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length,
      );
      _paint.style = PaintingStyle.fill;
      _paint.color = flowerTheme.petalFillColor;
      canvas.drawPath(extractPath, _paint);
      _paint.color = flowerTheme.flowerStrokeColor;
      _paint.style = PaintingStyle.stroke;
      _paint.strokeWidth = 1;
      _paint.strokeCap = StrokeCap.round;
      canvas.drawPath(extractPath, _paint);
    }
  }

  void _createFlowerPath({
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
