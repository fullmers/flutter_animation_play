import 'package:flutter/material.dart';

import 'plaid_painter.dart';

class Plaid extends StatefulWidget {
  const Plaid({
    required this.title,
  });

  /// the text to be shown in the app bar
  final String title;

  @override
  _PlaidState createState() => _PlaidState();
}

class _PlaidState extends State<Plaid> with SingleTickerProviderStateMixin {
  late List<List<Offset>> squareGrid = [];
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
      for (int j = 0; j < numCols + 1; j++) {
        final x = side * j;
        final y = r + side * i;
        final squareCenter = Offset(x, y);
        squareGrid[i].add(squareCenter);
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
        foregroundPainter: PlaidPainter(
          squareGrid: squareGrid,
        ),
        child: Container(),
      ),
    );
  }
}
