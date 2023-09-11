import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/elevated_button.dart';

class BoardGoalBottomSheet extends StatelessWidget {
  const BoardGoalBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.4,
      decoration: const BoxDecoration(
        color: grayScaleGrey600,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: brightButtonStyle.copyWith(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0), // 변경하고자 하는 값으로 설정
                  ),
                ),
              ),
              child: const Text('미션 인증하고 불 키우기'),
            ),
          ],
        ),
      ),
    );
  }
}
