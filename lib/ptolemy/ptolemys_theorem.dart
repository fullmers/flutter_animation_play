import 'dart:math';

import 'package:flutter/material.dart';
import 'package:generative_art/animation_controller_buttons.dart';
import 'package:generative_art/ptolemy/fixed_points_for_ptolemy.dart';
import 'package:generative_art/ptolemy/ptolemy_painter.dart';

/// The page which shows an animation illustrating a special case of Ptolemy's theorem
/// Inspired by: https://myfusimotors.com/2019/01/21/ptolemys-theorem-proof/
class PtolemysTheorem extends StatefulWidget {
  const PtolemysTheorem({
    required this.title,
  });

  /// the text to be shown in the app bar
  final String title;

  @override
  _PtolemysTheoremState createState() => _PtolemysTheoremState();
}

class _PtolemysTheoremState extends State<PtolemysTheorem> with SingleTickerProviderStateMixin {
  /// the duration of the animation (that, is the time it takes to go around the given circle once).
  /// Milliseconds.
  final int _periodInMs = 7500;
  static final _animation = Tween<double>();

  late AnimationController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _periodInMs),
    );

    _animation.animate(_controller)
      ..addListener(() {
        // without this , the animation runs but is not visible.
        setState(() {});
      });
  }

  late double _radius;
  late double _dotRadius;
  late double _triangleSide;
  late FixedPointsForPtolemy _fixedPoints;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // context is not available in initState, so these calcs must be done here
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    if (width < height) {
      _radius = width / 3;
    } else {
      _radius = height / 3;
    }
    _triangleSide = _radius * sqrt(3);
    _dotRadius = _radius / 20;
    _fixedPoints = _calculateFixedPoints(width, height);
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
      floatingActionButton: AnimationControllerButtons(
        isPlaying: _isPlaying,
        onPressPlayPause: _playOrPause,
        onPressReset: _reset,
      ),
    );
  }

  void _playOrPause() {
    setState(() {
      if (_isPlaying == false) {
        _controller.repeat();
        _isPlaying = true;
      } else {
        _controller.stop();
        _isPlaying = false;
      }
    });
  }

  void _reset() {
    setState(() {
      _controller.reset();
      _isPlaying = false;
    });
  }

  FixedPointsForPtolemy _calculateFixedPoints(double width, double height) {
    final center = Offset(
      width / 2 - _radius * .1,
      height / 2 - _radius * .1,
    );
    double theta = acos((_triangleSide / 2) / _radius);
    double h = _radius * cos(pi / 2 - theta);
    final pt1 = Offset(center.dx - h, center.dy - _triangleSide / 2); //top left pt
    final pt2 = Offset(center.dx + _radius, center.dy); //pt to right
    final pt3 = Offset(pt1.dx, pt1.dy + _triangleSide); //bottom left pt
    final leftFixedDot = Offset(center.dx + _radius * 1.2, center.dy + _radius);
    final rtFixedDot = Offset(center.dx + _radius * 1.4, center.dy + _radius);
    return FixedPointsForPtolemy(
      center: center,
      leftFixedPt: leftFixedDot,
      rtFixedPt: rtFixedDot,
      refTrianglePt1: pt1,
      refTrianglePt2: pt2,
      refTrianglePt3: pt3,
    );
  }
}
