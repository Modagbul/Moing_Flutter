import 'package:flutter/material.dart';
import 'package:moing_flutter/const/style/text.dart';

class WhiteButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;

  const WhiteButton({required this.onPressed, required this.text, super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 62,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            )),
        onPressed: onPressed,
        child: Text(
          text,
          style: buttonTextStyle,
        ),
      ),
    );
  }
}
