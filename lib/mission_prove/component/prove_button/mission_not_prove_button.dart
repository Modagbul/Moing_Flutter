import 'package:flutter/material.dart';
import 'package:moing_flutter/config/amplitude_config.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:moing_flutter/utils/button/white_button.dart';
import 'package:provider/provider.dart';

class MissionNotProveButton extends StatelessWidget {
  const MissionNotProveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MissionProveState>();
      return Positioned(
        bottom: 20,
        left: 20,
        right: 20,
        // 내가 인증 안했으면 흰색 버튼, 인증했으면 버튼 비활성화
        child: (state.isMeProved ||
            (state.isRepeated && state.repeatMissionMyCount == state.repeatMissionTotalCount))
            ? ElevatedButton(
            onPressed: (){},
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              minimumSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 62)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(grayScaleGrey700),
            ),
            child: Text('미션 인증하기', style: buttonTextStyle.copyWith(color: grayScaleGrey500),))
        : WhiteButton(
            onPressed: () {
              context.read<MissionProveState>().showModal('mission');
              AmplitudeConfig.analytics.logEvent(
                  "misson_complete",
                  eventProperties: {
                    "mission_name": state.missionTitle});
            },
            text: '미션 인증하기'),
      );
  }
}
