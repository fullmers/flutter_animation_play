import 'dart:ui';

/// A simple data class for modelling the squares used to construct a fibonacci spiral
class FibonacciSquare {
  const FibonacciSquare({
    required this.square,
    required this.direction,
  });

  /// The square in question. It's position is defined relative to the position of the previous square in the series
  /// and it's direction
  final Rect square;

  /// Each square has a direction so that the subsequent square may be placed correctly relative to it.
  final Direction direction;
}

/// The "direction" of square. Used to determine the position of the subsequent square, as well as the corners used to
/// calculate the path passing through that square
enum Direction { BOTTOM, RIGHT, TOP, LEFT }
