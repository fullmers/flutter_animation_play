import 'dart:math';

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
  late AnimationController _controller;
  final _triangleSide = 240.0;
  final _dotRadius = 10.0;
  late double _radius;

  static final _animation = Tween<double>(
    begin: 0,
    end: period * 1.0,
  );
  late Offset _center;
  late Offset _leftFixedDot;
  late Offset _rtFixedDot;

  @override
  void initState() {
    super.initState();
    _radius = _triangleSide / sqrt(3);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: period),
      reverseDuration: Duration(seconds: period),
    );
    _animation.animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // context is not available in initState, so these calcs must be done here
    _center = Offset(
      MediaQuery.of(context).size.width / 2 - _radius * .1,
      MediaQuery.of(context).size.height / 2 - 100,
    );
    _leftFixedDot = Offset(_center.dx + _radius * 1.2, _center.dy + _radius);
    _rtFixedDot = Offset(_center.dx + _radius * 1.4, _center.dy + _radius);
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
        //   color: Colors.lightBlueAccent,
        child: CustomPaint(
          foregroundPainter: PtolemyPainter(
            center: _center,
            leftFixedDot: _leftFixedDot,
            rtFixedDot: _rtFixedDot,
            triangleSide: _triangleSide,
            radius: _radius,
            dotRadius: _dotRadius,
            progress: _controller.value,
            period: period,
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
              label: 'reset',
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
                child: Icon(Icons.play_arrow),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Semantics(
              label: 'reverse',
              child: ElevatedButton(
                onPressed: _reverse,
                child: Icon(Icons.fast_rewind_rounded),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Semantics(
              label: 'pause',
              child: ElevatedButton(
                onPressed: _pause,
                child: Icon(Icons.pause),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _play() {
    setState(() {
      _controller.repeat();
    });
  }

  void _reset() {
    setState(() {
      _controller.reset();
    });
  }

  void _reverse() {
    setState(() {
      _controller.reverse();
    });
  }

  void _pause() {
    setState(() {
      _controller.stop();
    });
  }
}
