import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class EveryMissionProfile extends StatelessWidget {
  final int index;
  const EveryMissionProfile({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: context.watch<MissionProveState>()
              .everyMissionList![index].profileImg == 'undef' ||
              context.watch<MissionProveState>()
                  .everyMissionList![index].profileImg == null
              ? Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: grayScaleGrey400,
            ),
          )
              : ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              context
                  .watch<MissionProveState>()
                  .everyMissionList![index]
                  .profileImg!,
              width: 24,
              height: 24,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          context
              .watch<MissionProveState>()
              .everyMissionList![index].nickname,
          style: bodyTextStyle.copyWith(color: grayScaleGrey100),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
