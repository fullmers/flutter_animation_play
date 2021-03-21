import 'package:animaplay/fibonacci/fibonacci_calcs.dart';
import 'package:flutter/material.dart';

import 'fibonacci_painter.dart';
import 'fibonacci_square.dart';

const double scaleFactor = 3;
const int sequenceLength = 12;
const int durationSeconds = 5;

class FibonacciSpiral extends StatefulWidget {
  const FibonacciSpiral({required this.title});

  final String title;

  @override
  _FibonacciSpiralState createState() => _FibonacciSpiralState();
}

class _FibonacciSpiralState extends State<FibonacciSpiral> with SingleTickerProviderStateMixin {
  final List<FibonacciSquare> _fibSquares = [];
  late Path _spiralPath;
  late AnimationController _controller;

  static final spiralPathAnim = Tween<double>(
    begin: 0,
    end: 5,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: durationSeconds),
      reverseDuration: Duration(seconds: durationSeconds),
    );
    spiralPathAnim.animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    final _startCenter = Offset(400, 400);
    _fibSquares.addAll(FibonacciCalcs.buildFibSquares(_startCenter));

    _spiralPath = Path();
    for (final fibRect in _fibSquares) {
      final nextPath = FibonacciCalcs.getSpiralPathFromRect(fibRect.square, fibRect.direction);
      _spiralPath.extendWithPath(nextPath, Offset.zero);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.lightBlueAccent,
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
          child: CustomPaint(
            foregroundPainter: FibonacciPainter(
              squares: _fibSquares,
              spiralPath: _spiralPath,
              progress: _controller.value,
            ),
            child: Container(
              color: Colors.lightBlueAccent,
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Row(
          children: [
            Semantics(
              label: 'reset',
              child: ElevatedButton(
                onPressed: _reset,
                child: Icon(Icons.replay),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Semantics(
              label: 'Play',
              child: ElevatedButton(
                onPressed: _animateSpiral,
                child: Icon(Icons.play_arrow),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Semantics(
              label: 'reverse',
              child: ElevatedButton(
                onPressed: _reverse,
                child: Icon(Icons.fast_rewind_rounded),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Semantics(
              label: 'pause',
              child: ElevatedButton(
                onPressed: _pause,
                child: Icon(Icons.pause),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _animateSpiral() {
    setState(() {
      _controller.repeat();
    });
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
