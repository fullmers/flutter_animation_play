import 'package:animaplay/ptolemy/ptolemys_theorem.dart';
import 'package:animaplay/tiles/tiles.dart';
import 'package:flutter/material.dart';

import 'fibonacci/fibonacci_spiral.dart';
import 'fireworks/fireworks.dart';
import 'flowers/floating_flowers.dart';
import 'lines/lines.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Fireworks(
      title: 'Fireworks',
    ),
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: 80),
        ElevatedButton(
          child: Container(
            child: Text('Lines'),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Lines(
                    title: 'Lines',
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          child: Container(
            child: Text('Tiles'),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Tiles(
                    title: 'Tiles',
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          child: Container(
            child: Text('Floating Flowers'),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return FloatingFlowers(
                    title: 'Floating Flowers',
                    width: width,
                    height: height,
                  );
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
                  return PtolemysTheorem(
                    title: 'Ptolemy',
                  );
                },
              ),
            );
          },
        ),
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
                  return FibonacciSpiral(
                    title: 'Fibonacci Spiral',
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
