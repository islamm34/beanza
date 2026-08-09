import 'package:flutter/material.dart';

class AppShadows {
  // Subtle shadows for premium feel
  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x24000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color(0x2E000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x24000000),
      blurRadius: 20,
      offset: Offset(0, 10),
    ),
  ];

  // Aliases
  static const List<BoxShadow> shadowSm = small;
  static const List<BoxShadow> shadowMd = medium;
  static const List<BoxShadow> shadowLg = large;
  static const List<BoxShadow> cardShadow = card;

  // No shadow
  static const List<BoxShadow> none = [];
}
