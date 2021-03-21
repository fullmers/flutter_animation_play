import 'dart:ui';

class FibonacciSquare {
  const FibonacciSquare({
    required this.fibNumber,
    required this.rect,
    required this.direction,
  });

  final Rect rect;
  final Direction direction;
  final int fibNumber;
}

enum Direction { BOTTOM, RIGHT, TOP, LEFT }
