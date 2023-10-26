import 'package:flutter/material.dart';
import 'package:moing_flutter/board/component/icon_text_button.dart';

import '../../const/style/elevated_button.dart';

class BoardMainBottomSheet extends StatelessWidget {
  const BoardMainBottomSheet({super.key});

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
              onPressed: () {},
              icon: 'asset/image/icon_link.png',
              text: '소모임 초대 링크 복사하기',
            ),
            IconTextButton(
              onPressed: () {},
              icon: 'asset/image/icon_edit.png',
              text: '소모임 정보 수정하기',
            ),
            IconTextButton(
              onPressed: () {},
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
