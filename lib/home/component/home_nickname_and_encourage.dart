import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class HomeText extends StatelessWidget {
  final String nickName;
  final String encourage;
  const HomeText({
    required this.nickName,
    required this.encourage,
    super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle ts = const TextStyle(
      color: grayScaleGrey100,
      fontWeight: FontWeight.w600,
      fontSize: 24.0,
      height: 1.5,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nickName,
          style: ts,
        ),
        Text(
            '오늘도 모잉이 응원해요 🔥',
          style: ts,
        ),
      ],
    );
  }
}
