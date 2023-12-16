import 'package:flutter/material.dart';
import 'package:moing_flutter/board/component/icon_text_button.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_finish_page.dart';

import '../../const/style/elevated_button.dart';

class BoardMainBottomSheet extends StatelessWidget {
  final int teamId;

  const BoardMainBottomSheet({required this.teamId, super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconTextButton(
              onPressed: () {
                print('소모임원 탈퇴 구현하기!');
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  GroupFinishPage.routeName,
                  arguments: teamId,
                );
              },
              icon: 'asset/image/icon_delete.png',
              text: '소모임 탈퇴하기',
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: defaultButtonStyle,
                child: const Text('닫기'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
