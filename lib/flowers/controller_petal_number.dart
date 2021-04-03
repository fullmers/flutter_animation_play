import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControllerPetalNumber extends StatelessWidget {
  ControllerPetalNumber({required this.changePetalNumber});
  final Function(bool isIncreasing) changePetalNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('PETALS'),
        const SizedBox(width: 8),
        ElevatedButton(
          child: Icon(Icons.add),
          onPressed: () => changePetalNumber(true),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          child: Icon(Icons.remove),
          onPressed: () => changePetalNumber(false),
        ),
      ],
    );
  }
}
