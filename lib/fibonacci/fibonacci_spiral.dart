import 'package:animaplay/fibonacci/fibonacci_calcs.dart';
import 'package:flutter/material.dart';

import '../animation_controller_buttons.dart';
import 'fibonacci_painter.dart';
import 'fibonacci_square.dart';

/// A page that shows an animated fibonacci spiral
class FibonacciSpiral extends StatefulWidget {
  const FibonacciSpiral({
    required this.title,
  });

  /// the text to be shown in the app bar
  final String title;

  @override
  _FibonacciSpiralState createState() => _FibonacciSpiralState();
}

class _FibonacciSpiralState extends State<FibonacciSpiral> with SingleTickerProviderStateMixin {
  /// the duration of the animation (that, is the time it takes to draw the spiral).
  /// Milliseconds.
  final int _durationInMs = 15000;

  final List<FibonacciSquare> _fibSquares = [];
  final _fibCalcs = FibonacciCalcs();
  late Path _spiralPath;
  late AnimationController _controller;
  bool _isPlaying = false;

  // beginning and end fields of Tween not needed, since the duration field in the controller provides this
  static final _animation = Tween<double>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _durationInMs),
    );
    _animation.animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didChangeDependencies() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final center = Offset(
      width / 2 - 40,
      height / 2 + 100,
    );
    _fibSquares.clear();
    _fibSquares.addAll(_fibCalcs.buildFibSquares(center));

    _spiralPath = Path();
    for (final fibSquare in _fibSquares) {
      final nextPath = _fibCalcs.getSpiralPathFromRect(
        fibSquare.square,
        fibSquare.direction,
      );
      _spiralPath.extendWithPath(nextPath, Offset.zero);
    }

    super.didChangeDependencies();
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
      body: CustomPaint(
        foregroundPainter: FibonacciPainter(
          squares: _fibSquares,
          spiralPath: _spiralPath,
          progress: _controller.value,
          showSquares: true,
        ),
        child: Container(
          color: Colors.pink[100],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: AnimationControllerButtons(
          isPlaying: _isPlaying,
          onPressPlayPause: _playOrPause,
          onPressReset: _reset,
        ),
      ),
    );
  }

  void _playOrPause() {
    setState(() {
      if (_isPlaying == false) {
        _controller.repeat();
        _isPlaying = true;
      } else {
        _controller.stop();
        _isPlaying = false;
      }
    });
  }

  void _reset() {
    setState(() {
      _controller.reset();
      _isPlaying = false;
    });
  }
}
