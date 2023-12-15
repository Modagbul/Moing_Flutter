import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_svg/svg.dart';
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
    var state = context.watch<MissionProveState>();
    
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
                      if (state.isRepeated &&
                          state.isMeProved)
                        Container(
                          width: 72,
                          height: 72,
                          child: CircularPercentIndicator(
                            animationDuration: 1000,
                            backgroundColor: grayScaleGrey600,
                            radius: 36.0,
                            lineWidth: 3.0,
                            animation: true,
                            percent: state.repeatMissionMyCount / state.repeatMissionTotalCount,
                            center: Row(
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
                                        "/",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,
                                            color: grayScaleGrey400),
                                      ),
                                      Text(
                                        '${state.repeatMissionTotalCount}',
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
                      if (state.isRepeated &&
                          !state.isMeProved)
                        Container(
                          width: 72,
                          height: 72,
                          child: CircularPercentIndicator(
                            backgroundColor: grayScaleGrey600,
                            radius: 36.0,
                            lineWidth: 3.0,
                            animation: true,
                            percent: state.repeatMissionMyCount / state.repeatMissionTotalCount,
                            center: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${state.repeatMissionMyCount}',
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
                                        '${state.repeatMissionTotalCount}',
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
                      if (!state.isRepeated && state.myMissionList != null &&
                          state.myMissionList!.isNotEmpty)
                        SvgPicture.asset(
                          'asset/icons/mission_icon_prove.svg',
                          width: 76,
                          height: 65,
                        ),
                      // 한번 미션이면서 내가 인증 안 했을 때
                      if (!state.isRepeated &&
                          (state.myMissionList == null ||
                              (state.myMissionList != null && state.myMissionList!.isEmpty)))
                        SvgPicture.asset(
                          'asset/icons/mission_icon_not_yet.svg',
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
                                /// 백에 status 추가 되면 로직 수정 해야함
                                // const _Tag(),
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
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// 백에 status 추가 되면 로직 수정 해야함
// class _Tag extends StatelessWidget {
//   const _Tag({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now();
//     String tagText = '';
//
//     if (now.weekday == DateTime.sunday) {
//       tagText = '내일 시작';
//     } else {
//       int daysToSunday = DateTime.sunday - now.weekday;
//       if (daysToSunday > 0) {
//         tagText = '${daysToSunday}일 후 시작';
//       } else if (now.weekday == DateTime.sunday) {
//         tagText = '내일 리셋';
//       }
//     }
//
//     return tagText.isNotEmpty
//         ? IntrinsicWidth(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 5),
//         decoration: BoxDecoration(
//           color: coralGrey900,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(5),
//           child: Row(
//             children: [
//               Image.asset(
//                 'asset/image/timer.png',
//                 width: 16.0,
//                 height: 16.0,
//               ),
//               const SizedBox(width: 1.0),
//               Flexible(
//                 child: Text(
//                   tagText,
//                   style: const TextStyle(
//                     fontSize: 14.0,
//                     fontWeight: FontWeight.w600,
//                     color: coralGrey300,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     )
//         : const SizedBox.shrink();
//   }
// }
