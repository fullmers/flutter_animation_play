import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorChangeButton extends StatelessWidget {
  const ColorChangeButton({
    required this.buttonColor,
    required this.onTap,
  });
  final Color buttonColor;
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
