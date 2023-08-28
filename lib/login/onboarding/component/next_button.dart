import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final String text;
  final ButtonStyle buttonStyle;
  final TextStyle textStyle;
  final void Function() onPressed;

  NextButton({
    required this.text,
    required this.textStyle,
    required this.buttonStyle,
    required this.onPressed,
    super.key,
});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
