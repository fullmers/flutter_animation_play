import 'dart:math';

import 'package:animaplay/examples_for_presentation/painter_template.dart';
import 'package:flutter/material.dart';

class Examples extends StatefulWidget {
  const Examples({
    required this.title,
  });

  /// the text to be shown in the app bar
  final String title;

  @override
  _ExamplesState createState() => _ExamplesState();
}

class _ExamplesState extends State<Examples> {
  Random _random = Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomPaint(
        foregroundPainter: Painter(
          circleColor: Colors.orange,
          circleCenter: Offset(200, 100),
        ),
        painter: Painter(
          circleColor: Colors.green,
          circleCenter: Offset(300, 150),
        ),
        child: Container(
          color: Colors.indigoAccent.withOpacity(.5),
        ),
      ),
    );
  }
}
