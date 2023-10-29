import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/create/missions_create_state.dart';
import 'package:provider/provider.dart';

class MissionCertificate extends StatelessWidget {
  const MissionCertificate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.watch<MissionCreateState>().repeatMission < 2 &&
        context.watch<MissionCreateState>().isRepeatSelected == true) {
      return Stack(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 12,
            ),
            height: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: grayScaleGrey700,
            ),
            child: Text(
              '인증횟수 설정하기',
              style: contentTextStyle.copyWith(color: grayScaleGrey550),
            ),
          ),
          Positioned(
            right: 12,
            top: 8,
            bottom: 8,
            child: Row(
              children: [
                Container(
                    alignment: Alignment.center,
                    width: 111,
                    height: 46,
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: grayScaleGrey500),
                    child: GestureDetector(
                      onTap: context
                          .read<MissionCreateState>()
                          .openCertificateCountModal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context
                                    .watch<MissionCreateState>()
                                    .missionCountList[
                                context
                                    .watch<MissionCreateState>()
                                    .missionCountIndex],
                            style: buttonTextStyle.copyWith(
                                color: grayScaleGrey200),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: grayScaleGrey200,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ],
      );
    }

    /// 수정 예정
    else {
      return Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16),
            width: 271,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: grayScaleGrey700,
            ),
            child: GestureDetector(
              onTap: context.read<MissionCreateState>().datePicker,
              child: Row(
                children: [
                  Text(
                    context.watch<MissionCreateState>().formattedDate.length > 1
                        ? context.watch<MissionCreateState>().formattedDate
                        : '마감 날짜 선택하기',
                    style: contentTextStyle.copyWith(color: grayScaleGrey100),
                  ),
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: context.read<MissionCreateState>().timePicker,
            child: Container(
              alignment: Alignment.center,
              width: 75,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: grayScaleGrey700,
              ),
              child: Text(
    context.watch<MissionCreateState>().formattedTime.length > 1
    ? context.watch<MissionCreateState>().formattedTime
        : '10:00',
                style: contentTextStyle.copyWith(color: grayScaleGrey100),
              ),
            ),
          ),
        ],
      );
    }
  }
}
