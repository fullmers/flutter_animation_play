import 'package:animaplay/ptolemy/ptolemys_theorem.dart';
import 'package:flutter/material.dart';

import 'examples_for_presentation/examples.dart';
import 'fibonacci/fibonacci_spiral.dart';
import 'flowers/floating_flowers.dart';
import 'flowers/still_flowers.dart';
import 'lines/lines.dart';
import 'tiles/tiles.dart';

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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: 80),
        ElevatedButton(
          child: Container(
            child: Text('Starter Example'),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Examples(
                    title: 'Starter Example',
                  );
                },
              ),
            );
          },
        ),
        SizedBox(height: 20),
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
            child: Text('Still Flowers'),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return StillFlowers(
                    title: 'Still Flowers',
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

        /*      SizedBox(height: 20),
        ElevatedButton(
          child: Container(
            child: Text('Plaid'),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Plaid(
                    title: 'Plaid',
                  );
                },
              ),
            );
          },
        ),*/
      ],
    );
  }
}
