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

  /// number of petals on the given flower. can range from 4-10.
  final int numPetals;

  /// the flowers to be painted
  final List<Flower> flowers;

  /// the color scheme of the flowers
  final FlowerColorScheme colorScheme;

  final _paint = Paint();
  final _bigFlowerPath = Path();
  final _mediumFlowerPath = Path();
  final _smallFlowerPath = Path();
  final _bigFlowerStamp = Path();
  final _mediumFlowerStamp = Path();
  final _smallFlowerStamp = Path();

  // it appears that paint is called in desktop every time the mouse moves over a new widget, or in and out of the
  // program screen
  @override
  void paint(Canvas canvas, Size size) {
    _createFlowerStamps(canvas);
    _createFlowerPaths(canvas);
    _drawFlowers(canvas);
  }

  void _createFlowerStamps(Canvas canvas) {
    _bigFlowerStamp.extendWithPath(_createFlowerStamp(canvas, FlowerType.BigSakura), Offset.zero);
    _mediumFlowerStamp.extendWithPath(_createFlowerStamp(canvas, FlowerType.MediumSakura), Offset.zero);
    _smallFlowerStamp.extendWithPath(_createFlowerStamp(canvas, FlowerType.SmallSakura), Offset.zero);
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

      final innerLinesPath = Path();
      final midTheta = theta + innerWidthSweep / 2;
      final midLineLength = ctrlPtHeight / 4;
      final innerMidPt = Offset(innerRadius * cos(midTheta), innerRadius * sin(midTheta));
      final outerMidPt =
          Offset((innerRadius + midLineLength / 2) * cos(midTheta), (innerRadius + midLineLength / 2) * sin(midTheta));
      innerLinesPath.moveTo(innerMidPt.dx, innerMidPt.dy);
      innerLinesPath.lineTo(outerMidPt.dx, outerMidPt.dy);
      path.addPath(innerLinesPath, innerMidPt);
      path.addOval(Rect.fromCircle(center: Offset.zero, radius: innerRadius));
    }
    return path;
  }

  void _drawFlowers(
    Canvas canvas,
  ) {
    List<PathMetric> bigPathMetrics = _bigFlowerPath.computeMetrics().toList(growable: true);
    final bigTheme = FlowerTheme(
      type: FlowerType.BigSakura,
      colorScheme: colorScheme,
    );
    _paintFlowers(canvas: canvas, pathMetrics: bigPathMetrics, flowerTheme: bigTheme);

    List<PathMetric> mediumPathMetrics = _mediumFlowerPath.computeMetrics().toList(growable: true);
    final mediumTheme = FlowerTheme(
      type: FlowerType.MediumSakura,
      colorScheme: colorScheme,
    );
    _paintFlowers(canvas: canvas, pathMetrics: mediumPathMetrics, flowerTheme: mediumTheme);

    List<PathMetric> smallPathMetrics = _smallFlowerPath.computeMetrics().toList(growable: true);
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
        _smallFlowerPath.addPath(_smallFlowerStamp, Offset(newDx, newDy));
        break;
      case FlowerType.MediumSakura:
        _mediumFlowerPath.addPath(_mediumFlowerStamp, Offset(newDx, newDy));
        break;
      case FlowerType.BigSakura:
        _bigFlowerPath.addPath(_bigFlowerStamp, Offset(newDx, newDy));
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
