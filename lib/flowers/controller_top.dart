import 'package:flutter/material.dart';

class ControllerTop extends StatelessWidget {
  final Function() reset;
  final bool isControllerOpen;
  final Function() openOrCloseController;
  final bool? isPlaying;
  final Function()? playOrPause;

  const ControllerTop({
    required this.reset,
    required this.isControllerOpen,
    required this.openOrCloseController,
    this.isPlaying,
    this.playOrPause,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
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
            const SizedBox(
              width: 8,
            ),
            if (playOrPause != null && isPlaying != null)
              Semantics(
                label: 'Play or Pause',
                child: ElevatedButton(
                  onPressed: playOrPause,
                  child: isPlaying! ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                ),
              ),
            Spacer(),
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
