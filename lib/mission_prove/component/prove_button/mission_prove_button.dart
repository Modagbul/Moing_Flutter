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
    var state = context.watch<MissionProveState>();
    return Positioned(
      bottom: 32,
      left: 70,
      right: 70,
      child: ElevatedButton(
        onPressed: () {
          print('불 던지러 가기 버튼 클릭');
          if(state.myMissionList != null && state.myMissionList!.isNotEmpty) {
            Navigator.of(context)
                .pushNamed(MissionFirePage.routeName, arguments: {
              'teamId': context.read<MissionProveState>().teamId,
              'missionId': context.read<MissionProveState>().missionId,
            });
          }
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
    );
  }
}
