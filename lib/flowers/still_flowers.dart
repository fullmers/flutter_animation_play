import 'dart:io';
import 'dart:math';

import 'package:animaplay/flowers/wave_painter.dart';
import 'package:flutter/material.dart';

import 'controller_flower_colors.dart';
import 'controller_petal_number.dart';
import 'controller_top.dart';
import 'controller_wave_colors.dart';
import 'flower.dart';
import 'flower_painter.dart';

/// A page that shows some randomly generated flowers as still images
class StillFlowers extends StatefulWidget {
  const StillFlowers({
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
  _StillFlowersState createState() => _StillFlowersState();
}

const int minNumPetals = 4;
const int maxNumPetals = 10;

class _StillFlowersState extends State<StillFlowers> {
  final _random = Random();
  final List<Flower> _flowers = [];
  final List<FlowerSeed> _seeds = [];
  final int _numFlowers = 16;
  late double _openControlBarHeight = 240;
  final double _toolBarHeight = 50;
  Color _waveColor = Colors.green[100]!;

  int _numPetals = 5;
  bool _isControllerOpen = true;
  FlowerColorScheme _currentColorScheme = FlowerColorScheme.Green;
  late double _extraPaddingOpen;
  late double _extraPaddingClosed;
  @override
  void initState() {
    super.initState();
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
    _extraPaddingOpen = _extraPaddingOpen + _toolBarHeight;
    _extraPaddingClosed = _extraPaddingClosed + _toolBarHeight;
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

  Offset _makeRandomCenter() {
    double dx = _random.nextDouble() * widget.width;
    double dy = _random.nextDouble() * widget.height - _openControlBarHeight;
    return Offset(dx, dy);
  }

  void _createFlowers() {
    _flowers.clear();
    for (int i = 0; i < _seeds.length; i++) {
      Flower flower = Flower(
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
                foregroundPainter: FlowerPainter(
                  progress: 0,
                  flowers: _flowers,
                  colorScheme: _currentColorScheme,
                  numPetals: _numPetals,
                ),
                painter: WavePainter(waveColor: _waveColor),
                child: Container(
                  height: _isControllerOpen
                      ? MediaQuery.of(context).size.height - (_extraPaddingOpen)
                      : MediaQuery.of(context).size.height - (_extraPaddingClosed),
                ),
              ),
              Positioned(
                bottom: 0,
                child: _buildController(),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildController() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 8, 0, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ControllerTop(
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
      _createFlowers();
    });
  }

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

  void _reset() {
    setState(() {
      _seeds.clear();
      _createSeeds();
      _createFlowers();
    });
  }
}
