import 'package:flutter/material.dart';

class PtolemysTheorem extends StatefulWidget {
  const PtolemysTheorem({required this.title});

  final String title;

  @override
  _PtolemysTheoremState createState() => _PtolemysTheoremState();
}

class _PtolemysTheoremState extends State<PtolemysTheorem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  static final _animation = Tween<double>(
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
    _animation.animate(_controller)
      ..addListener(() {
        setState(() {});
      });
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
          child: Text('meat'),
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
                onPressed: _play,
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

  void _play() {
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
