import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';

class ToastMessage {
  void showToastMessage({
    required FToast fToast,
    required String warningText,
    int milliSeconds = 2000,
    double horizontal = 20.0,
    double? toastBottom,
    double? toastLeft,
    double? toastRight,
    double? toastTop,
  }) {
    fToast.showToast(
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontal),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'asset/icons/danger.svg',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    Text(
                      warningText,
                      style: bodyTextStyle.copyWith(color: grayScaleGrey700),
                    ),
                  ],
                ),
              )),
        ),
        toastDuration: Duration(milliseconds: milliSeconds),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            bottom: toastBottom,
            left: toastLeft,
            right: toastRight,
            top: toastTop,
          );
        });
  }
}
