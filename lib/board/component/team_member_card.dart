import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/model/response/single_board_team_member_info.dart';
import 'package:moing_flutter/utils/image_resize/image_resize.dart';

class TeamMemeberCard extends StatelessWidget {
  final TeamMemberInfo teamMemberInfo;

  const TeamMemeberCard({super.key, required this.teamMemberInfo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: teamMemberInfo.profileImage != null
              ? CachedNetworkImage(
                  imageUrl: teamMemberInfo.profileImage ?? '',
                  fit: BoxFit.cover,
                  width: 56,
                  height: 56,
                  memCacheWidth: 56.cacheSize(context),
                  memCacheHeight: 56.cacheSize(context),
                )
              : SvgPicture.asset(
                  'asset/icons/icon_user_profile.svg',
                  fit: BoxFit.cover,
                  width: 56,
                  height: 56,
                ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    teamMemberInfo.nickName,
                    style: const TextStyle(
                      color: grayScaleGrey100,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  if (teamMemberInfo.isLeader)
                    SvgPicture.asset(
                      'asset/icons/icon_crown.svg',
                      width: 14,
                      height: 14,
                    ),
                ],
              ),
              const SizedBox(height: 4.0),
              Text(
                teamMemberInfo.introduction ?? '아직 한 줄 다짐이 없어요',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  color: grayScaleGrey400,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
