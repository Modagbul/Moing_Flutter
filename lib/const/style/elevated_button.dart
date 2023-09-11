import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

final ButtonStyle brightButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: grayScaleWhite,
  foregroundColor: grayScaleGrey900,
  disabledBackgroundColor: grayScaleGrey700,
  disabledForegroundColor: grayScaleGrey500,
  textStyle: const TextStyle(
    color: grayScaleGrey900,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
  ),
  padding: const EdgeInsets.all(16.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
  ),
);

final ButtonStyle defaultButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: grayScaleGrey500,
  foregroundColor: grayScaleGrey300,
  disabledBackgroundColor: grayScaleGrey700,
  disabledForegroundColor: grayScaleGrey500,
  textStyle: const TextStyle(
    color: grayScaleGrey300,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
  ),
  padding: const EdgeInsets.all(16.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
  ),
);

final ButtonStyle darkButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: grayScaleGrey600,
  foregroundColor: grayScaleGrey300,
  disabledBackgroundColor: grayScaleGrey700,
  disabledForegroundColor: grayScaleGrey500,
  textStyle: const TextStyle(
    color: grayScaleGrey300,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
  ),
  padding: const EdgeInsets.all(16.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
  ),
);
