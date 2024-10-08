import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_fire/mission_fire_page.dart';
import 'package:moing_flutter/mission_prove/component/mission_content_rule.dart';
import 'package:moing_flutter/mission_prove/component/prove_button/mission_fire_button.dart';
import 'package:moing_flutter/mission_prove/component/repeat_mission_tag/repeat_mission_start_tag.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class MissionCurrentSituation extends StatelessWidget {
  const MissionCurrentSituation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MissionProveState>();
    
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              width: double.infinity,
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 반복 미션이면서 내가 인증했을 때
                      if (state.isRepeated)
                        ClipOval(
                          child: Container(
                            width: 72,
                            height: 72,
                            color: state.isEnded ? grayScaleGrey500 : Colors.transparent,
                            child: CircularPercentIndicator(
                              animationDuration: 1000,
                              backgroundColor: grayScaleGrey600,
                              radius: 36.0,
                              lineWidth: 3.0,
                              animation: true,
                              percent: state.repeatMissionMyCount / state.repeatMissionTotalCount,
                              center: state.isEnded == false ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${state.repeatMissionMyCount}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20.0,
                                        color: grayScaleGrey100),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "/${state.repeatMissionTotalCount}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.0,
                                              color: grayScaleGrey400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ) : Center(child: Text('종료',
                                style: middleTextStyle.copyWith(color: grayScaleGrey100),)),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: coralGrey500,
                            ),
                          ),
                        ),
                      /// 한번 미션이면서 내가 인증했을 때
                      if (!state.isRepeated && state.myMissionList != null &&
                          state.myMissionList!.isNotEmpty)
                        SvgPicture.asset(
                          state.isEnded ? 'asset/icons/mission_success.svg'
                              :'asset/icons/mission_icon_prove.svg',
                          width: 76,
                          height: 65,
                        ),
                      /// 한번 미션이면서 내가 인증 안 했을 때
                      if (!state.isRepeated &&
                          (state.myMissionList == null ||
                              (state.myMissionList != null && state.myMissionList!.isEmpty)))
                        SvgPicture.asset(
                          state.isEnded ? 'asset/icons/mission_fail.svg'
                              : 'asset/icons/mission_icon_not_yet.svg',
                          width: 76,
                          height: 65,
                        ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child:
                                  SvgPicture.asset(
                                    'asset/icons/mission_clock.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  !state.isRepeated
                                      ? (state.missionRemainTime.length < 2
                                      ? ""
                                      : state.missionRemainTime)
                                      : '주 ${state.repeatMissionTotalCount}회',
                                  style: bodyTextStyle,
                                ),
                                const Spacer(),
                                if(state.repeatMissionStatus == 'WAIT' && state.isRepeated)
                                RepeatMissionTag(),
                              ],
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                  state.missionTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: middleTextStyle),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // 한번 미션인 경우
            if (!state.isRepeated)
              RoundedProgressBar(
                milliseconds: 1000,
                borderRadius: BorderRadius.circular(24),
                childLeft: Text(
                  '${state.singleMissionMyCount}/${state.singleMissionTotalCount}명 인증성공',
                  style: bodyTextStyle.copyWith(color: grayScaleGrey100),
                ),
                percent: state.singleMissionTotalCount != 0
                    ? state.singleMissionMyCount * 100 / state.singleMissionTotalCount
                    : 0,
                style: RoundedProgressBarStyle(
                  colorBorder: Colors.transparent,
                  colorProgress: coralGrey500,
                  backgroundProgress: grayScaleGrey600,
                  widthShadow: 0,
                ),
              ),
            // 반복 미션이면서 내가 인증했을 때
            if (state.isRepeated)
              MissionFireButton(
                onPressed: state.firePressed,
              ),
            MissionContentAndRule(),
            // const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
