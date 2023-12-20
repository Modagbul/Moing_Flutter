import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/make_group/component/warning_dialog.dart';

class ViewUtil {
  // AlertDialog 오류 메세지 출력
  void showAlertDialog(
      {required BuildContext context, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // SnackBar 오류 메세지 출력
  void showErrorSnackBar({
    required BuildContext context,
    required String message,
  }) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning, color: Colors.red),
          const SizedBox(width: 10),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: grayScaleGrey700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: grayScaleWhite,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // SnackBar 메세지 출력
  void showSnackBar({
    required BuildContext context,
    required String message,
  }) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: grayScaleGrey700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: grayScaleWhite,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.only(bottom: screenHeight * 0.73),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool?> showWarningDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String leftText,
    required String rightText,
}) async {
    var result = await showDialog(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WarningDialog(
              title: title,
              content: content,
              onConfirm: () {
                Navigator.of(ctx).pop(true);
              },
              onCanceled: () {
                Navigator.of(ctx).pop(false);
              },
              leftText: leftText,
              rightText: rightText,
            ),
          ],
        );
      },
    );

    return result;
  }
}
