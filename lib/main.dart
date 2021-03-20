import 'package:flutter/material.dart';

import 'fibonacci_painter.dart';

void main() {
  runApp(MyApp());
}

const double scaleFactor = 3;

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

class _FibSpiralState extends State<FibSpiral> with SingleTickerProviderStateMixin {
  final _fibNumbers = [1, 1];
  final _sequenceLength = 14;
  final List<FibRect> _fibRects = [];
  late Offset _startCenter;
  late Path _spiralPath;
  late AnimationController _controller;

  static final spiralPathAnim = Tween<double>(
    begin: 0,
    end: .5,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
      reverseDuration: Duration(seconds: 1),
    );
    spiralPathAnim.animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {});

    _startCenter = Offset(400, 400);
    for (var i = 0; i < _sequenceLength; i++) {
      _addNextFibNumber();
    }

    _constructFibRects();
    _spiralPath = Path();
    for (final fibRect in _fibRects) {
      final nextPath = _getSpiralPathFromRect(fibRect.rect, fibRect.direction);
      _spiralPath.extendWithPath(nextPath, Offset.zero);
    }
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
          spiralPath: _spiralPath,
          progress: _controller.value,
        ),
        child: Container(
          color: Colors.lightBlueAccent,
        ),
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: _reset,
            tooltip: 'reset',
            child: Icon(Icons.replay),
          ),
          FloatingActionButton(
            onPressed: _animateSpiral,
            tooltip: 'Play',
            child: Icon(Icons.play_arrow),
          ),
          FloatingActionButton(
            onPressed: _reverse,
            tooltip: 'reverse',
            child: Icon(Icons.fast_rewind_rounded),
          ),
          FloatingActionButton(
            onPressed: _pause,
            tooltip: 'pause',
            child: Icon(Icons.pause),
          ),
        ],
      ),
    );
  }

  void _animateSpiral() {
    setState(() {
      _controller.forward();
    });
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
        center: _startCenter,
        width: scaleFactor,
        height: scaleFactor,
      ),
      direction: Direction.LEFT,
    );
    FibRect secondRect = FibRect(
      fibNumber: 1,
      rect: Rect.fromCenter(
        center: Offset(_startCenter.dx, _startCenter.dy + scaleFactor),
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

  Path _getSpiralPathFromRect(Rect rect, Direction direction) {
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

  void _reset() {
    setState(() {
      _controller.reset();
    });
  }

  void _reverse() {
    setState(() {
      _controller.reverse();
    });
  }

  void _pause() {
    setState(() {
      _controller.stop();
    });
  }
}
