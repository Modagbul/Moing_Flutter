import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class DatePickerOptions {
  const DatePickerOptions({
    this.itemExtent = 58.0,
    this.diameterRatio = 100,
    this.perspective = 0.0001,
    this.isLoop = true,
    this.backgroundColor = grayBackground,
  });

  /// Size of each child in the main axis
  final double itemExtent;

  /// {@macro flutter.rendering.wheelList.diameterRatio}
  final double diameterRatio;

  /// {@macro flutter.rendering.wheelList.perspective}
  final double perspective;

  /// The loop iterates on an explicit list of values
  final bool isLoop;

  /// The color to paint behind the date picker
  final Color backgroundColor;
}
