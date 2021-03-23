import 'dart:math';
import 'dart:ui';

import 'package:animaplay/ptolemy/fixed_points_for_ptolemy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PtolemyPainter extends CustomPainter {
  PtolemyPainter({
    required this.radius,
    required this.dotRadius,
    required this.progress,
    required this.fixedPts,
  });

  final double radius;
  final double dotRadius;
  final double progress;
  final FixedPointsForPtolemy fixedPts;

  final Color _refDotColor = Colors.purple;

  Paint _paint = Paint();
  Canvas? _canvas;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.strokeWidth = dotRadius * .5;
    _paint.style = PaintingStyle.stroke;
    _paint.color = Colors.green;

    _canvas = canvas;
    _canvas?.drawCircle(fixedPts.center, radius, _paint);

    _drawTriangle();

    final movingPt = _drawMovingDotOnCircle();

    _drawMovingLines(
      movingPt: movingPt,
    );
  }

  Offset _drawMovingDotOnCircle() {
    final theta = 2 * pi * progress;
    final Offset movingPt = Offset(
      fixedPts.center.dx + radius * cos(theta),
      fixedPts.center.dy + radius * sin(theta),
    );

    _paint.color = _refDotColor;
    _canvas?.drawCircle(movingPt, dotRadius, _paint);
    return movingPt;
  }

  void _drawTriangle() {
    _paint.color = Colors.grey;
    _paint.style = PaintingStyle.fill;
    _canvas?.drawCircle(fixedPts.refTrianglePt1, dotRadius, _paint);
    _canvas?.drawCircle(fixedPts.refTrianglePt2, dotRadius, _paint);
    _canvas?.drawCircle(fixedPts.refTrianglePt3, dotRadius, _paint);

    _paint.strokeWidth = .5;
    _canvas?.drawLine(fixedPts.refTrianglePt1, fixedPts.refTrianglePt3, _paint);
    _canvas?.drawLine(fixedPts.refTrianglePt3, fixedPts.refTrianglePt2, _paint);
    _canvas?.drawLine(fixedPts.refTrianglePt2, fixedPts.refTrianglePt1, _paint);
  }

  void _drawMovingLines({
    required Offset movingPt,
  }) {
    // draw the reference fixed dots on the side
    _paint.color = _refDotColor;
    _canvas?.drawCircle(fixedPts.leftFixedPt, dotRadius, _paint);
    _canvas?.drawCircle(fixedPts.rtFixedPt, dotRadius, _paint);

    // draw the lines from the triangle pts to the moving dot
    _paint.strokeWidth = 2.5;
    final chord1Color = Colors.blue;
    _paint.color = chord1Color;
    _canvas?.drawLine(fixedPts.refTrianglePt1, movingPt, _paint);

    final chord2Color = Colors.red;
    _paint.color = chord2Color;
    _canvas?.drawLine(fixedPts.refTrianglePt2, movingPt, _paint);

    final chord3Color = Colors.yellow;
    _paint.color = chord3Color;
    _canvas?.drawLine(fixedPts.refTrianglePt3, movingPt, _paint);

    // calculate the length of each line
    final chord1 = (movingPt - fixedPts.refTrianglePt1).distance;
    final chord2 = (movingPt - fixedPts.refTrianglePt2).distance;
    final chord3 = (movingPt - fixedPts.refTrianglePt3).distance;

    if (chord1 > chord2 && chord1 > chord3) {
      _drawSideLines(
        bigChord: chord1,
        bigChordColor: chord1Color,
        littleChord1: chord2,
        littleChord1color: chord2Color,
        littleChord2: chord3,
        littleChord2color: chord3Color,
      );
    }

    if (chord2 > chord1 && chord2 > chord3) {
      _drawSideLines(
        bigChord: chord2,
        bigChordColor: chord2Color,
        littleChord1: chord3,
        littleChord1color: chord3Color,
        littleChord2: chord1,
        littleChord2color: chord1Color,
      );
    }

    if (chord3 > chord1 && chord3 > chord2) {
      _drawSideLines(
        bigChord: chord3,
        bigChordColor: chord3Color,
        littleChord1: chord1,
        littleChord1color: chord1Color,
        littleChord2: chord2,
        littleChord2color: chord2Color,
      );
    }
  }

  void _drawSideLines({
    required double bigChord,
    required Color bigChordColor,
    required double littleChord1,
    required Color littleChord1color,
    required double littleChord2,
    required Color littleChord2color,
  }) {
    _paint.color = bigChordColor;
    final leftMovingDot = Offset(fixedPts.leftFixedPt.dx, fixedPts.leftFixedPt.dy - bigChord);
    _canvas?.drawCircle(leftMovingDot, dotRadius, _paint);
    _canvas?.drawLine(fixedPts.leftFixedPt, leftMovingDot, _paint);

    _paint.color = littleChord1color;
    final rtMovingDot1 = Offset(fixedPts.rtFixedPt.dx, fixedPts.rtFixedPt.dy - littleChord1);
    _canvas?.drawCircle(rtMovingDot1, dotRadius, _paint);
    _canvas?.drawLine(fixedPts.rtFixedPt, rtMovingDot1, _paint);

    _paint.color = littleChord2color;
    final rtMovingDot2 = Offset(fixedPts.rtFixedPt.dx, rtMovingDot1.dy - littleChord2);
    _canvas?.drawCircle(rtMovingDot2, dotRadius, _paint);
    _canvas?.drawLine(rtMovingDot1, rtMovingDot2, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
