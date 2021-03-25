import 'dart:ui';

/// A data class for bundling all of the fixed points used in the animation found on [PtolemysTheorem].
class FixedPointsForPtolemy {
  /// The center of the circle which the animation centers around
  final Offset center;

  /// The left of 2 reference points used for illustrating the relative lengths of 3 chords between a dot on a circle
  /// and the 3 points of an equilateral triangle inscribed by the same circle.
  /// This point is the reference for showing length of the longest of the 3 chords.
  final Offset leftFixedPt;

  /// The right of 2 reference points used for illustrating the relative lengths of 3 chords between a dot on a circle
  /// and the 3 points of an equilateral triangle inscribed by the same circle.
  /// This point is the reference for showing length of the sum of the two shorter chords (which will equal the length
  /// of the longest).
  final Offset rtFixedPt;

  /// [refTrianglePt1], [refTrianglePt2] and [refTrianglePt3] are the 3 point on an equilateral triangle inscribed by a
  /// circle whose center is [center].
  final Offset refTrianglePt1;
  final Offset refTrianglePt2;
  final Offset refTrianglePt3;

  const FixedPointsForPtolemy({
    required this.center,
    required this.leftFixedPt,
    required this.rtFixedPt,
    required this.refTrianglePt1,
    required this.refTrianglePt2,
    required this.refTrianglePt3,
  });
}
