import 'dart:ui' as ui;

import 'package:animaplay/fireworks/firework.dart';
import 'package:flutter/material.dart';

/// [FireworksPainter] animates exploding fireworks.
class FireworksPainter extends CustomPainter {
  FireworksPainter({
    required this.fireworks,
    required this.progress,
    required this.totalDuration,
  });

  /// list of Fireworks to be animated
  final List<Firework> fireworks;

  /// length in ms of animation
  final double totalDuration;

  /// a value between 0.0 and 1.0 indicating the total progress of the animation. It comes from
  /// the animation controller in the calling widget and is used to control the path length,
  /// so it looks as though it is growing.
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 5;
    paint.strokeCap = StrokeCap.round;

    for (Firework firework in fireworks) {
      drawFirework(canvas, paint, firework);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawFirework(Canvas canvas, Paint paint, Firework firework) {
    final start = firework.center;
    final endPoints = firework.endPoints;
    final path = Path();
    for (int i = 0; i < endPoints.length; i++) {
      path.moveTo(start.dx, start.dy);
      path.lineTo(endPoints[i].dx, endPoints[i].dy);
    }
    paint.style = PaintingStyle.stroke;
    paint.color = firework.color;

    List<ui.PathMetric> pathMetrics = path.computeMetrics().toList(growable: true);
    for (int i = 0; i < pathMetrics.length; i++) {
      double endProgressTime = firework.startTime + firework.duration / totalDuration;
      ui.PathMetric pathMetric = pathMetrics[i];
      if ((progress > firework.startTime) && (progress < endProgressTime)) {
        final currentProgress = (progress - firework.startTime) * totalDuration / firework.duration;
        Path extractPath = pathMetric.extractPath(
          0.0,
          pathMetric.length * currentProgress,
        );
        canvas.drawPath(extractPath, paint);
      }
    }
  }

  /*
  void drawTriangle(Canvas canvas, Paint paint) {
    Path triangle = Path();
    double side = 200;
    final startDx = 400.0;
    final startDy = 400.0;
    final theta = pi / 6;

    /// 30 degrees
    final startPt = Offset(startDx, startDy);
    final pt1Dx = startDx - side * sin(theta) * progress;
    final pt1Dy = startDy - side * cos(theta) * progress;
    final pt2Dx = startDx + side * sin(theta) * progress;
    final pt2Dy = startDy - side * cos(theta) * progress;

    triangle.addPolygon([
      startPt,
      Offset(pt1Dx, pt1Dy),
      Offset(pt2Dx, pt2Dy),
    ], true);

    paint.style = PaintingStyle.stroke;
    canvas.drawPath(triangle, paint);
  }


  void drawCurly(Canvas canvas, Paint paint) {
    final start = Offset(300, 300);

    final path = Path();
    path.moveTo(start.dx, start.dy);

    path.quadraticBezierTo(600, 400, 500, 500);
    path.moveTo(500, 500);
    path.quadraticBezierTo(400, 600, 350, 450);
    canvas.drawPath(path, paint);
  }
   */
}
