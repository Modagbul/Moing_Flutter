import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class MissionFireButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MissionFireButton({required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        animationDuration: (context.watch<MissionProveState>().myMissionList == null ||
            context.watch<MissionProveState>().myMissionList!.isNotEmpty) ? Duration(milliseconds: 200): Duration(milliseconds: 0),
        fixedSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width, 56),
        ),
        backgroundColor: MaterialStateProperty.all(grayScaleGrey900),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48.0),
            side: BorderSide(
              width: 1,
              color: context.watch<MissionProveState>().isMeProved
                  ? Color(0xff9B9999)
                  : grayScaleGrey550,
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
          (context.watch<MissionProveState>().myMissionList == null ||
              context.watch<MissionProveState>().myMissionList!.isNotEmpty)
              ? '친구들에게 불 던지러 가기'
              : '인증을 완료하고 불을 던져요',
          style: contentTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: (context.watch<MissionProveState>().myMissionList == null ||
                context.watch<MissionProveState>().myMissionList!.isNotEmpty)
                ? grayScaleGrey200 : grayScaleGrey550,
          ),),
          if ((context.watch<MissionProveState>().myMissionList == null ||
              context.watch<MissionProveState>().myMissionList!.isNotEmpty))
            Image.asset(
              'asset/image/icon_fire_mono_white.png',
              width: 24,
              height: 24,
            ),
        ],
      ),
    );
  }
}
