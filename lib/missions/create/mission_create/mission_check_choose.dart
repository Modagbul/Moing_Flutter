import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/create/missions_create_state.dart';
import 'package:provider/provider.dart';

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
        _missionChooseButton(context: context, imagePath: 'asset/icons/icon_picture.svg', text: '사진으로 인증하기'),
        SizedBox(height: 12),
        _missionChooseButton(context: context, imagePath: 'asset/icons/icon_text.svg', text: '텍스트로 인증하기'),
        SizedBox(height: 12),
        _missionChooseButton(context: context, imagePath: 'asset/icons/icon_hyperlink.svg', text: '하이퍼링크로 인증하기'),
      ],
    );
  }

  Widget _missionChooseButton(
      {required BuildContext context, required String imagePath, required String text}) {
    final bool isSelected =
        context.watch<MissionCreateState>().selectedMethod == text;

    return GestureDetector(
      onTap: () {
        context.read<MissionCreateState>().setMethod(text);
      },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? grayScaleGrey100 : grayScaleGrey900,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SvgPicture.asset(
                imagePath,
                width: 24, height: 24,
                color: isSelected ? grayScaleGrey900 : grayScaleGrey550,
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
      ),
    );
  }
}
