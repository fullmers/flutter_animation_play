import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:generative_art/flowers/controller_flower_colors.dart';
import 'package:generative_art/flowers/controller_petal_number.dart';
import 'package:generative_art/flowers/controller_wave_colors.dart';
import 'package:generative_art/flowers/wave_painter.dart';

import 'controller_top.dart';
import 'flower.dart';
import 'single_flower_painter.dart';

/// A page that shows some animated flowers
class FloatingFlowers extends StatefulWidget {
  const FloatingFlowers({
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
  _FloatingFlowersState createState() => _FloatingFlowersState();
}

const int minNumPetals = 4;
const int maxNumPetals = 10;

class _FloatingFlowersState extends State<FloatingFlowers> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final _random = Random();
  final List<Flower> _flowers = [];
  final List<FlowerSeed> _seeds = [];
  final int _numFlowers = 18;
  final int _durationInMs = 5000;
  late double _openControlBarHeight = 200;
  final double _toolBarHeight = 50;

  // defaults when the page appears
  Color _waveColor = Colors.green[100]!;
  int _numPetals = 5;
  bool _isPlaying = false;
  bool _isControllerOpen = true;
  late int _extraPaddingOpen;
  late int _extraPaddingClosed;
  FlowerColorScheme _currentColorScheme = FlowerColorScheme.Green;

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
      })
      ..addListener(() {
        if (_controller.status == AnimationStatus.forward) {
          _updateFlowerPositions(true);
        }
        if (_controller.status == AnimationStatus.reverse) {
          _updateFlowerPositions(false);
        }
      })
      ..addStatusListener((status) {
        /// keep the animation running forward and reversed, in a loop:
        if (_controller.status == AnimationStatus.completed) {
          _controller.reverse();
        }
        if (_controller.status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _createSeeds();
    _createFlowers();

    // todo find a cleaner way to do this:
    if (Platform.isAndroid) {
      _extraPaddingOpen = 24;
      _extraPaddingClosed = 24;
    } else {
      _extraPaddingOpen = 0;
      _extraPaddingClosed = 0;
    }
  }

  void _createSeeds() {
    for (int i = 0; i < _numFlowers; i++) {
      final center = _makeRandomCenter();
      final mX = _random.nextDouble() * (_random.nextBool() ? 1 : -1);
      final mY = _random.nextDouble() * (_random.nextBool() ? 1 : -1);
      _seeds.add(
        FlowerSeed(
          center: center,
          mX: mX,
          mY: mY,
        ),
      );
    }
  }

  Offset _makeRandomCenter() {
    double dx = _random.nextDouble() * widget.width;
    double dy = _random.nextDouble() * widget.height - _openControlBarHeight;
    return Offset(dx, dy);
  }

  void _createFlowers() {
    _flowers.clear();
    for (int i = 0; i < _seeds.length; i++) {
      final flower = Flower(
        flowerType: _getFlowerType(i),
        seed: _seeds[i],
      );
      _flowers.add(flower);
    }
  }

  FlowerType _getFlowerType(int i) {
    final int numBigFlowers = (_numFlowers / 6).floor();
    final int numMediumFlowers = numBigFlowers * 2;
    final int numSmallFlowers = _numFlowers - numMediumFlowers - numBigFlowers;
    if (i < numSmallFlowers) {
      return FlowerType.SmallSakura;
    } else if (i >= numSmallFlowers && i < (numSmallFlowers + numMediumFlowers)) {
      return FlowerType.MediumSakura;
    } else {
      return FlowerType.BigSakura;
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
        elevation: 0,
        toolbarHeight: _toolBarHeight,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              CustomPaint(
                painter: WavePainter(waveColor: _waveColor),
                child: Container(
                  height: _isControllerOpen
                      ? MediaQuery.of(context).size.height - (_toolBarHeight + _extraPaddingOpen)
                      : MediaQuery.of(context).size.height - (_toolBarHeight + _extraPaddingClosed),
                ),
              ),
              for (var flower in _flowers)
                CustomPaint(
                  painter: SingleFlowerPainter(
                    flower: flower,
                    colorScheme: _currentColorScheme,
                    numPetals: _numPetals,
                  ),
                ),
              Positioned(
                bottom: 0,
                child: _buildController(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildController(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 8, 0, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ControllerTop(
              isPlaying: _isPlaying,
              playOrPause: _playOrPause,
              reset: _reset,
              isControllerOpen: _isControllerOpen,
              openOrCloseController: _openOrClose,
            )
          ]..addAll(_isControllerOpen ? _openControllerBottom() : []),
        ),
      ),
    );
  }

  List<Widget> _openControllerBottom() => [
        const SizedBox(height: 8),
        ControllerPetalNumber(
          changePetalNumber: _changePetalNumber,
        ),
        const SizedBox(height: 8),
        ControllerFlowerColors(
          changeColor: _changeFlowerColor,
        ),
        const SizedBox(height: 8),
        ControllerWaveColors(
          changeWaveColor: _changeWaveColor,
        )
      ];

  void _changePetalNumber(bool isIncreasing) {
    setState(() {
      if (isIncreasing) {
        if (_numPetals <= maxNumPetals) {
          _numPetals++;
          _createFlowers();
        }
      } else {
        if (_numPetals > minNumPetals) {
          _numPetals--;
          _createFlowers();
        }
      }
    });
  }

  void _openOrClose() {
    setState(() {
      _isControllerOpen = !_isControllerOpen;
    });
  }

  void _changeWaveColor(Color color) {
    setState(() {
      _waveColor = color;
    });
  }

  void _changeFlowerColor(FlowerColorScheme flowerColorScheme) {
    setState(() {
      _currentColorScheme = flowerColorScheme;
    });
  }

  void _playOrPause() {
    setState(() {
      if (_isPlaying) {
        _controller.stop();
      } else {
        _controller.repeat();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _updateFlowerPositions(bool isForward) {
    final scaleFactor = 3500;
    int i = 0;
    for (var flower in _flowers) {
      final dx = scaleFactor * flower.seed.mX / _durationInMs;
      final dy = scaleFactor * flower.seed.mY / _durationInMs;
      Offset newCenter;
      if (isForward) {
        newCenter = flower.seed.center + Offset(dx, dy);
      } else {
        newCenter = flower.seed.center - Offset(dx, dy);
      }
      final newSeed = flower.seed.copyWith(center: newCenter);
      _flowers[i] = flower.copyWith(seed: newSeed);
      i++;
    }
  }

  void _reset() {
    setState(() {
      _seeds.clear();
      _createSeeds();
      _createFlowers();
      _controller.reset();
      _controller.stop();
      _isPlaying = false;
    });
  }
}
