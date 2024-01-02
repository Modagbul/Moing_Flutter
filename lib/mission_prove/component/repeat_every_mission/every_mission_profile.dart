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
