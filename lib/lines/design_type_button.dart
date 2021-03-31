import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Button used to change the color scheme of the flowers shown in [Flowers]
class DesignChangeButton extends StatelessWidget {
  const DesignChangeButton({
    required this.text,
    required this.onTap,
  });

  final String text;

  /// function to change the design that is being shown
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: text,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}
