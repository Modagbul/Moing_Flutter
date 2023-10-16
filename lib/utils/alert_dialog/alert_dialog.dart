import 'package:flutter/material.dart';

class ViewUtil {
  // 오류 메세지 출력
   void showAlertDialog({
    required BuildContext context,
    required String message}) {
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
}