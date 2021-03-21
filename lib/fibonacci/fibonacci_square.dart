import 'dart:ui';

class FibonacciSquare {
  const FibonacciSquare({
    required this.fibNumber,
    required this.square,
    required this.direction,
  });

  final Rect square;
  final Direction direction;
  final int fibNumber;
}

enum Direction { BOTTOM, RIGHT, TOP, LEFT }
