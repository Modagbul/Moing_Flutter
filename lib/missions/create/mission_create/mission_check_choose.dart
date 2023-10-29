import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';

class MissionChoose extends StatelessWidget {
  const MissionChoose({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 60),
        Text(
          '인증방식',
          style: contentTextStyle.copyWith(
              fontWeight: FontWeight.w600, color: grayScaleGrey200),
        ),
        SizedBox(height: 24),
        _missionChooseButton(context: context, imagePath: 'asset/image/icon_picture.png', text: '사진으로 인증하기'),
        SizedBox(height: 12),
        _missionChooseButton(context: context, imagePath: 'asset/image/icon_text.png', text: '텍스트로 인증하기'),
        SizedBox(height: 12),
        _missionChooseButton(context: context, imagePath: 'asset/image/icon_hyperlink.png', text: '하이퍼링크로 인증하기'),
      ],
    );
  }

  Widget _missionChooseButton(
      {required BuildContext context, required String imagePath, required String text}) {
    // final bool isSelected =
    //     context.watch<SignUpGenderState>().selectedGender == gender;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: grayScaleGrey900,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              imagePath,
              width: 24, height: 24,
            ),
          ),
          const SizedBox(width: 56),
          Text(
            text,
            style: contentTextStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: grayScaleGrey550,
            ),
          )
        ],
      ),
    );
  }
}
