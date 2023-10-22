import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class HomeNoCard extends StatelessWidget {
  const HomeNoCard({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle ts = TextStyle(
        fontWeight: FontWeight.w500,
        color: grayScaleGrey400,
        height: 1.7,
        fontSize: 16);

    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          Text(
            '소모임에 가입해서\n잠자는 모잉불을 깨워주세요!',
            textAlign: TextAlign.center,
            style: ts,
          ),
          const SizedBox(height: 43,),
          Container(
            width: 133,
            height: 124,
            child: Image.asset(
              'asset/image/home_no_team_graphic.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
