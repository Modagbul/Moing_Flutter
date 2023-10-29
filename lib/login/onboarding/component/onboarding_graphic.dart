import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnBoardingGraphic extends StatelessWidget {
  final String graphicPath;
  const OnBoardingGraphic({required this.graphicPath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Lottie.asset(graphicPath,
        width: double.infinity,
        height: 353
        ),
      ],
    );
  }
}
