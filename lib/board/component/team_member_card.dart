import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/model/response/single_board_team_member_info.dart';

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
              ? Image.network(
                  teamMemberInfo.profileImage ?? '',
                  fit: BoxFit.cover,
                  width: 56,
                  height: 56,
                )
              : Image.asset(
                  'asset/image/icon_user_profile.png',
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
                    Image.asset(
                      'asset/image/icon_crown.png',
                      width: 14.0,
                      height: 14.0,
                    ),
                ],
              ),
              const SizedBox(height: 4.0),
              Text(
                teamMemberInfo.introduction ?? '',
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
