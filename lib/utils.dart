import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

final List<Color> palette = [
  Colors.red[500]!,
  Colors.redAccent[700]!,
  Colors.green[500]!,
  Colors.lightGreen[300]!,
  Colors.deepPurpleAccent,
  Colors.deepPurple[200]!,
  Colors.blueAccent[200]!,
  Colors.blueAccent[100]!,
  Colors.orangeAccent,
  Colors.orangeAccent[700]!,
];

final _random = Random();

Color getRandomColor() => palette[_random.nextInt(palette.length)].withOpacity(_random.nextDouble());

Offset getRandomCenter(Size screenSize) {
  double dx = _random.nextDouble() * screenSize.width;
  double dy = _random.nextDouble() * screenSize.height;
  return Offset(dx, dy);
}

int getPosOrNegOne() => _random.nextBool() ? 1 : -1;
