import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../const/color/colors.dart';
import '../../../utils/button/white_button.dart';
import '../tutorial_zero.dart';

class TutorialBottomSheet extends StatelessWidget {
  const TutorialBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            children: [
              Text(
                '소모임에 초대받았나요?',
                style: TextStyle(
                  color: grayScaleGrey100,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '모임장에게 받은 초대장 링크를 눌러주세요',
                style: TextStyle(
                  color: grayScaleGrey400,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SvgPicture.asset(
            'asset/image/img_invite.svg',
            fit: BoxFit.cover,
            height: 200,
          ),
          WhiteButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                TutorialZero.routeName,
              );
            },
            text: '확인했어요',
          ),
        ],
      ),
    );
  }
}
