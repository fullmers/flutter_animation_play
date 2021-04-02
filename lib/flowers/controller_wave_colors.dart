import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color_change_button.dart';

class ControllerWaveColors extends StatelessWidget {
  ControllerWaveColors({required this.changeWaveColor});
  final Function(Color waveColor) changeWaveColor;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 30),
      Text('WAVES'),
      const SizedBox(width: 8),
      ColorChangeButton(
        buttonColor: Colors.green[100]!,
        onTap: () => changeWaveColor(Colors.green[100]!),
      ),
      const SizedBox(width: 8),
      ColorChangeButton(
        buttonColor: Colors.pink[100]!,
        onTap: () => changeWaveColor(Colors.pink[100]!),
      ),
      const SizedBox(width: 8),
      ColorChangeButton(
        buttonColor: Colors.lightBlue[100]!,
        onTap: () => changeWaveColor(Colors.lightBlue[100]!),
      ),
      const SizedBox(width: 8),
      ColorChangeButton(
        buttonColor: Colors.orange[100]!,
        onTap: () => changeWaveColor(Colors.orange[100]!),
      ),
      const SizedBox(width: 8),
      ColorChangeButton(
        buttonColor: Colors.deepPurple[100]!,
        onTap: () => changeWaveColor(Colors.deepPurple[100]!),
      ),
      const SizedBox(width: 8),
      ColorChangeButton(
        buttonColor: Colors.amberAccent[100]!,
        onTap: () => changeWaveColor(Colors.amberAccent[100]!),
      ),
    ]);
  }
}
