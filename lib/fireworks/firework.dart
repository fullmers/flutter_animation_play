import 'dart:ui';

class Firework {
  Firework({
    required this.center,
    required this.r,
    required this.color,
    required this.startTime,
    required this.numArms,
    required this.duration,
    required this.endPoints,
  });

  final Offset center;
  final double r;
  final Color color;
  final double startTime;
  final double duration;
  final int numArms;
  final List<Offset> endPoints;
}
