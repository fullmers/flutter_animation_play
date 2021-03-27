import 'package:flutter/material.dart';

/// [AnimationControllerButtons] A row of common controller buttons (play/pause and reset)
/// for animations, and their callbacks.
class AnimationControllerButtons extends StatelessWidget {
  AnimationControllerButtons({
    required this.isPlaying,
    required this.onPressPlayPause,
    required this.onPressReset,
  });

  /// is the current animation playing. if yes, the play/pause button displays the "pause" icon. otherwise, it shows
  /// the "play" button
  final bool isPlaying;

  /// function from parent widget which should toggle play/pause in the parent's animation controller
  final Function() onPressPlayPause;

  /// function from parent widget which should reset the parent's animation controller
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
