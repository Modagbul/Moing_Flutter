import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
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
                        // CircularPercentIndicator(
                        //   backgroundColor: grayScaleGrey600,
                        //   radius: 60.0,
                        //   lineWidth: 3.0,
                        //   animation: true,
                        //   percent: done / number,
                        //   center: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         done.toString(),
                        //         style: const TextStyle(
                        //             fontWeight: FontWeight.w600,
                        //             fontSize: 28.0,
                        //             color: grayScaleGrey100),
                        //       ),
                        //       Padding(
                        //         padding: const EdgeInsets.only(top: 18.0),
                        //         child: Row(
                        //           children: [
                        //             const Text(
                        //               "/",
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w600,
                        //                   fontSize: 16.0,
                        //                   color: grayScaleGrey400),
                        //             ),
                        //             Text(
                        //               number.toString(),
                        //               style: const TextStyle(
                        //                   fontWeight: FontWeight.w600,
                        //                   fontSize: 16.0,
                        //                   color: grayScaleGrey400),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        //   circularStrokeCap: CircularStrokeCap.round,
                        //   progressColor: coralGrey500,
                        // ),
                      // 반복 미션이면서 내가 인증 안했을 때
                      if (context.watch<MissionProveState>().isRepeated &&
                          !context.watch<MissionProveState>().isMeProved)
                        Text('반복미션 나의 인증 X..', style: TextStyle(color: Colors.white),),
                      // 한번 미션이면서 내가 인증했을 때
                      if (!context.watch<MissionProveState>().isRepeated &&
                          context.watch<MissionProveState>().isMeProved)
                        Image.asset('asset/image/icon_mission_prove.png'),
                      // 한번 미션이면서 내가 인증 안 했을 때
                      if (!context.watch<MissionProveState>().isRepeated &&
                          !context.watch<MissionProveState>().isMeProved)
                        Image.asset('asset/image/icon_mission_not_yet.png'),
                      SizedBox(width: 16),
                      Column(
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
                                '13시간 11분 후 종료',
                                style: bodyTextStyle,
                              )
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(context.watch<MissionProveState>().missionTitle, style: middleTextStyle),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            RoundedProgressBar(
              milliseconds: 1000,
              borderRadius: BorderRadius.circular(24),
              childLeft: Text(
                '3/9명 인증성공',
                style: bodyTextStyle.copyWith(color: grayScaleGrey100),
              ),
              percent: 40,
              style: RoundedProgressBarStyle(
                colorBorder: Colors.transparent,
                colorProgress: coralGrey500,
                backgroundProgress: grayScaleGrey600,
                widthShadow: 0,
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
