import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../animation_controller_buttons.dart';
import '../utils.dart';
import 'firework.dart';
import 'fireworks_painter.dart';

/// A page that shows exploding fireworks
class Fireworks extends StatefulWidget {
  const Fireworks({
    required this.title,
  });

  /// the text to be shown in the app bar
  final String title;

  @override
  _FireworksState createState() => _FireworksState();
}

class _FireworksState extends State<Fireworks> with SingleTickerProviderStateMixin {
  /// the duration of the animation (that, is the time it takes to draw the spiral).
  /// Milliseconds.
  final int _durationInMs = 5000;

  late AnimationController _controller;
  final List<Firework> fireworks = [];
  bool _isPlaying = false;
  late Size screenSize;

  // beginning and end fields of Tween not needed, since the duration field in the controller provides this
  static final _animation = Tween<double>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _durationInMs),
    );
    _animation.animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didChangeDependencies() {
    screenSize = MediaQuery.of(context).size;
    _createFireworks();
    super.didChangeDependencies();
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
      body: CustomPaint(
        foregroundPainter: FireworksPainter(
          fireworks: fireworks,
          progress: _controller.value,
          totalDuration: _durationInMs.toDouble(),
        ),
        child: Container(
          color: Colors.black87,
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: AnimationControllerButtons(
          isPlaying: _isPlaying,
          onPressPlayPause: _playOrPause,
          onPressReset: _reset,
        ),
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
      _createFireworks();
      _controller.reset();
      _isPlaying = false;
    });
  }

  void _createFireworks() {
    fireworks.clear();
    final _random = Random();
    final minArms = 12;
    final minRadius = 10;

    final numFireworks = 30;

    for (int i = 0; i < numFireworks; i++) {
      final r = minRadius + _random.nextDouble() * 50;
      final armCount = (minArms + _random.nextDouble() * minArms).floor();
      final center = getRandomCenter(screenSize);
      final endpoints = _createEndPoints(
        numArms: armCount,
        r: r,
        center: center,
      );
      final pathMetrics = _createPathMetrics(
        center,
        endpoints,
      );
      Firework firework = Firework(
        center: center,
        r: r,
        color: getRandomColor(),
        startTime: _random.nextDouble(),
        duration: 1000, //2000.0 * _random.nextDouble() + 2000,
        numArms: armCount,
        endPoints: endpoints,
        pathMetrics: pathMetrics,
      );
      fireworks.add(firework);
    }
  }

  List<Offset> _createEndPoints({
    required int numArms,
    required Offset center,
    required double r,
  }) {
    List<Offset> endPoints = [];
    final delta = 2 * pi / numArms;
    for (double theta = 0; theta <= 2 * pi; theta = theta + delta) {
      final epsilon = Random().nextDouble() * delta / 5 * getPosOrNegOne();
      final alteredR = r * (Random().nextDouble() + .9);
      final endPt = center + Offset(alteredR * cos(theta + epsilon), alteredR * sin(theta + epsilon));
      endPoints.add(endPt);
    }
    return endPoints;
  }

  List<PathMetric> _createPathMetrics(Offset center, List<Offset> endPoints) {
    final start = center;
    final path = Path();
    final List<Path> paths = [];
    for (int i = 0; i < endPoints.length; i++) {
      path.moveTo(start.dx, start.dy);
      path.lineTo(endPoints[i].dx, endPoints[i].dy);
    }

    List<PathMetric> pathMetrics = path.computeMetrics().toList(growable: true);
    for (int i = 0; i < pathMetrics.length; i++) {
      final pathMetric = pathMetrics[i];
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length,
      );
      paths.add(extractPath);
    }
    return pathMetrics;
  }
}
