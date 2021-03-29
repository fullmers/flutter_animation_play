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

  /// the color scheme of the given flower, used to determine petal fill and stroke color, depending on the [flowerType]
  final FlowerColorScheme flowerColorScheme;

  /// number of petals on the given flower. can range from 4-10.
  final int numPetals;

  const Flower({
    required this.seed,
    required this.flowerType,
    required this.flowerColorScheme,
    required this.numPetals,
  });

  Flower copyWith({
    double? vx,
    double? vy,
    Offset? center,
    FlowerSeed? seed,
    FlowerType? flowerType,
    FlowerColorScheme? flowerColorScheme,
    int? numPetals,
  }) {
    return (Flower(
      seed: seed ?? this.seed,
      flowerType: flowerType ?? this.flowerType,
      flowerColorScheme: flowerColorScheme ?? this.flowerColorScheme,
      numPetals: numPetals ?? this.numPetals,
    ));
  }

  /// used the calculate the end control points for the bezier curve defining the flower petals
  double get innerWidthSweep => 2 * pi / numPetals;

  /// used to calculate the inner control points for the bezier curve defining the flower petals
  double get outerWidthDelta => pi / (numPetals * 8);

  /// how big the inner part of the flower is. Depends on the [flowerType]
  double get innerRadius => getInnerRadius(flowerType);

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
  double get ctrlPtHeight => getCtrlPtHeight(flowerType);

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

  /// the color that outlines the flower petals. it is a function of the [flowerColorScheme]
  Color get flowerStrokeColor {
    switch (flowerColorScheme) {
      case FlowerColorScheme.Orange:
        return Colors.orange[100]!;
      case FlowerColorScheme.Blue:
        return Colors.lightBlue[100]!;
      case FlowerColorScheme.Green:
        return Colors.green[100]!;
      case FlowerColorScheme.Pink:
        return Colors.pink[100]!;
      case FlowerColorScheme.Purple:
        return Colors.deepPurple[100]!;
      case FlowerColorScheme.Yellow:
        return Colors.yellow[600]!;
    }
  }

  /// the color for the inside of the flower petals. it is a function of the [flowerType] and [flowerColorScheme]
  Color get petalFillColor {
    final bigColorIndex = 200;
    final mediumColorIndex = 500;
    final smallColorIndex = 800;
    switch (flowerColorScheme) {
      case FlowerColorScheme.Orange:
        switch (flowerType) {
          case FlowerType.BigSakura:
            return Colors.orange[bigColorIndex]!;
          case FlowerType.MediumSakura:
            return Colors.orange[mediumColorIndex]!;
          case FlowerType.SmallSakura:
            return Colors.orange[smallColorIndex]!;
        }
      case FlowerColorScheme.Blue:
        switch (flowerType) {
          case FlowerType.BigSakura:
            return Colors.lightBlue[bigColorIndex]!;
          case FlowerType.MediumSakura:
            return Colors.lightBlue[mediumColorIndex]!;
          case FlowerType.SmallSakura:
            return Colors.lightBlue[smallColorIndex]!;
        }
      case FlowerColorScheme.Green:
        switch (flowerType) {
          case FlowerType.BigSakura:
            return Colors.green[bigColorIndex]!;
          case FlowerType.MediumSakura:
            return Colors.green[mediumColorIndex]!;
          case FlowerType.SmallSakura:
            return Colors.green[smallColorIndex]!;
        }
      case FlowerColorScheme.Pink:
        switch (flowerType) {
          case FlowerType.BigSakura:
            return Colors.pink[bigColorIndex]!;
          case FlowerType.MediumSakura:
            return Colors.pink[mediumColorIndex]!;
          case FlowerType.SmallSakura:
            return Colors.pink[smallColorIndex]!;
        }
      case FlowerColorScheme.Purple:
        switch (flowerType) {
          case FlowerType.BigSakura:
            return Colors.deepPurple[bigColorIndex]!;
          case FlowerType.MediumSakura:
            return Colors.deepPurple[mediumColorIndex]!;
          case FlowerType.SmallSakura:
            return Colors.deepPurple[smallColorIndex]!;
        }
      case FlowerColorScheme.Yellow:
        switch (flowerType) {
          case FlowerType.BigSakura:
            return Colors.yellow[300]!;
          case FlowerType.MediumSakura:
            return Colors.yellow[500]!;
          case FlowerType.SmallSakura:
            return Colors.yellow[700]!;
        }
    }
  }
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
