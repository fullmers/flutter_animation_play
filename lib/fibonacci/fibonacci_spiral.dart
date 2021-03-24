import 'package:animaplay/fibonacci/fibonacci_calcs.dart';
import 'package:flutter/material.dart';

import '../animation_controller_buttons.dart';
import 'fibonacci_painter.dart';
import 'fibonacci_square.dart';

/// the length, in seconds, of the spiral animation
const int durationSeconds = 5;

/// A page that shows an animated fibonacci spiral
class FibonacciSpiral extends StatefulWidget {
  const FibonacciSpiral({required this.title});

  /// the text to be shown in the app bar
  final String title;

  @override
  _FibonacciSpiralState createState() => _FibonacciSpiralState();
}

class _FibonacciSpiralState extends State<FibonacciSpiral> with SingleTickerProviderStateMixin {
  final List<FibonacciSquare> _fibSquares = [];
  late Path _spiralPath;
  late AnimationController _controller;
  bool _isPlaying = false;

  /// the animation used to show a fibonacci spiral
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
  }

  @override
  void didChangeDependencies() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final center = Offset(
      width / 2,
      height / 2,
    );
    _fibSquares.clear();
    _fibSquares.addAll(FibonacciCalcs.buildFibSquares(center));

    _spiralPath = Path();
    for (final fibSquare in _fibSquares) {
      final nextPath = FibonacciCalcs.getSpiralPathFromRect(
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
