import 'package:flutter/material.dart';
import 'package:moing_flutter/board/component/icon_text_button.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/fix_group/fix_group_page.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_finish_page.dart';
import 'package:moing_flutter/utils/alert_dialog/alert_dialog.dart';
import 'package:moing_flutter/utils/dynamic_link/dynamic_link.dart';
import 'package:share_plus/share_plus.dart';

import '../../const/style/elevated_button.dart';

class BoardMainBottomSheetLeader extends StatelessWidget {
  final int teamId;
  final bool isDeleted;
  final String teamName;

  const BoardMainBottomSheetLeader(
      {required this.teamId, required this.isDeleted, required this.teamName, super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.35,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconTextButton(
              onPressed: () async {
                DynamicLinkService dynamicLinkService =
                    DynamicLinkService(context: context);

                String link = await dynamicLinkService.getShortLink(
                  moingTitle: teamName,
                  route: "teamId=$teamId",
                );
                print('dynamic link : $link');
                Share.share(link, subject: teamName);
              },
              icon: 'asset/icons/icon_link_copy.svg',
              text: '소모임 초대 링크 복사하기',
            ),
            IconTextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  FixGroupPage.routeName,
                  arguments: teamId,
                );
              },
              icon: 'asset/icons/icon_edit.svg',
              text: '소모임 정보 수정하기',
            ),
            IconTextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (!isDeleted) {
                  Navigator.of(context).pushNamed(
                    GroupFinishPage.routeName,
                    arguments: teamId,
                  );
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ViewUtil().showSnackBar(
                      context: context,
                      message: '이미 소모임 삭제가 진행 중이에요',
                    );
                  });
                }
              },
              icon: 'asset/icons/icon_delete.svg',
              text: '소모임 삭제하기',
              color: isDeleted ? grayScaleGrey550 : null,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: defaultButtonStyle.copyWith(
                  elevation: MaterialStateProperty.all(0.0),
                ),
                child: const Text('닫기'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
