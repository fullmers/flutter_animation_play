import 'dart:math';

import 'package:flutter/material.dart';

import '../animation_controller_buttons.dart';
import 'flower.dart';
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
  final int durationInMs = 7000;

  late AnimationController _controller;
  bool _isPlaying = false;
  FlowerColorScheme _currentColorScheme = FlowerColorScheme.Green;
  final _random = Random();
  final List<Flower> _flowers = [];
  final List<Offset> _centers = [];
  final int _numFlowers = 6;

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

    _createCenters();
    _createFlowers();
  }

  void _createFlowers() {
    _flowers.clear();
    final int numSmallFlowers = _getNumFlowers(FlowerTypes.SmallSakura);
    FlowerTypes type;
    for (int i = 0; i < _centers.length; i++) {
      if (i < numSmallFlowers) {
        type = FlowerTypes.SmallSakura;
      } else if (i >= numSmallFlowers && i < (numSmallFlowers + _getNumFlowers(FlowerTypes.MediumSakura))) {
        type = FlowerTypes.MediumSakura;
      } else {
        type = FlowerTypes.BigSakura;
      }
      Flower flower = Flower(
        flowerType: type,
        center: _centers[i],
        vx: _random.nextDouble() * _flipCoin(),
        vy: _random.nextDouble() * _flipCoin(),
        flowerColorScheme: _currentColorScheme,
      );
      _flowers.add(flower);
    }
  }

  int _flipCoin() {
    if (_random.nextBool()) {
      return 1;
    } else {
      return -1;
    }
  }

  void _createCenters() {
    for (int i = 0; i < _numFlowers; i++) {
      _centers.add(_makeRandomCenter());
    }
  }

  int _getNumFlowers(FlowerTypes flowerType) {
    final int numBigFlowers = (_numFlowers / 6).floor();
    final int numMediumFlowers = numBigFlowers * 2;
    final int numSmallFlowers = _numFlowers - numMediumFlowers - numBigFlowers;
    switch (flowerType) {
      case FlowerTypes.BigSakura:
        return numBigFlowers;
      case FlowerTypes.MediumSakura:
        return numMediumFlowers;
      case FlowerTypes.SmallSakura:
        return numSmallFlowers;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  print('controller value: ${_controller.value}');
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
      floatingActionButton: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: AnimationControllerButtons(
              isPlaying: _isPlaying,
              onPressPlayPause: _playOrPause,
              onPressReset: _reset,
            ),
          ),
          const SizedBox(width: 8),
          _makeColorChangeButton(FlowerColorScheme.Green, Colors.green),
          const SizedBox(width: 8),
          _makeColorChangeButton(FlowerColorScheme.Pink, Colors.pink),
          const SizedBox(width: 8),
          _makeColorChangeButton(FlowerColorScheme.Blue, Colors.blue),
          const SizedBox(width: 8),
          _makeColorChangeButton(FlowerColorScheme.Orange, Colors.orange),
          const SizedBox(width: 8),
          _makeColorChangeButton(FlowerColorScheme.Purple, Colors.purple),
          const SizedBox(width: 8),
          _makeColorChangeButton(FlowerColorScheme.Yellow, Colors.yellow),
        ],
      ),
    );
  }

  Widget _makeColorChangeButton(FlowerColorScheme scheme, Color color) {
    return InkWell(
      child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: color,
          )),
      onTap: () => _changeColor(scheme),
    );
  }

  void _changeColor(FlowerColorScheme flowerColorScheme) {
    double oldProgress = _controller.value;
    setState(() {
      if (_isPlaying) {
        _controller.stop();
        _currentColorScheme = flowerColorScheme;
        _createFlowers();
        _controller.repeat();
      } else {
        _currentColorScheme = flowerColorScheme;
        _createFlowers();
        //_controller.repeat();
      }
      //_controller.value = oldProgress;
    });
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
      _centers.clear();
      _createCenters();
      _createFlowers();
    });
  }
}
