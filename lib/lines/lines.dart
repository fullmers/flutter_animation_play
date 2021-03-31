import 'dart:math';

import 'package:flutter/material.dart';

import 'design_type_button.dart';
import 'line_painter.dart';

class Lines extends StatefulWidget {
  const Lines({
    required this.title,
  });

  /// the text to be shown in the app bar
  final String title;

  @override
  _LinesState createState() => _LinesState();
}

class _LinesState extends State<Lines> {
  final List<List<Offset>> squareGrid = [];
  final List<List<bool>> directions = [];

  final List<Offset> startPts1 = [];
  final List<Offset> endPts1 = [];
  final List<Offset> startPts2 = [];
  final List<Offset> endPts2 = [];
  double r = 0;
  final numCols = 10;
  int numRows = -1;
  final _random = Random();
  DesignType _designType = DesignType.DiagonalLines;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('calling didChangeDependencies');
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final side = width / numCols;
    r = side / 2;
    numRows = (height / side).ceil();
    _createSquareGrid();
    _createStartEndPts();
    _createRandomDirections();
    super.didChangeDependencies();
  }

  void _createSquareGrid() {
    for (int i = 0; i < numRows; i++) {
      squareGrid.add([]);
      for (int j = 0; j < numCols + 1; j++) {
        // square grid:
        final x = 2 * r * j;
        final y = r + 2 * r * i;
        squareGrid[i].add(Offset(x, y));
      }
    }
  }

  void _createStartEndPts() {
    startPts1.clear();
    endPts1.clear();
    startPts2.clear();
    endPts2.clear();
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols + 1; j++) {
        final squareCenter = squareGrid[i][j];
        final startPt1 = Offset(squareCenter.dx - r, squareCenter.dy - r);
        final endPt1 = Offset(squareCenter.dx + r, squareCenter.dy + r);
        final startPt2 = Offset(squareCenter.dx + r, squareCenter.dy - r);
        final endPt2 = Offset(squareCenter.dx - r, squareCenter.dy + r);
        startPts1.add(startPt1);
        endPts1.add(endPt1);
        startPts2.add(startPt2);
        endPts2.add(endPt2);
      }
    }
  }

  void _createRandomDirections() {
    directions.clear();
    for (int i = 0; i < numRows; i++) {
      directions.add([]);
      for (int j = 0; j < numCols + 1; j++) {
        directions[i].add(_random.nextBool());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('calling build');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomPaint(
        painter: LinePainter(
          designType: _designType,
          directions: directions,
          squareGrid: squareGrid,
          r: r,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    DesignChangeButton(
                      text: 'diagonal',
                      onTap: () => changeDesignType(DesignType.DiagonalLines),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    DesignChangeButton(
                      text: 'parallel',
                      onTap: () => changeDesignType(DesignType.ParallelLines),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeDesignType(DesignType designType) {
    setState(() {
      print('calling setState to changeDesignType $_designType ');
      _designType = designType;
      _createRandomDirections();
    });
  }
}

enum DesignType { ParallelLines, DiagonalLines }
