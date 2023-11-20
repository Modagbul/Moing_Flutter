import 'package:flutter/material.dart';
import 'package:moing_flutter/board/component/icon_text_button.dart';
import 'package:moing_flutter/fix_group/fix_group_page.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_finish_page.dart';
import 'package:moing_flutter/utils/dynamic_link/dynamic_link.dart';

import '../../const/style/elevated_button.dart';

class BoardMainBottomSheetLeader extends StatelessWidget {
  final int teamId;

  const BoardMainBottomSheetLeader({
    required this.teamId, super.key});

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
                DynamicLinkService dynamicLinkService = DynamicLinkService(context: context);

                String link = await dynamicLinkService.getShortLink(
                    route: "counselor/uniqueId=1234",);
                print('dynamic link : $link');
              },
              icon: 'asset/image/icon_link.png',
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
              icon: 'asset/image/icon_edit.png',
              text: '소모임 정보 수정하기',
            ),
            IconTextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  GroupFinishPage.routeName,
                  arguments: teamId,
                );
              },
              icon: 'asset/image/icon_delete.png',
              text: '소모임 삭제하기',
            ),
            ElevatedButton(
              onPressed: () {},
              style: defaultButtonStyle,
              child: const Text('닫기'),
            )
          ],
        ),
      ),
    );
  }
}
