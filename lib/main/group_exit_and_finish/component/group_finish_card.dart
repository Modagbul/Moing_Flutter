import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';

class ExitCard extends StatelessWidget {
  final String? number;
  final String? time;
  final String? missionClear;
  final String? level;

  const ExitCard({
    super.key,
    this.number,
    this.time,
    this.missionClear,
    this.level,
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
                          TextSpan(text: '함께 '),
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
                '소모임 강제종료 시 모든 모임원들은\n자동 탈퇴처리 돼요.\n3일의 안내기간이 지나면 삭제될 예정이에요.',
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
