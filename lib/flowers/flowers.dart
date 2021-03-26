import 'dart:math';

import 'package:flutter/material.dart';

import '../animation_controller_buttons.dart';
import 'flower_painter.dart';

/// A page that shows some animated flowers
class Flowers extends StatefulWidget {
  const Flowers({
    required this.title,
    required this.width,
    required this.height,
  });

  /// the text to be shown in the app bar
  final String title;

  final double width;
  final double height;

  @override
  _FlowersState createState() => _FlowersState();
}

class _FlowersState extends State<Flowers> with SingleTickerProviderStateMixin {
  final int durationInMs = 1000;

  late AnimationController _controller;
  bool _isPlaying = false;
  final _random = Random();
  final List<Flower> _flowers = [];

  // beginning and end fields of Tween not needed, since the duration field in the controller provides this
  static final _animation = Tween<double>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: durationInMs),
    );
    _animation.animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    for (var flowerType in FlowerTypes.values) {
      _createFlowers(
        numFlowers: _getNumFlowers(flowerType),
        flowerType: flowerType,
      );
    }
  }

  int _getNumFlowers(FlowerTypes flowerType) {
    switch (flowerType) {
      case FlowerTypes.BigSakura:
        return 10;
      case FlowerTypes.MediumSakura:
        return 30;
      case FlowerTypes.SmallSakura:
        return 40;
    }
  }

  void _createFlowers({
    required int numFlowers,
    required FlowerTypes flowerType,
  }) {
    for (int i = 0; i < numFlowers; i++) {
      Flower flower = Flower(
        flowerType: flowerType,
        center: _makeRandomCenter(),
        vx: _random.nextDouble(),
        vy: _random.nextDouble(),
      );
      _flowers.add(flower);
    }
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
        foregroundPainter: FlowerPainter(
          progress: _controller.value,
          flowers: _flowers,
        ),
        child: Container(
          color: Colors.yellow[50],
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

  Offset _makeRandomCenter() {
    double dx = _random.nextDouble() * widget.width;
    double dy = _random.nextDouble() * widget.height;
    return Offset(dx, dy);
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
}
