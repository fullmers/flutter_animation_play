import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// [FlowerSeed] contains position and direction data for a [Flower] (particle)
class FlowerSeed {
  final double mX;
  final double mY;
  final Offset center;

  const FlowerSeed({
    required this.center,
    required this.mX,
    required this.mY,
  });

  FlowerSeed copyWith({
    double? mX,
    double? mY,
    Offset? center,
  }) {
    return FlowerSeed(
      center: center ?? this.center,
      mY: mY ?? this.mY,
      mX: mX ?? this.mX,
    );
  }
}

/// [Flower] bundles the positional data of a flower particle with it's appearance. It is used for painting flowers in
/// [FlowerPainter].

class Flower {
  /// the [seed] contains the position and direction data of the flower. This should not change.
  final FlowerSeed seed;

  /// The [flowerType] describes which kind of flower is being drawn. This is used to determine appearance variables such
  /// as inner radius and petal height
  final FlowerType flowerType;

  const Flower({
    required this.seed,
    required this.flowerType,
  });

  /// how big the inner part of the flower is. Depends on the [flowerType]
  static double getInnerRadius(FlowerType flowerType) {
    switch (flowerType) {
      case FlowerType.BigSakura:
        return 10;
      case FlowerType.MediumSakura:
        return 6;
      case FlowerType.SmallSakura:
        return 3;
    }
  }

  /// the bezier control point height used to calculate the petal curve. It is determined by the [flowerType]
  static double getCtrlPtHeight(FlowerType flowerType) {
    switch (flowerType) {
      case FlowerType.BigSakura:
        return 120;
      case FlowerType.MediumSakura:
        return 80;
      case FlowerType.SmallSakura:
        return 40;
    }
  }

  static double getInnerSweep(int numPetals) => 2 * pi / numPetals;

  static double outerWidthDelta(int numPetals) => pi / (numPetals * 8);
}

/// [FlowerType] is used to determine the shape of the flower (size and petal shape)
enum FlowerType {
  SmallSakura,
  MediumSakura,
  BigSakura,
}

/// A simple theme for the flowers. If the flowers have an "Orange" color scheme, for example, they will all
/// be colored some variant of Colors.Orange, depending on their size.
enum FlowerColorScheme {
  Orange,
  Blue,
  Green,
  Pink,
  Purple,
  Yellow,
}

class FlowerTheme {
  final FlowerType type;
  final FlowerColorScheme colorScheme;

  FlowerTheme({
    required this.type,
    required this.colorScheme,
  });

  Color get flowerStrokeColor {
    switch (colorScheme) {
      case FlowerColorScheme.Orange:
        return Colors.orange[100]!;
      case FlowerColorScheme.Blue:
        return Colors.lightBlue[50]!;
      case FlowerColorScheme.Green:
        return Colors.lightGreen[50]!;
      case FlowerColorScheme.Pink:
        return Colors.pink[50]!;
      case FlowerColorScheme.Purple:
        return Colors.deepPurpleAccent[100]!;
      case FlowerColorScheme.Yellow:
        return Colors.yellow[600]!;
    }
  }

  Color get petalFillColor {
    {
      switch (colorScheme) {
        case FlowerColorScheme.Orange:
          switch (type) {
            case FlowerType.BigSakura:
              return Colors.orange[200]!;
            case FlowerType.MediumSakura:
              return Colors.orange[400]!;
            case FlowerType.SmallSakura:
              return Colors.orange[700]!;
          }
        case FlowerColorScheme.Blue:
          switch (type) {
            case FlowerType.BigSakura:
              return Colors.lightBlue[100]!;
            case FlowerType.MediumSakura:
              return Colors.lightBlue[300]!;
            case FlowerType.SmallSakura:
              return Colors.lightBlue[700]!;
          }
        case FlowerColorScheme.Green:
          switch (type) {
            case FlowerType.BigSakura:
              return Colors.green[200]!;
            case FlowerType.MediumSakura:
              return Colors.green[400]!;
            case FlowerType.SmallSakura:
              return Colors.green[700]!;
          }
        case FlowerColorScheme.Pink:
          switch (type) {
            case FlowerType.BigSakura:
              return Colors.pink[100]!;
            case FlowerType.MediumSakura:
              return Colors.pink[200]!;
            case FlowerType.SmallSakura:
              return Colors.pink[300]!;
          }
        case FlowerColorScheme.Purple:
          switch (type) {
            case FlowerType.BigSakura:
              return Colors.deepPurple[100]!;
            case FlowerType.MediumSakura:
              return Colors.deepPurple[300]!;
            case FlowerType.SmallSakura:
              return Colors.deepPurple[700]!;
          }
        case FlowerColorScheme.Yellow:
          switch (type) {
            case FlowerType.BigSakura:
              return Colors.yellow[100]!;
            case FlowerType.MediumSakura:
              return Colors.yellow[300]!;
            case FlowerType.SmallSakura:
              return Colors.yellow[500]!;
          }
      }
    }
  }
}
