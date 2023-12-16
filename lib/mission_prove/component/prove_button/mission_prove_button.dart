import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_fire/mission_fire_page.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class MissionProveButton extends StatelessWidget {
  const MissionProveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 70,
      right: 70,
      child: ElevatedButton(
        onPressed: () {
          // // 내가 인증한 경우
          // if(context.watch<MissionProveState>().isMeProved) {
          //
          // }
          // // 인증 안한 경우
          // else {
          //
          // }
          Navigator.of(context)
              .pushNamed(MissionFirePage.routeName, arguments: {
            'teamId': context.read<MissionProveState>().teamId,
            'missionId': context.read<MissionProveState>().missionId,
          });
        },
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(
            Size(224, 62),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(48.0),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '불 던지러 가기',
              style: buttonTextStyle,
            ),
            SizedBox(width: 8),
            SvgPicture.asset(
              'asset/icons/icon_fire_black.svg',
              width: 24.0,
              height: 24.0,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
      // child: Stack(
      //   children: [
      //     Column(
      //       children: [
      //         // Padding(
      //         //   padding: const EdgeInsets.symmetric(horizontal: 32.0),
      //         //   child: Row(
      //         //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         //     children: [
      //         //       if (context.watch<MissionProveState>().isMeOrEveryProved)
      //         //         ElevatedButton(
      //         //           onPressed: () {},
      //         //           style: ButtonStyle(
      //         //             fixedSize: MaterialStateProperty.all(
      //         //               Size(138, 50),
      //         //             ),
      //         //             backgroundColor:
      //         //                 MaterialStateProperty.all(grayScaleGrey600),
      //         //             shape: MaterialStateProperty.all(
      //         //               RoundedRectangleBorder(
      //         //                 borderRadius: BorderRadius.circular(24.0),
      //         //               ),
      //         //             ),
      //         //           ),
      //         //           child: Row(
      //         //             mainAxisAlignment: MainAxisAlignment.center,
      //         //             children: [
      //         //               Text(
      //         //                 '좋아요',
      //         //                 style: contentTextStyle.copyWith(
      //         //                   color: grayScaleGrey100,
      //         //                   fontWeight: FontWeight.w600,
      //         //                 ),
      //         //               ),
      //         //               SizedBox(width: 4),
      //         //               Text(
      //         //                 context
      //         //                     .watch<MissionProveState>()
      //         //                     .myMissionList![0]
      //         //                     .hearts
      //         //                     .toString(),
      //         //                 style: contentTextStyle.copyWith(
      //         //                   color: coralGrey500,
      //         //                   fontWeight: FontWeight.w600,
      //         //                 ),
      //         //               ),
      //         //             ],
      //         //           ),
      //         //         ),
      //         //       if (context
      //         //               .watch<MissionProveState>()
      //         //               .missionWay
      //         //               .contains('사진') &&
      //         //           context
      //         //                   .watch<MissionProveState>()
      //         //                   .myMissionList![0]
      //         //                   .status ==
      //         //               'COMPLETE')
      //         //         ElevatedButton(
      //         //           onPressed: context
      //         //               .read<MissionProveState>()
      //         //               .missionShareDialog,
      //         //           style: ButtonStyle(
      //         //             fixedSize: MaterialStateProperty.all(
      //         //               Size(138, 50),
      //         //             ),
      //         //             backgroundColor:
      //         //                 MaterialStateProperty.all(grayScaleGrey600),
      //         //             shape: MaterialStateProperty.all(
      //         //               RoundedRectangleBorder(
      //         //                 borderRadius: BorderRadius.circular(24.0),
      //         //               ),
      //         //             ),
      //         //           ),
      //         //           child: Text(
      //         //             '공유하기',
      //         //             style: contentTextStyle.copyWith(
      //         //               color: grayScaleGrey100,
      //         //               fontWeight: FontWeight.w600,
      //         //             ),
      //         //           ),
      //         //         ),
      //         //     ],
      //         //   ),
      //         // ),
      //         // SizedBox(height: 20),
      //         // ElevatedButton(
      //         //   onPressed: () {
      //         //     // // 내가 인증한 경우
      //         //     // if(context.watch<MissionProveState>().isMeProved) {
      //         //     //
      //         //     // }
      //         //     // // 인증 안한 경우
      //         //     // else {
      //         //     //
      //         //     // }
      //         //     Navigator.of(context)
      //         //         .pushNamed(MissionFirePage.routeName, arguments: {
      //         //       'teamId': context.read<MissionProveState>().teamId,
      //         //       'missionId': context.read<MissionProveState>().missionId,
      //         //     });
      //         //   },
      //         //   style: ButtonStyle(
      //         //     fixedSize: MaterialStateProperty.all(
      //         //       Size(224, 62),
      //         //     ),
      //         //     backgroundColor: MaterialStateProperty.all(Colors.white),
      //         //     shape: MaterialStateProperty.all(
      //         //       RoundedRectangleBorder(
      //         //         borderRadius: BorderRadius.circular(48.0),
      //         //       ),
      //         //     ),
      //         //   ),
      //         //   child: Row(
      //         //     mainAxisAlignment: MainAxisAlignment.center,
      //         //     children: [
      //         //       Text(
      //         //         '불 던지러 가기',
      //         //         style: buttonTextStyle,
      //         //       ),
      //         //       SizedBox(width: 8),
      //         //       Image.asset(
      //         //         'asset/image/icon_fire_black.png',
      //         //         height: 20,
      //         //         width: 20,
      //         //       ),
      //         //     ],
      //         //   ),
      //         // )
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
