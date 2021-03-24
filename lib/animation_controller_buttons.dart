import 'package:flutter/material.dart';

class AnimationControllerButtons extends StatelessWidget {
  AnimationControllerButtons({
    required this.isPlaying,
    required this.onPressPlayPause,
    required this.onPressReset,
  });
  final bool isPlaying;
  final Function() onPressPlayPause;
  final Function() onPressReset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Row(
        children: [
          Semantics(
            label: 'Play',
            child: ElevatedButton(
              onPressed: onPressPlayPause,
              child: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            ),
          ),
          const SizedBox(width: 8),
          Semantics(
            label: 'Reset',
            child: ElevatedButton(
              onPressed: onPressReset,
              child: Icon(Icons.replay),
            ),
          ),
        ],
      ),
    );
  }
}
