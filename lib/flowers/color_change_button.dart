import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Button used to change the color scheme of the flowers shown in [Flowers]
class ColorChangeButton extends StatelessWidget {
  const ColorChangeButton({
    required this.buttonColor,
    required this.onTap,
  });

  /// the color of the button
  final Color buttonColor;

  /// the change color function from parent which should change the flower color scheme to the given input
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: buttonColor,
          )),
      onTap: onTap,
    );
  }
}
