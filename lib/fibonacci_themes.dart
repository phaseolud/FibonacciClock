import 'package:flutter/material.dart';

enum _BlockColors {
  noColor,
  hourColor,
  minuteColor,
  combinedColor,
}

final Map<_BlockColors, Color> _basictheme = {
  _BlockColors.noColor: Colors.white,
  _BlockColors.hourColor: Colors.red[400],
  _BlockColors.minuteColor: Colors.green[400],
  _BlockColors.combinedColor: Colors.blue[400],
};

Map<String, Color> circleColors = {
  'nocolor': Colors.transparent,
  'black': Colors.black,
  'white': Colors.white
};
