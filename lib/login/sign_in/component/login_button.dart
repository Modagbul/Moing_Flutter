import 'package:flutter/material.dart';

class SocialSignButton extends StatelessWidget {
  final void Function() onTap;
  final String imagePath;

  const SocialSignButton(
      {required this.onTap, required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // 모서리를 둥글게 설정
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // 모서리를 둥글게 설정
        ),
        child: InkWell(
          onTap: onTap,
          child: Ink.image(
            image: AssetImage(imagePath),
            width: 300,
            height: 45,
          ),
        ),
      ),
    );
  }
}
