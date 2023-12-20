import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final String imagePath;
  final ButtonStyle buttonStyle;

  CustomButton({
    required this.onPressed,
    required this.text,
    required this.imagePath,
    required this.buttonStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Row(
          children: [
            Padding(
              padding: imagePath.contains('kakao')
                  ? const EdgeInsets.only(left: 2.0)
                  : EdgeInsets.zero,
              child: SvgPicture.asset(
                imagePath,
                width: imagePath.contains('kakao')
                    ? 22
                    : imagePath.contains('google')
                    ? 22
                    : 24,
                height: imagePath.contains('kakao')
                    ? 20.89
                    : imagePath.contains('google')
                    ? 22
                    : 24,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 30.0,),
          ],
        ),
      ),
    );
  }
}
