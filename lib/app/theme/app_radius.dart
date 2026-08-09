import 'package:flutter/material.dart';

class AppRadius {
  // Corner radius values
  static const double small = 10.0;
  static const double medium = 14.0;
  static const double large = 18.0;
  static const double extraLarge = 24.0;
  static const double card = 18.0;
  static const double bottomSheet = 28.0;
  static const double button = 14.0;
  static const double circle = 50.0;

  // BorderRadius objects
  static final BorderRadius smallRadius = BorderRadius.circular(small);
  static final BorderRadius mediumRadius = BorderRadius.circular(medium);
  static final BorderRadius largeRadius = BorderRadius.circular(large);
  static final BorderRadius cardRadius = BorderRadius.circular(card);
  static final BorderRadius bottomSheetRadius =
      const BorderRadius.only(
        topLeft: Radius.circular(bottomSheet),
        topRight: Radius.circular(bottomSheet),
      );
  static final BorderRadius buttonRadius = BorderRadius.circular(button);
  static final BorderRadius circleRadius = BorderRadius.circular(circle);

  // For specific corners
  static final BorderRadius topRounded = const BorderRadius.only(
    topLeft: Radius.circular(bottomSheet),
    topRight: Radius.circular(bottomSheet),
  );
}
