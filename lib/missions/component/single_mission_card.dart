import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import '../aggregate/missions_all_state.dart';

class SingleMissionCard extends StatelessWidget {
  final int missionId;
  final int teamId;
  final String teamName;
  final String missionTitle;
  final String dueTo;
  final String status;
  final String done;
  final String total;
  final VoidCallback onTap;

  const SingleMissionCard({
    super.key,
    required this.missionId,
    required this.teamId,
    required this.teamName,
    required this.missionTitle,
    required this.dueTo,
    required this.onTap,
    required this.status,
    required this.done,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {

    String formattedDueTo = (status == 'COMPLETE' || status == 'SKIP') ? '인증완료' : formatDueTo(dueTo);
    Color textColor = (status == 'COMPLETE' || status == 'SKIP')  ? coralGrey500 : grayScaleGrey550;
    String completionText = (status == 'COMPLETE' || status == 'SKIP')
        ? '$done/$total이 인증했어요'
        : '$done명이 벌써 인증했어요';
    Color textColor2 = (status == 'COMPLETE' || status == 'SKIP') ? grayScaleGrey400 : grayScaleWhite;
    Color containerColor = (status == 'COMPLETE' || status == 'SKIP')  ? grayScaleGrey500 : coralGrey500;
    String clockAssetPath = (status == 'COMPLETE' || status == 'SKIP')
        ? 'asset/icons/mission_single_clock_col.svg'
        : 'asset/icons/mission_single_clock.svg';
    String tickCircleAssetPath = (status == 'COMPLETE' || status == 'SKIP')
        ? 'asset/icons/icon_tick_circle_white.svg'
        : 'asset/icons/icon_tick_circle.svg';

    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 272,
            height: 126,
            decoration: BoxDecoration(
              color: grayScaleGrey700,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      missionTitle,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: grayScaleGrey100,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'asset/icons/icon_team_home.svg',
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          teamName.length > 7 ? '${teamName.substring(0, 7)}...' : teamName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            color: grayScaleGrey550,
                          ),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        SvgPicture.asset(
                          clockAssetPath,
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          formattedDueTo.length > 17 ? '${formattedDueTo.substring(0, 17)}...' : formattedDueTo,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            overflow: TextOverflow.ellipsis,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 16.0),
                    child: Container(
                      width: 240,
                      height: 40,
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            tickCircleAssetPath,
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            completionText,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: textColor2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String formatDueTo(String dueToString) {
  DateTime dueTo = DateTime.parse(dueToString);
  DateTime now = DateTime.now();
  Duration difference = dueTo.difference(now);

  if (difference.isNegative) {
    return '기한 종료';
  } else {
    String formattedString = '';
    if (difference.inDays > 0) {
      formattedString += '${difference.inDays}일 ';
    }
    int hours = difference.inHours % 24;
    if (hours > 0) {
      formattedString += '$hours시간 ';
    }
    int minutes = difference.inMinutes % 60;
    if (minutes > 0) {
      formattedString += '$minutes분 ';
    }
    return '$formattedString후 종료';
  }
}
