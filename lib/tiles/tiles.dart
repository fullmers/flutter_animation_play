import 'dart:math';

import 'package:flutter/material.dart';

import 'TilesPainter.dart';

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
  late List<List<Offset>> squareGrid = [];
  late List<List<Offset>> hexGrid = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final numCols = 5;
    final side = width / numCols;
    final numRows = (height / side).ceil();
    final r = side / 2;

    for (int i = 0; i < numRows; i++) {
      squareGrid.add([]);
      hexGrid.add([]);
      for (int j = 0; j < numCols + 1; j++) {
        // square grid:
        final x = side * j;
        final y = r + side * i;
        final squareCenter = Offset(x, y);

        // hexagonal grid:
        double hexX;
        if (i % 2 == 0) {
          hexX = r + side * j;
        } else {
          hexX = side * j;
        }
        final hexY = r * i * sqrt(3);
        final hexCenter = Offset(hexX, hexY);

        squareGrid[i].add(squareCenter);
        hexGrid[i].add(hexCenter);
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomPaint(
        foregroundPainter: TilesPainter(
          squareGrid: squareGrid,
          hexGrid: hexGrid,
          useSquares: false,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          /* child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
               Semantics(
                label: 'Reset',
                child: ElevatedButton(
                  onPressed: _reset,
                  child: Icon(Icons.replay),
                ),
              ),
            ]),*/
        ),
      ),
    );
  }

  /* void _reset() {
    setState(() {
      // todo(me)
    });
  }*/
}
