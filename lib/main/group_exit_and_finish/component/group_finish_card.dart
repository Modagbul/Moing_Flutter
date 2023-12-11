import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_finish_and_exit_state.dart';
import 'package:provider/provider.dart';

class ExitCard extends StatelessWidget {
  final String? number;
  final String? time;
  final String? missionClear;
  final String? level;
  final bool? isLeader;

  const ExitCard({
    Key? key,
    this.number,
    this.time,
    this.missionClear,
    this.level,
    this.isLeader,
  }) : super(key: key);

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
                        TextSpan(text: '일을 함께했어요'),
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
            if (isLeader != null)
              Text(
                context.watch<GroupFinishExitState>().exitDescription,
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
