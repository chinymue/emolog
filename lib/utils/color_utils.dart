import 'package:flutter/material.dart';

/// === COLOR UTILS ===

/// Một số màu tiện dùng
const Color follyRed = Color(0xFFFF0A54);
const Color tickleMePink = Color(0xFFFF85A1);
const Color brightPink = Color(0xFFFF5C8A);
const Color salmonPink = Color(0xFFFF99AC);
const Color cherryBlossom = Color(0xFFFBB1BD);
const Color mistyRose = Color(0xFFFAE0E4);
const Color lavenderBlush = Color(0xFFFFF0F3);
const Color chocolateCosmos = Color(0xFF590D22);
const Color claret = Color(0xFF800F2F);
const Color roseRed = Color(0xFFC9184A);
const Color amaranthPurple = Color(0xFFA4133C);

Color adjustLightness(Color color, double amount, {double maxLightness = 0.9}) {
  final hsl = HSLColor.fromColor(color);
  final newLightness = (hsl.lightness + amount).clamp(0.0, maxLightness);
  return hsl.withLightness(newLightness).toColor();
}
