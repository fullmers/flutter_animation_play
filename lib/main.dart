import 'package:animaplay/ptolemy/ptolemy.dart';
import 'package:flutter/material.dart';

import 'fibonacci/fibonacci_spiral.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    title: 'Play with animations',
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
    ),
  ));
}

const double scaleFactor = 3;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        ElevatedButton(
          child: Container(
            child: Text('Fibonacci Spiral'),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return FibonacciSpiral(title: 'Fibonacci Spiral');
                },
              ),
            );
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          child: Container(
            child: Text('Ptolemy\'s Theorem'),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return PtolemysTheorem(title: 'Ptolemy');
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
