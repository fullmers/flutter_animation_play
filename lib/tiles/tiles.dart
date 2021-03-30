import 'package:flutter/material.dart';

import '../animation_controller_buttons.dart';
import 'TilesPainter.dart';

/// A page that shows an animated fibonacci spiral
class Tiles extends StatefulWidget {
  const Tiles({
    required this.title,
  });

  /// the text to be shown in the app bar
  final String title;

  @override
  _TilesState createState() => _TilesState();
}

class _TilesState extends State<Tiles> with SingleTickerProviderStateMixin {
 // final List<Offset> gridPoints = [];

  @override
  void initState() {
    super.initState();

  }

  @override
  void didChangeDependencies() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomPaint(
        foregroundPainter: TilesPainter(),
        child: Container(
            ),
      ),
    );
  }



  void _reset() {
    setState(() {
//todo
    });
  }
}
