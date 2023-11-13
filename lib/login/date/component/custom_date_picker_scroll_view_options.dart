import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class DatePickerScrollViewOptions {
  const DatePickerScrollViewOptions({
    this.year = const ScrollViewDetailOptions(margin: EdgeInsets.all(4)),
    this.month = const ScrollViewDetailOptions(margin: EdgeInsets.all(4)),
    this.day = const ScrollViewDetailOptions(margin: EdgeInsets.all(4)),
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final ScrollViewDetailOptions year;
  final ScrollViewDetailOptions month;
  final ScrollViewDetailOptions day;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  // Applies the given [ScrollViewDetailOptions] to all three options ie. year, month and day.
  static DatePickerScrollViewOptions all(ScrollViewDetailOptions value) {
    return DatePickerScrollViewOptions(
      year: value,
      month: value,
      day: value,
    );
  }
}

class ScrollViewDetailOptions {
  const ScrollViewDetailOptions({
    this.label = '',
    this.alignment = Alignment.center,
    this.margin,
    this.selectedTextStyle =
    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: grayScaleGrey100),
    this.textStyle =
    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: grayScaleGrey550),
  });

  /// The text printed next to the year, month, and day.
  final String label;

  /// The year, month, and day text alignment method.
  final Alignment alignment;

  /// The amount of space that can be added to the year, month, and day.
  final EdgeInsets? margin;

  /// An immutable style describing how to format and paint text.
  final TextStyle textStyle;

  /// An invariant style that specifies the selected text format and explains how to draw it.
  final TextStyle selectedTextStyle;
}
