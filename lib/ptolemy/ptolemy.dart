import 'dart:math';

import 'package:animaplay/ptolemy/fixed_points_for_ptolemy.dart';
import 'package:animaplay/ptolemy/ptolemy_painter.dart';
import 'package:flutter/material.dart';

class PtolemysTheorem extends StatefulWidget {
  const PtolemysTheorem({required this.title});

  final String title;

  @override
  _PtolemysTheoremState createState() => _PtolemysTheoremState();
}

const period = 5;

class _PtolemysTheoremState extends State<PtolemysTheorem> with SingleTickerProviderStateMixin {
  final _triangleSide = 300.0;
  final _dotRadius = 10.0;

  late double _radius;
  late FixedPointsForPtolemy _fixedPoints;
  late AnimationController _controller;

  bool isPlaying = false;

  static final _animation = Tween<double>(
    begin: 0,
    end: period * 1.0,
  );

  @override
  void initState() {
    super.initState();
    _radius = _triangleSide / sqrt(3);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: period),
    );
    //AnimationController is actually an Animation<double> --
    // it  generates a new value whenever the hardware is ready for a new frame.

    _animation.animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // context is not available in initState, so these calcs must be done here
    final center = Offset(
      MediaQuery.of(context).size.width / 2 - _radius * .1,
      MediaQuery.of(context).size.height / 2 - 100,
    );

    double theta = acos((_triangleSide / 2) / _radius);
    double h = _radius * cos(pi / 2 - theta);
    final pt1 = Offset(center.dx - h, center.dy - _triangleSide / 2);
    final pt2 = Offset(center.dx + _radius, center.dy); //pt to right.
    final pt3 = Offset(pt1.dx, pt1.dy + _triangleSide); //bottom left
    final leftFixedDot = Offset(center.dx + _radius * 1.2, center.dy + _radius);
    final rtFixedDot = Offset(center.dx + _radius * 1.4, center.dy + _radius);
    _fixedPoints = FixedPointsForPtolemy(
      center: center,
      leftFixedPt: leftFixedDot,
      rtFixedPt: rtFixedDot,
      refTrianglePt1: pt1,
      refTrianglePt2: pt2,
      refTrianglePt3: pt3,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: CustomPaint(
          foregroundPainter: PtolemyPainter(
            triangleSide: _triangleSide,
            radius: _radius,
            dotRadius: _dotRadius,
            progress: _controller.value,
            fixedPts: _fixedPoints,
          ),
          child: Container(
            color: Colors.black87,
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Row(
          children: [
            Semantics(
              label: 'Reset',
              child: ElevatedButton(
                onPressed: _reset,
                child: Icon(Icons.replay),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Semantics(
              label: 'Play',
              child: ElevatedButton(
                onPressed: _play,
                child: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _play() {
    setState(() {
      if (isPlaying == false) {
        _controller.repeat();
        isPlaying = true;
      } else {
        _controller.stop();
        isPlaying = false;
      }
    });
  }

  void _reset() {
    setState(() {
      _controller.reset();
    });
  }
}
