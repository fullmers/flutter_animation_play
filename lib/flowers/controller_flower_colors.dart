import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color_change_button.dart';
import 'flower.dart';

class ControllerFlowerColors extends StatelessWidget {
  ControllerFlowerColors({required this.changeColor});
  final Function(FlowerColorScheme scheme) changeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 30),
        Text('FLOWERS'),
        const SizedBox(width: 8),
        ColorChangeButton(
          buttonColor: Colors.green,
          onTap: () => changeColor(FlowerColorScheme.Green),
        ),
        const SizedBox(width: 8),
        ColorChangeButton(
          buttonColor: Colors.pink,
          onTap: () => changeColor(FlowerColorScheme.Pink),
        ),
        const SizedBox(width: 8),
        ColorChangeButton(
          buttonColor: Colors.blue,
          onTap: () => changeColor(FlowerColorScheme.Blue),
        ),
        const SizedBox(width: 8),
        ColorChangeButton(
          buttonColor: Colors.orange,
          onTap: () => changeColor(FlowerColorScheme.Orange),
        ),
        const SizedBox(width: 8),
        ColorChangeButton(
          buttonColor: Colors.purple,
          onTap: () => changeColor(FlowerColorScheme.Purple),
        ),
        const SizedBox(width: 8),
        ColorChangeButton(
          buttonColor: Colors.yellow,
          onTap: () => changeColor(FlowerColorScheme.Yellow),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
