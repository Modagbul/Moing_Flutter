import 'package:flutter/material.dart';

class ImageOnBoard extends StatelessWidget {
  String imagePath;

  ImageOnBoard({
    required this.imagePath,
    super.key,
});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,),
      child: Image.asset(
        'asset/image/black.jpeg',
        fit: BoxFit.cover,
        width: 353,
        height: 353,
      ),
    );
  }
}
