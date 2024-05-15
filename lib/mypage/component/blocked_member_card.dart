import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/utils/image_resize/image_resize.dart';
import 'package:provider/provider.dart';

import '../../make_group/component/warning_dialog.dart';
import '../blocked_users_state.dart';

class BlockedMemberCard extends StatelessWidget {
  final int targetId;
  final String nickName;
  final String introduce;
  final String profileImg;

  const BlockedMemberCard({
    super.key,
    required this.targetId,
    required this.nickName,
    required this.introduce,
    required this.profileImg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: profileImg.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: profileImg,
                  fit: BoxFit.cover,
                  width: 56,
                  height: 56,
                  memCacheWidth: 56.cacheSize(context),
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
              Text(
                nickName,
                style: const TextStyle(
                  color: grayScaleGrey100,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                introduce.isNotEmpty ? introduce : '아직 한 줄 다짐이 없어요',
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
        ),
        TextButton(
          onPressed: () {
            _showQuestionDialog(context);
          },
          child: const Text(
            '차단해제',
            style: TextStyle(
              color: errorColor,
            ),
          ),
        ),
      ],
    );
  }

  void _showQuestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WarningDialog(
              title: '$nickName님을 해제하시겠어요?',
              content: '차단한 이용자의 콘텐츠가 다시 표시돼요',
              leftText: '취소하기',
              onCanceled: () {
                Navigator.of(ctx).pop();
              },
              rightText: '해제하기',
              onConfirm: () async {
                await Provider.of<BlockedUsersState>(context, listen: false)
                    .unblockUser(
                  targetId: targetId,
                  nickName: nickName,
                );

                Provider.of<BlockedUsersState>(context, listen: false)
                    .reloadBlockedMemberStatus();

                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
