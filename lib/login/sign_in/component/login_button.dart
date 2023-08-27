import 'package:flutter/material.dart';

class SocialSignButton extends StatelessWidget {
  final void Function() onTap;
  final String imagePath;

  const SocialSignButton({
    required this.onTap,
    required this.imagePath,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage(imagePath),
        width: 300,
        height: 45,
        child: InkWell(
          onTap: onTap,
        ),
      ),
    );
  }
}
