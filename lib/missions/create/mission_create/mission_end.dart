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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 52),
        Text(
          '미션 마감일',
          style: contentTextStyle.copyWith(
              fontWeight: FontWeight.w600, color: grayScaleGrey200),
        ),
        SizedBox(height: 24),
        MissionExpectEnd(),
        MissionCertificate(),
      ],
    );
  }
}
