import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_fire/mission_fire_state.dart';
import 'package:provider/provider.dart';

class MissionFireProgressBar extends StatelessWidget {
  const MissionFireProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int singleMissionMyCount = context.watch<MissionFireState>().singleMissionMyCount;
    final int singleMissionTotalCount = context.watch<MissionFireState>().singleMissionTotalCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        const Text(
          '불 던지기',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: grayScaleGrey100,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '모임원 발등에 불을 던져 미션 인증을 독려해요',
          style: contentTextStyle,
        ),
        const SizedBox(height: 24),
        RoundedProgressBar(
          borderRadius: BorderRadius.circular(24),
          childLeft: Text(
            '${singleMissionMyCount}/$singleMissionTotalCount명 인증성공',
            style: bodyTextStyle.copyWith(color: grayScaleGrey100),
          ),
          percent: singleMissionMyCount < singleMissionTotalCount
              ? (singleMissionMyCount) *
              100 /
              singleMissionTotalCount
              : 0,

          style: RoundedProgressBarStyle(
            colorBorder: Colors.transparent,
            colorProgress: coralGrey500,
            backgroundProgress: grayScaleGrey600,
            widthShadow: 0,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
