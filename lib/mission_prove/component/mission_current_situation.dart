import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_fire/mission_fire_page.dart';
import 'package:moing_flutter/mission_prove/component/prove_button/mission_fire_button.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class MissionCurrentSituation extends StatelessWidget {
  const MissionCurrentSituation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
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
                      if (context.watch<MissionProveState>().isRepeated &&
                          context.watch<MissionProveState>().isMeProved)
                        Container(
                          width: 72,
                          height: 72,
                          child: CircularPercentIndicator(
                            animationDuration: 1000,
                            backgroundColor: grayScaleGrey600,
                            radius: 36.0,
                            lineWidth: 3.0,
                            animation: true,
                            percent: context
                                    .read<MissionProveState>()
                                    .repeatMissionMyCount /
                                context
                                    .read<MissionProveState>()
                                    .repeatMissionTotalCount,
                            center: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${context.watch<MissionProveState>().repeatMissionMyCount}',
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
                                        "/",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,
                                            color: grayScaleGrey400),
                                      ),
                                      Text(
                                        '${context.watch<MissionProveState>().repeatMissionTotalCount}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,
                                            color: grayScaleGrey400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: coralGrey500,
                          ),
                        ),

                      /// 반복 미션이면서 내가 인증 안했을 때
                      if (context.watch<MissionProveState>().isRepeated &&
                          !context.watch<MissionProveState>().isMeProved)
                        Container(
                          width: 72,
                          height: 72,
                          child: CircularPercentIndicator(
                            backgroundColor: grayScaleGrey600,
                            radius: 36.0,
                            lineWidth: 3.0,
                            animation: true,
                            percent: context
                                    .read<MissionProveState>()
                                    .repeatMissionMyCount /
                                context
                                    .read<MissionProveState>()
                                    .repeatMissionTotalCount,
                            center: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${context.read<MissionProveState>().repeatMissionMyCount}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.0,
                                      color: grayScaleGrey100),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "/",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,
                                            color: grayScaleGrey400),
                                      ),
                                      Text(
                                        '${context.watch<MissionProveState>().repeatMissionTotalCount}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,
                                            color: grayScaleGrey400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: coralGrey500,
                          ),
                        ),
                      // 한번 미션이면서 내가 인증했을 때
                      if (!context.watch<MissionProveState>().isRepeated &&
                          context.watch<MissionProveState>().myMissionList !=
                              null &&
                          context
                              .watch<MissionProveState>()
                              .myMissionList!
                              .isNotEmpty)
                        Image.asset('asset/image/icon_mission_prove.png'),
                      // 한번 미션이면서 내가 인증 안 했을 때
                      if (!context.watch<MissionProveState>().isRepeated &&
                          (context.watch<MissionProveState>().myMissionList ==
                                  null ||
                              (context
                                          .watch<MissionProveState>()
                                          .myMissionList !=
                                      null &&
                                  context
                                      .watch<MissionProveState>()
                                      .myMissionList!
                                      .isEmpty)))
                        Image.asset('asset/image/icon_mission_not_yet.png'),
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
                                      Image.asset('asset/image/icon_clock.png'),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  !context.watch<MissionProveState>().isRepeated
                                      ? (context
                                                  .watch<MissionProveState>()
                                                  .missionRemainTime
                                                  .length <
                                              2
                                          ? ""
                                          : context
                                              .watch<MissionProveState>()
                                              .missionRemainTime)
                                      : '주 ${context.watch<MissionProveState>().repeatMissionTotalCount}회',
                                  style: bodyTextStyle,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                  context.watch<MissionProveState>().missionTitle,
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
            if (!context.watch<MissionProveState>().isRepeated)
              RoundedProgressBar(
                milliseconds: 1000,
                borderRadius: BorderRadius.circular(24),
                childLeft: Text(
                  '${context.watch<MissionProveState>().singleMissionMyCount}/${context.watch<MissionProveState>().singleMissionTotalCount}명 인증성공',
                  style: bodyTextStyle.copyWith(color: grayScaleGrey100),
                ),
                percent: context
                            .read<MissionProveState>()
                            .singleMissionTotalCount !=
                        0
                    ? context.read<MissionProveState>().singleMissionMyCount *
                        100 /
                        context
                            .read<MissionProveState>()
                            .singleMissionTotalCount
                    : 0,
                style: RoundedProgressBarStyle(
                  colorBorder: Colors.transparent,
                  colorProgress: coralGrey500,
                  backgroundProgress: grayScaleGrey600,
                  widthShadow: 0,
                ),
              ),
            // 반복 미션이면서 내가 인증했을 때
            if (context.watch<MissionProveState>().isRepeated)
              MissionFireButton(
                onPressed: context.read<MissionProveState>().firePressed,
              ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
