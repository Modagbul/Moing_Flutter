import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';

class BlackButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;

  const BlackButton({
    required this.onPressed,
    required this.text,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 62,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            side: BorderSide(
              color: grayScaleGrey400,
              width: 1.0,
            ),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            )
        ),
        onPressed: onPressed,
        child: Text(text,
          style: buttonTextStyle.copyWith(color: grayScaleGrey300),
        ),
      ),
    );
  }
}
