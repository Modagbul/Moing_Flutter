import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  final void Function() onTap;

  const SkipButton({
    required this.onTap,
    super.key,
});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: Alignment.topRight,
        child: const Padding(
          padding: EdgeInsets.only(top: 16.0, right: 45.0, bottom: 27.0,),
          child: Text(
            'Skip',
            style: TextStyle(
              color: Color(0xFF9B9999),
              fontSize: 16.0,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ),
    );
  }
}
