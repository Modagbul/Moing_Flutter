import 'package:flutter/material.dart';

class ImagePhase extends StatelessWidget {
  final String phase1;
  final String phase2;
  final String phase3;

  const ImagePhase({
    required this.phase1,
    required this.phase2,
    required this.phase3,
    super.key,
});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
            phase1,
        ),
        const SizedBox(width: 8.0,),
        Image.asset(
            phase2,
        ),
        const SizedBox(width: 8.0,),
        Image.asset(
            phase3,
        ),
      ],
    );
  }
}
