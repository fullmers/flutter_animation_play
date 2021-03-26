import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Flower {
  final double vx;
  final double vy;
  final Offset center;
  final FlowerTypes flowerType;
  final FlowerColorScheme flowerColorScheme;

  double get innerWidthSweep => 2 * pi / numPetals;

  double get outerWidthDelta => pi / (numPetals * 8);

  double get innerRadius {
    switch (flowerType) {
      case FlowerTypes.BigSakura:
        return 12;
      case FlowerTypes.MediumSakura:
        return 8;
      case FlowerTypes.SmallSakura:
        return 4;
    }
  }

  Color get flowerStrokeColor {
    switch (flowerColorScheme) {
      case FlowerColorScheme.Orange:
        return Colors.orange[50]!;
      case FlowerColorScheme.Blue:
        return Colors.lightBlue[50]!;
      case FlowerColorScheme.Green:
        return Colors.green[50]!;
      case FlowerColorScheme.Pink:
        return Colors.pink[50]!;
      case FlowerColorScheme.Purple:
        return Colors.deepPurple[50]!;
    }
  }

  Color get color {
    final bigColorIndex = 200;
    final mediumColorIndex = 500;
    final smallColorIndex = 800;
    switch (flowerColorScheme) {
      case FlowerColorScheme.Orange:
        switch (flowerType) {
          case FlowerTypes.BigSakura:
            return Colors.orange[bigColorIndex]!;
          case FlowerTypes.MediumSakura:
            return Colors.orange[mediumColorIndex]!;
          case FlowerTypes.SmallSakura:
            return Colors.orange[smallColorIndex]!;
        }
      case FlowerColorScheme.Blue:
        switch (flowerType) {
          case FlowerTypes.BigSakura:
            return Colors.lightBlue[bigColorIndex]!;
          case FlowerTypes.MediumSakura:
            return Colors.lightBlue[mediumColorIndex]!;
          case FlowerTypes.SmallSakura:
            return Colors.lightBlue[smallColorIndex]!;
        }
      case FlowerColorScheme.Green:
        switch (flowerType) {
          case FlowerTypes.BigSakura:
            return Colors.green[bigColorIndex]!;
          case FlowerTypes.MediumSakura:
            return Colors.green[mediumColorIndex]!;
          case FlowerTypes.SmallSakura:
            return Colors.green[smallColorIndex]!;
        }
      case FlowerColorScheme.Pink:
        switch (flowerType) {
          case FlowerTypes.BigSakura:
            return Colors.pink[bigColorIndex]!;
          case FlowerTypes.MediumSakura:
            return Colors.pink[mediumColorIndex]!;
          case FlowerTypes.SmallSakura:
            return Colors.pink[smallColorIndex]!;
        }
      case FlowerColorScheme.Purple:
        switch (flowerType) {
          case FlowerTypes.BigSakura:
            return Colors.deepPurple[bigColorIndex]!;
          case FlowerTypes.MediumSakura:
            return Colors.deepPurple[mediumColorIndex]!;
          case FlowerTypes.SmallSakura:
            return Colors.deepPurple[smallColorIndex]!;
        }
    }
  }

  double get ctrlPtHeight {
    switch (flowerType) {
      case FlowerTypes.BigSakura:
        return 100;
      case FlowerTypes.MediumSakura:
        return 80;
      case FlowerTypes.SmallSakura:
        return 50;
    }
  }

  //todo update this when you have more types
  int get numPetals {
    return 5;
  }

  const Flower({
    required this.center,
    required this.vx,
    required this.vy,
    required this.flowerType,
    required this.flowerColorScheme,
  });
}

enum FlowerTypes {
  SmallSakura,
  MediumSakura,
  BigSakura,
}

enum FlowerColorScheme { Orange, Blue, Green, Pink, Purple }
