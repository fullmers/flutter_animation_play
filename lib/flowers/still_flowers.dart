import 'dart:math';

import 'package:animaplay/flowers/wave_painter.dart';
import 'package:flutter/material.dart';

import 'color_change_button.dart';
import 'controller_top.dart';
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

class _StillFlowersState extends State<StillFlowers> with SingleTickerProviderStateMixin {
  final _random = Random();
  final List<Flower> _flowers = [];
  final List<FlowerSeed> _seeds = [];
  final int _numFlowers = 16;
  late double _openControlBarHeight = 240;
  late double _minControlBarHeight = 56;
  final double _toolBarHeight = 50;
  Color _waveColor = Colors.green[100]!;

  int _numPetals = 5;
  bool _isControllerOpen = true;
  FlowerColorScheme _currentColorScheme = FlowerColorScheme.Green;

  @override
  void initState() {
    super.initState();
    _createSeeds();
    _createFlowers();
  }

  void _createSeeds() {
    for (int i = 0; i < _numFlowers; i++) {
      final center = _makeRandomCenter();
      //final center = _makeCenterPoint();
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
    double dy = _random.nextDouble() * widget.height + _toolBarHeight; //(widget.height - _toolBarHeight - 70);
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
  void dispose() {
    //  _controller.dispose();
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
                  ? MediaQuery.of(context).size.height - (_toolBarHeight + _openControlBarHeight + 24)
                  : MediaQuery.of(context).size.height - (_toolBarHeight + _minControlBarHeight + 24),
            ),
          ),
          _isControllerOpen
              ? Container(
                  color: Colors.white,
                  height: _openControlBarHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ControllerTop(
                        minHeight: _minControlBarHeight,
                        openHeight: _openControlBarHeight,
                        reset: _reset,
                        isControllerOpen: _isControllerOpen,
                        openOrCloseController: _openOrClose,
                      ),
                      //   const SizedBox(height: 8),
                      Row(children: [
                        const SizedBox(width: 30),
                        Text('PETALS'),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          child: Icon(Icons.add),
                          onPressed: () => setState(() {
                            if (_numPetals <= maxNumPetals) {
                              _numPetals++;
                              _createFlowers();
                            }
                          }),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          child: Icon(Icons.remove),
                          onPressed: () => setState(() {
                            if (_numPetals > minNumPetals) {
                              _numPetals--;
                              _createFlowers();
                            }
                          }),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const SizedBox(width: 30),
                          Text('FLOWERS'),
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
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(children: [
                        const SizedBox(width: 30),
                        Text('WAVES'),
                        const SizedBox(width: 8),
                        ColorChangeButton(
                          buttonColor: Colors.green[100]!,
                          onTap: () => _changeWaveColor(Colors.green[100]!),
                        ),
                        const SizedBox(width: 8),
                        ColorChangeButton(
                          buttonColor: Colors.pink[100]!,
                          onTap: () => _changeWaveColor(Colors.pink[100]!),
                        ),
                        const SizedBox(width: 8),
                        ColorChangeButton(
                          buttonColor: Colors.lightBlue[100]!,
                          onTap: () => _changeWaveColor(Colors.lightBlue[100]!),
                        ),
                        const SizedBox(width: 8),
                        ColorChangeButton(
                          buttonColor: Colors.orange[100]!,
                          onTap: () => _changeWaveColor(Colors.orange[100]!),
                        ),
                        const SizedBox(width: 8),
                        ColorChangeButton(
                          buttonColor: Colors.deepPurple[100]!,
                          onTap: () => _changeWaveColor(Colors.deepPurple[100]!),
                        ),
                        const SizedBox(width: 8),
                        ColorChangeButton(
                          buttonColor: Colors.amberAccent[100]!,
                          onTap: () => _changeWaveColor(Colors.amberAccent[100]!),
                        ),
                      ]),
                      //    const SizedBox(height: 8)
                    ],
                  ),
                )
              : ControllerTop(
                  openHeight: _openControlBarHeight,
                  minHeight: _minControlBarHeight,
                  reset: _reset,
                  isControllerOpen: _isControllerOpen,
                  openOrCloseController: _openOrClose,
                ),
        ],
      ),
    );
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

  void _changeColor(FlowerColorScheme flowerColorScheme) {
    setState(() {
      _currentColorScheme = flowerColorScheme;
      _createFlowers();
    });
  }

  void _reset() {
    setState(() {
      _seeds.clear();
      _createSeeds();
      _createFlowers();
      print('numFlowers: ${_seeds.length}');
    });
  }
}
