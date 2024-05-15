import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class EveryMissionProfile extends StatelessWidget {
  final int index;
  const EveryMissionProfile({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int commentsCount = context.watch<MissionProveState>().everyMissionList![index].comments ?? 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: context.watch<MissionProveState>()
              .everyMissionList![index].profileImg == 'undef' ||
              context.watch<MissionProveState>()
                  .everyMissionList![index].profileImg == null
              ? ClipOval(
                  child: SvgPicture.asset(
                    'asset/icons/icon_user_profile.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                )
              : ClipOval(
            child: Image.network(
              context.watch<MissionProveState>()
                  .everyMissionList![index]
                  .profileImg!,
              width: 20,
              height: 20,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return ClipOval(
                  child: SvgPicture.asset(
                    'asset/icons/home_card_user.svg',
                    width: 20,
                    height: 20,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 90,
          child: Text(
            context.watch<MissionProveState>().everyMissionList![index].nickname,
            style: bodyTextStyle.copyWith(color: grayScaleGrey100),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            SvgPicture.asset(
              'asset/icons/message.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
              color: grayScaleGrey400,
            ),
            const SizedBox(width: 4),
            Text(
              commentsCount > 99 ? '99+' : commentsCount.toString(),
              style: bodyTextStyle.copyWith(color: grayScaleGrey400),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
