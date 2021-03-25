import 'package:flutter/material.dart';

import '../animation_controller_buttons.dart';
import 'flower_painter.dart';

/// A page that shows some animated flowers
class Flowers extends StatefulWidget {
  const Flowers({
    required this.title,
  });

  /// the text to be shown in the app bar
  final String title;

  @override
  _FlowersState createState() => _FlowersState();
}

class _FlowersState extends State<Flowers> with SingleTickerProviderStateMixin {
  final int durationInMs = 10000;

  late AnimationController _controller;
  bool _isPlaying = false;

  // beginning and end fields of Tween not needed, since the duration field in the controller provides this
  static final _animation = Tween<double>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: durationInMs),
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
      width / 2,
      height / 2,
    );

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
        foregroundPainter: FlowerPainter(
          progress: _controller.value,
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
