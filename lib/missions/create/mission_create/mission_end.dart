import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/create/mission_create/mission_expect_end/mission_certificate.dart';
import 'package:moing_flutter/missions/create/mission_create/mission_expect_end/mission_expect_end.dart';
import 'package:moing_flutter/missions/create/missions_create_state.dart';
import 'package:provider/provider.dart';

class MissionEndDate extends StatelessWidget {
  const MissionEndDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isRepeatMission = context.watch<MissionCreateState>().isRepeatSelected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 52),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '미션 마감일',
              style: contentTextStyle.copyWith(
                  fontWeight: FontWeight.w600, color: grayScaleGrey200),
            ),
            if (isRepeatMission)
              Text(
                '반복 미션은 매주 월요일에 다시 시작해요',
                style: contentTextStyle.copyWith(
                    fontWeight: FontWeight.w500, color: grayScaleGrey550, fontSize: 14),
              ),
          ],
        ),
        SizedBox(height: 24),
        MissionExpectEnd(),
        MissionCertificate(),
      ],
    );
  }
}
