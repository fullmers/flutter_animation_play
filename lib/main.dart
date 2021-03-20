import 'package:flutter/material.dart';

import 'fibonacci_painter.dart';

void main() {
  runApp(MyApp());
}

const double scaleFactor = 10;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Play with animations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FibSpiral(title: 'Fibonacci Spiral'),
    );
  }
}

class FibSpiral extends StatefulWidget {
  FibSpiral({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FibSpiralState createState() => _FibSpiralState();
}

class _FibSpiralState extends State<FibSpiral> {
  final _fibNumbers = [1, 1];
  final _sequenceLength = 10;
  final List<FibRect> _fibRects = [];
  late Offset startCenter;

  @override
  void initState() {
    super.initState();
    startCenter = Offset(300, 200);
    for (var i = 0; i < _sequenceLength; i++) {
      _addNextFibNumber();
    }

    _constructFibRects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomPaint(
        foregroundPainter: FibPainter(
          rects: _fibRects,
        ),
        child: Container(
          color: Colors.lightBlueAccent,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateSpiral,
        tooltip: 'Generate',
        child: Icon(Icons.add),
      ),
    );
  }

  void _animateSpiral() {
    setState(() {});
  }

  Direction _getNextDirection(Direction currentDir) {
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

  void _constructFibRects() {
    FibRect firstRect = FibRect(
      fibNumber: 1,
      rect: Rect.fromCenter(
        center: startCenter,
        width: scaleFactor,
        height: scaleFactor,
      ),
      direction: Direction.LEFT,
    );
    FibRect secondRect = FibRect(
      fibNumber: 1,
      rect: Rect.fromCenter(
        center: Offset(startCenter.dx, startCenter.dy + scaleFactor),
        width: scaleFactor,
        height: scaleFactor,
      ),
      direction: Direction.BOTTOM,
    );
    _fibRects.add(firstRect);
    _fibRects.add(secondRect);

    for (var i = 2; i < _fibNumbers.length; i++) {
      final currentRect = _fibRects[i - 1];
      final newFibNumber = _fibNumbers[i];
      final newLength = newFibNumber * scaleFactor;
      final newCenter = _nextCenter(
        lastFibNum: _fibNumbers[i - 1],
        lastLastFibNum: _fibNumbers[i - 2],
        lastFibRect: _fibRects[i - 1],
      );
      final nextFibRect = FibRect(
        fibNumber: newFibNumber,
        direction: _getNextDirection(currentRect.direction),
        rect: Rect.fromCenter(
          center: newCenter,
          width: newLength,
          height: newLength,
        ),
      );
      _fibRects.add(nextFibRect);
    }
  }

  void _addNextFibNumber() {
    final nextFib = _fibNumbers[_fibNumbers.length - 1] + _fibNumbers[_fibNumbers.length - 2];
    _fibNumbers.add(nextFib);
  }

  Offset _nextCenter({
    required int lastFibNum,
    required int lastLastFibNum,
    required FibRect lastFibRect,
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
}
