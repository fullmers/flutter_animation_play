import 'dart:math';

import 'package:flutter/material.dart';

import '../animation_controller_buttons.dart';
import 'color_change_button.dart';
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

  /// current device screen width, in pixels
  final double width;

  /// current device screen height, in pixels
  final double height;

  @override
  _FlowersState createState() => _FlowersState();
}

enum MyControllerState {
  Forward,
  Pause,
  Backward,
}

class _FlowersState extends State<Flowers> with SingleTickerProviderStateMixin {
  final int durationInMs = 7000;
  MyControllerState controllerState = MyControllerState.Pause;

  late AnimationController _controller;
  bool _isPlaying = false;
  FlowerColorScheme _currentColorScheme = FlowerColorScheme.Green;
  final _random = Random();
  final List<Flower> _flowers = [];
  final List<FlowerSeed> _seeds = [];
  final int _numFlowers = 30;
  int _numPetals = 5;

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

    _createSeeds();
    _createFlowers();
  }

  void _createFlowers() {
    _flowers.clear();
    final int numSmallFlowers = _getNumFlowers(FlowerTypes.SmallSakura);
    FlowerTypes type;
    for (int i = 0; i < _seeds.length; i++) {
      if (i < numSmallFlowers) {
        type = FlowerTypes.SmallSakura;
      } else if (i >= numSmallFlowers && i < (numSmallFlowers + _getNumFlowers(FlowerTypes.MediumSakura))) {
        type = FlowerTypes.MediumSakura;
      } else {
        type = FlowerTypes.BigSakura;
      }
      Flower flower = Flower(
        flowerType: type,
        seed: _seeds[i],
        flowerColorScheme: _currentColorScheme,
        numPetals: _numPetals,
      );
      _flowers.add(flower);
    }
  }

  void _createSeeds() {
    for (int i = 0; i < _numFlowers; i++) {
      final center = _makeRandomCenter();
      final mX = _random.nextDouble() * (_random.nextBool() ? 1 : -1);
      final mY = _random.nextDouble() * (_random.nextBool() ? 1 : -1);
      _seeds.add(FlowerSeed(
        center: center,
        mX: mX,
        mY: mY,
      ));
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
          ColorChangeButton(
            buttonColor: Colors.green,
            onTap: () => _changeColor(FlowerColorScheme.Green),
          ),
          const SizedBox(width: 8),
          ColorChangeButton(
            buttonColor: Colors.pink,
            onTap: () => _changeColor(FlowerColorScheme.Pink),
          ),
          const SizedBox(width: 8),
          ColorChangeButton(
            buttonColor: Colors.blue,
            onTap: () => _changeColor(FlowerColorScheme.Blue),
          ),
          const SizedBox(width: 8),
          ColorChangeButton(
            buttonColor: Colors.orange,
            onTap: () => _changeColor(FlowerColorScheme.Orange),
          ),
          const SizedBox(width: 8),
          ColorChangeButton(
            buttonColor: Colors.purple,
            onTap: () => _changeColor(FlowerColorScheme.Purple),
          ),
          const SizedBox(width: 8),
          ColorChangeButton(
            buttonColor: Colors.yellow,
            onTap: () => _changeColor(FlowerColorScheme.Yellow),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            child: Icon(Icons.add),
            onPressed: () => setState(() {
              if (_numPetals <= 12) {
                _numPetals++;
                _createFlowers();
              }
            }),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            child: Icon(Icons.remove),
            onPressed: () => setState(() {
              if (_numPetals > 4) {
                _numPetals--;
                _createFlowers();
              }
            }),
          ),
        ],
      ),
    );
  }

  void _changeColor(FlowerColorScheme flowerColorScheme) {
    setState(() {
      if (_isPlaying) {
        _controller.stop();
        _currentColorScheme = flowerColorScheme;
        _createFlowers();
        _controller.repeat();
      } else {
        _currentColorScheme = flowerColorScheme;
        _createFlowers();
      }
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
      _seeds.clear();
      _createSeeds();
      _createFlowers();
    });
  }
}
