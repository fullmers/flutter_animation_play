import 'dart:math';

import 'package:flutter/material.dart';

import '../animation_controller_buttons.dart';
import 'flower_painter.dart';

/// A page that shows some animated flowers
class Flowers extends StatefulWidget {
  const Flowers({
    required this.title,
  });

  /// the text to be shown in the app bar
  final String title;

  @override
  _FlowersState createState() => _FlowersState();
}

class _FlowersState extends State<Flowers> with SingleTickerProviderStateMixin {
  final int durationInMs = 1000;

  late AnimationController _controller;
  bool _isPlaying = false;
  final _random = Random();
  final List<Offset> _largeFlowerCenters = [];
  final List<Offset> _mediumFlowerCenters = [];
  final List<Offset> _smallFlowerCenters = [];

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
  }

  @override
  void didChangeDependencies() {
    print('calling didChangeDependencies');
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final baseNumFlowers = 10;
    _largeFlowerCenters.addAll(_makeRandomCenters(width: width, height: height, numCenters: baseNumFlowers));
    _mediumFlowerCenters.addAll(_makeRandomCenters(width: width, height: height, numCenters: baseNumFlowers * 2));
    _smallFlowerCenters.addAll(_makeRandomCenters(width: width, height: height, numCenters: baseNumFlowers * 10));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('calling build');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomPaint(
        foregroundPainter: FlowerPainter(
          numPetals: 5,
          progress: _controller.value,
          largeFlowerCenters: _largeFlowerCenters,
          mediumFlowerCenters: _mediumFlowerCenters,
          smallFlowerCenters: _smallFlowerCenters,
          referenceR: 10.0,
          referenceCtrlHeight: 100,
        ),
        child: Container(
          color: Colors.pink[100],
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

  List<Offset> _makeRandomCenters({
    required double width,
    required double height,
    required int numCenters,
  }) {
    final List<Offset> centers = [];
    for (int i = 0; i < numCenters; i++) {
      double dx = _random.nextDouble() * width;
      double dy = _random.nextDouble() * height;
      centers.add(Offset(dx, dy));
    }
    return centers;
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
