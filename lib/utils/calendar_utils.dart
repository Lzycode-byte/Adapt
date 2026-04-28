import 'package:flutter/material.dart';

const Color ghEmpty = Color(0xFF161B22); // no contributions
const Color ghLevel1 = Color(0xFF0E4429);
const Color ghLevel2 = Color(0xFF006D32);
const Color ghLevel3 = Color(0xFF26A641);
const Color ghLevel4 = Color(0xFF39D353);

Color? getHabitColor(int completed, int total) {
  if (total == 0 || completed == 0) return null;

  final ratio = completed / total;

  if (ratio <= 0.25) return ghLevel1;
  if (ratio <= 0.5) return ghLevel2;
  if (ratio <= 0.75) return ghLevel3;

  return ghLevel4;
}
