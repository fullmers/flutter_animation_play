import 'package:flutter/material.dart';

class ControllerTop extends StatelessWidget {
  final double openHeight;
  final double minHeight;
  final Function() reset;
  final bool isControllerOpen;
  final Function() openOrCloseController;

  const ControllerTop({
    required this.openHeight,
    required this.minHeight,
    required this.reset,
    required this.isControllerOpen,
    required this.openOrCloseController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 6,
          left: 30,
        ),
        child: Row(
          children: [
            Semantics(
              label: 'Reset',
              child: ElevatedButton(
                onPressed: reset,
                child: Icon(Icons.replay),
              ),
            ),
            Flexible(
                flex: 1,
                child: Container(
                  height: minHeight,
                  color: Colors.white,
                )),
            InkWell(
              child: Container(
                  height: 30,
                  width: 30,
                  child: isControllerOpen ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
                  // alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    color: Colors.blueGrey[100],
                  )),
              onTap: openOrCloseController,
            ),
          ],
        ),
      ),
    );
  }
}
