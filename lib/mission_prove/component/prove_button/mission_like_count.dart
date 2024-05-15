import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class MissionLikeButton extends StatelessWidget {
  const MissionLikeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MissionProveState>();
    int comments = state.myMissionList![0].comments ?? 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          'asset/icons/mission_like.svg',
          width: 20,
          height: 20,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 4),
        Text(
          state.myMissionList![0].hearts.toString(),
          style: contentTextStyle.copyWith(color: grayScaleGrey400,),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => context.read<MissionProveState>().getMissionDetailContent(0),
          child: Row(
            children: [
              SvgPicture.asset(
                'asset/icons/message.svg',
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 4),
              Text(
                comments > 99 ? "99+" : comments.toString(),
                style: contentTextStyle.copyWith(color: grayScaleGrey400,),
              ),
            ],
          ),
        ),
        const Spacer(),
        if (state.missionWay.contains('사진') &&
            state.myMissionList![0].status == 'COMPLETE')
          GestureDetector(
            onTap: context.read<MissionProveState>().missionShareDialog,
            child: Row(
              children: [
                SvgPicture.asset(
                  'asset/icons/mission_image_upload.svg',
                  width: 20,
                  height: 20,
                  color: grayScaleGrey300,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 4),
                Text(
                  '이미지 저장',
                  style: bodyTextStyle.copyWith(
                      color: grayScaleGrey300, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
