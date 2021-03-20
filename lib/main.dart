import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FibSpiral(title: 'Fibonacci Spiral'),
    );
  }
}

class FibSpiral extends StatefulWidget {
  FibSpiral({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FibSpiralState createState() => _FibSpiralState();
}

class _FibSpiralState extends State<FibSpiral> {
  final _fibNumbers = [1, 1];
  final _totalNumbers = 10;

  void _genFibSequence() {
    setState(() {
      for (var i = 0; i < _totalNumbers; i++) {
        _addNextFibNumber();
      }
    });
  }

  void _addNextFibNumber() {
    final nextFib = _fibNumbers[_fibNumbers.length - 1] + _fibNumbers[_fibNumbers.length - 2];
    _fibNumbers.add(nextFib);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_fibNumbers',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _genFibSequence,
        tooltip: 'Generate',
        child: Icon(Icons.add),
      ),
    );
  }
}
