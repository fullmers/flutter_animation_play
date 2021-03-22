import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PtolemyPainter extends CustomPainter {
  PtolemyPainter({
    required this.center,
    required this.leftFixedDot,
    required this.rtFixedDot,
    required this.triangleSide,
    required this.radius,
    required this.dotRadius,
    required this.progress,
    required this.period,
  });

  final Offset center;
  final Offset leftFixedDot;
  final Offset rtFixedDot;
  final double triangleSide;
  final double radius;
  final double dotRadius;
  final int period;
  final double progress;

  Paint _paint = Paint();
  Canvas? _canvas;

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _paint.strokeWidth = 2.5;
    _paint.style = PaintingStyle.stroke;
    _paint.color = Colors.green;
    _canvas?.drawCircle(center, radius, _paint);
    _paint.style = PaintingStyle.fill;

    final dotRadius = 10.0;
    final pt1 = _calcTriangleStart();
    final pt2 = Offset(center.dx + radius, center.dy);
    final pt3 = Offset(pt1.dx, pt1.dy + triangleSide);

    _drawTriangle(
      pt1: pt1,
      pt2: pt2,
      pt3: pt3,
    );

    final theta = 2 * pi * progress;
    final Offset movingPt = Offset(
      center.dx + radius * cos(theta),
      center.dy + radius * sin(theta),
    );

    _paint.color = Colors.purple;
    _canvas?.drawCircle(movingPt, dotRadius, _paint);

    _drawMovingLines(
      pt1: pt1,
      pt2: pt2,
      pt3: pt3,
      movingPt: movingPt,
    );
  }

  Offset _calcTriangleStart() {
    double theta = acos((triangleSide / 2) / radius);
    double h = radius * cos(pi / 2 - theta);
    return (Offset(center.dx - h, center.dy - triangleSide / 2));
  }

  void _drawTriangle({
    required Offset pt1,
    required Offset pt2,
    required Offset pt3,
  }) {
    _paint.color = Colors.grey;
    _canvas?.drawCircle(pt1, dotRadius, _paint);
    _canvas?.drawCircle(pt2, dotRadius, _paint);
    _canvas?.drawCircle(pt3, dotRadius, _paint);

    _paint.strokeWidth = .5;
    _canvas?.drawLine(pt1, pt3, _paint);
    _canvas?.drawLine(pt3, pt2, _paint);
    _canvas?.drawLine(pt2, pt1, _paint);
    _paint.strokeWidth = 2.5;
  }

  void _drawMovingLines({
    required Offset pt1,
    required Offset pt2,
    required Offset pt3,
    required Offset movingPt,
  }) {
    //draw the reference fixed dots
    _paint.color = Colors.purple;
    _canvas?.drawCircle(leftFixedDot, dotRadius, _paint);
    _canvas?.drawCircle(rtFixedDot, dotRadius, _paint);

    // draw the lines from the triangle pts to the moving dot
    final chord1Color = Colors.blue;
    _paint.color = chord1Color;
    _canvas?.drawLine(pt1, movingPt, _paint);

    final chord2Color = Colors.red;
    _paint.color = chord2Color;
    _canvas?.drawLine(pt2, movingPt, _paint);

    final chord3Color = Colors.yellow;
    _paint.color = chord3Color;
    _canvas?.drawLine(pt3, movingPt, _paint);

    //calculate the length of each line
    final chord1 = (movingPt - pt1).distance;
    final chord2 = (movingPt - pt2).distance;
    final chord3 = (movingPt - pt3).distance;

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
    final leftMovingDot = Offset(leftFixedDot.dx, leftFixedDot.dy - bigChord);
    _canvas?.drawCircle(leftMovingDot, dotRadius, _paint);
    _canvas?.drawLine(leftFixedDot, leftMovingDot, _paint);

    _paint.color = littleChord1color;
    final rtMovingDot1 = Offset(rtFixedDot.dx, rtFixedDot.dy - littleChord1);
    _canvas?.drawCircle(rtMovingDot1, dotRadius, _paint);
    _canvas?.drawLine(rtFixedDot, rtMovingDot1, _paint);

    _paint.color = littleChord2color;
    final rtMovingDot2 = Offset(rtFixedDot.dx, rtMovingDot1.dy - littleChord2);
    _canvas?.drawCircle(rtMovingDot2, dotRadius, _paint);
    _canvas?.drawLine(rtMovingDot1, rtMovingDot2, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
