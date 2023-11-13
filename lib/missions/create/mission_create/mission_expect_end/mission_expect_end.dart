import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/create/missions_create_state.dart';
import 'package:provider/provider.dart';

class MissionExpectEnd extends StatelessWidget {
  const MissionExpectEnd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 미션 반복 개수가 2개 이상인 경우
    if (context.watch<MissionCreateState>().repeatMissions > 1) {
      return Container(
        width: double.infinity,
        height: 48,
        child: Row(
          children: [
            Text(
              '반복미션 불가',
              style: contentTextStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: errorColor,
              ),
            ),
            SizedBox(width: 4),
            Text(
              '2개의 반복미션이 있어 더 만들 수 없어요',
              style: contentTextStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: grayScaleGrey550,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: 48,
        child: GestureDetector(
          onTap: context.read<MissionCreateState>().setRepeatSelected,
          child: Row(
            children: [
              Icon(Icons.check_box_rounded,
                  color:
                      context.watch<MissionCreateState>().isRepeatSelected ==
                              true
                          ? Colors.white
                          : grayScaleGrey550,
                  size: 20),
              SizedBox(width: 12),
              Text(
                '반복미션으로 변경하기',
                style: contentTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
