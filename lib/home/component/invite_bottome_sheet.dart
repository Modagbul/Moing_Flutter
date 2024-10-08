import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_first.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_zero.dart';

import '../../const/color/colors.dart';
import '../../utils/button/white_button.dart';

class InviteBottomSheet extends StatelessWidget {
  const InviteBottomSheet({super.key});

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
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => const TutorialZero(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 300), // 전환 지속시간 설정
              ));
              },
            text: '확인했어요',
          ),
        ],
      ),
    );
  }
}
