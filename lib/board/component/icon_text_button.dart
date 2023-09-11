import 'package:flutter/material.dart';

import '../../const/color/colors.dart';

class IconTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;
  final String text;

  const IconTextButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 32.0,
            height: 32.0,
          ),
          const SizedBox(width: 24.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: grayScaleGrey200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
