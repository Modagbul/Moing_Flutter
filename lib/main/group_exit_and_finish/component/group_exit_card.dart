import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';

class ExitCard extends StatelessWidget {
  final String? number;
  final String? time;
  final String? missionClear;
  final String? level;
  final String? nickname;

  const ExitCard({
    super.key,
    this.number,
    this.time,
    this.missionClear,
    this.level,
    this.nickname,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: grayScaleGrey600,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (number != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: contentTextStyle,
                      children: [
                        TextSpan(text: '총 '),
                        TextSpan(
                          text: number,
                          style: contentTextStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: '명의 소모임원들과 '),
                        TextSpan(
                          text: time,
                          style: contentTextStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: '시간을 함께했어요'),
                      ],
                    ),
                  ),
                ],
              ),
            if (number != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: contentTextStyle,
                        children: [
                          TextSpan(text: '${nickname}님은 '),
                          TextSpan(
                            text: missionClear,
                            style: contentTextStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: '개의 미션을 진행했어요'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (number != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: contentTextStyle,
                        children: [
                          TextSpan(text: '모잉불을 '),
                          TextSpan(
                            text: level,
                            style: contentTextStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: '만큼 키웠어요'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (number == null)
              Text(
                '탈퇴 시 ${nickname}님의\n해당 소모임 미션활동 정보가 삭제돼요.\n초대코드를 통해 다시 들어올 수 있어요.',
                style: contentTextStyle.copyWith(
                    color: grayScaleGrey300,
                    height: 1.5
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );

  }
}
