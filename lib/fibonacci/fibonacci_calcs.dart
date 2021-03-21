import 'dart:ui';

import 'FibonacciSquare.dart';
import 'fibonacci_spiral.dart';

class FibonacciCalcs {
  static List<FibonacciSquare> buildFibRects(Offset startCenter) {
    final fibNumbers = _calculateFibNumbers();
    final initRects = _buildInitFibRects(startCenter);
    return _buildFibRectSequence(fibNumbers, initRects);
  }

  static List<int> _calculateFibNumbers() {
    final fibNumbers = [1, 1];
    for (var i = 0; i < sequenceLength; i++) {
      final nextFib = fibNumbers[fibNumbers.length - 1] + fibNumbers[fibNumbers.length - 2];
      fibNumbers.add(nextFib);
    }
    return fibNumbers;
  }

  static List<FibonacciSquare> _buildInitFibRects(Offset startCenter) {
    List<FibonacciSquare> initFibRects = [];
    FibonacciSquare firstRect = FibonacciSquare(
      fibNumber: 1,
      rect: Rect.fromCenter(
        center: startCenter,
        width: scaleFactor,
        height: scaleFactor,
      ),
      direction: Direction.LEFT,
    );
    FibonacciSquare secondRect = FibonacciSquare(
      fibNumber: 1,
      rect: Rect.fromCenter(
        center: Offset(startCenter.dx, startCenter.dy + scaleFactor),
        width: scaleFactor,
        height: scaleFactor,
      ),
      direction: Direction.BOTTOM,
    );
    initFibRects.add(firstRect);
    initFibRects.add(secondRect);
    return initFibRects;
  }

  static List<FibonacciSquare> _buildFibRectSequence(List<int> fibSequence, List<FibonacciSquare> initFibRects) {
    List<FibonacciSquare> fibRects = initFibRects;
    for (var i = 2; i < fibSequence.length; i++) {
      final currentRect = fibRects[i - 1];
      final newFibNumber = fibSequence[i];
      final newLength = newFibNumber * scaleFactor;
      final newCenter = FibonacciCalcs._nextCenter(
        lastFibNum: fibSequence[i - 1],
        lastLastFibNum: fibSequence[i - 2],
        lastFibRect: fibRects[i - 1],
      );
      final nextFibRect = FibonacciSquare(
        fibNumber: newFibNumber,
        direction: FibonacciCalcs._getNextDirection(currentRect.direction),
        rect: Rect.fromCenter(
          center: newCenter,
          width: newLength,
          height: newLength,
        ),
      );
      fibRects.add(nextFibRect);
    }
    return fibRects;
  }

  static Direction _getNextDirection(Direction currentDir) {
    switch (currentDir) {
      case Direction.BOTTOM:
        return Direction.RIGHT;
      case Direction.RIGHT:
        return Direction.TOP;
      case Direction.TOP:
        return Direction.LEFT;
      case Direction.LEFT:
        return Direction.BOTTOM;
    }
  }

  static Offset _nextCenter({
    required int lastFibNum,
    required int lastLastFibNum,
    required FibonacciSquare lastFibRect,
  }) {
    double dxOffset;
    double dyOffset;
    int nextFibNum = lastFibNum + lastLastFibNum;
    Offset center = lastFibRect.rect.center;
    Direction nextDirection = _getNextDirection(lastFibRect.direction);

    switch (nextDirection) {
      case Direction.BOTTOM:
        dxOffset = center.dx + scaleFactor * lastLastFibNum / 2;
        dyOffset = center.dy + scaleFactor * (lastFibNum + nextFibNum) / 2;
        break;
      case Direction.RIGHT:
        dxOffset = center.dx + scaleFactor * (lastFibNum + nextFibNum) / 2;
        final tempPrevFibNum = lastLastFibNum == 0 ? 1 : lastLastFibNum;
        dyOffset = center.dy - scaleFactor * tempPrevFibNum / 2;
        break;
      case Direction.TOP:
        dyOffset = center.dy - scaleFactor * (lastFibNum + nextFibNum) / 2;
        dxOffset = center.dx - scaleFactor * (lastLastFibNum / 2);
        break;
      case Direction.LEFT:
        dxOffset = center.dx - scaleFactor * (lastFibNum + nextFibNum) / 2;
        dyOffset = center.dy + scaleFactor * (lastLastFibNum / 2);
        break;
    }
    return Offset(dxOffset, dyOffset);
  }

  static Path getSpiralPathFromRect(Rect rect, Direction direction) {
    double p1dx;
    double p1dy;
    double p2dx;
    double p2dy;
    Offset startCorner;

    switch (direction) {
      case Direction.BOTTOM:
        startCorner = rect.topLeft;
        p1dx = rect.bottomLeft.dx;
        p1dy = rect.bottomLeft.dy;
        p2dx = rect.bottomRight.dx;
        p2dy = rect.bottomRight.dy;
        break;
      case Direction.RIGHT:
        startCorner = rect.bottomLeft;
        p1dx = rect.bottomRight.dx;
        p1dy = rect.bottomRight.dy;
        p2dx = rect.topRight.dx;
        p2dy = rect.topRight.dy;
        break;
      case Direction.TOP:
        startCorner = rect.bottomRight;
        p1dx = rect.topRight.dx;
        p1dy = rect.topRight.dy;
        p2dx = rect.topLeft.dx;
        p2dy = rect.topLeft.dy;
        break;
      case Direction.LEFT:
        startCorner = rect.topRight;
        p1dx = rect.topLeft.dx;
        p1dy = rect.topLeft.dy;
        p2dx = rect.bottomLeft.dx;
        p2dy = rect.bottomLeft.dy;
        break;
    }

    Path path = Path();
    path
      ..moveTo(startCorner.dx, startCorner.dy)
      ..conicTo(p1dx, p1dy, p2dx, p2dy, .66);
    return path;
  }
}
