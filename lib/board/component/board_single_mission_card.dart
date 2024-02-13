import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../const/color/colors.dart';

class BoardSingleMissionCard extends StatelessWidget {
  final String title;
  final String status;
  final String dueTo;
  final String missionType;
  final int missionId;
  final bool isRead;
  final VoidCallback onTap;
  final Animation<double> fadeAnimation;

  const BoardSingleMissionCard({
    super.key,
    required this.title,
    required this.status,
    required this.dueTo,
    required this.missionType,
    required this.missionId,
    required this.isRead,
    required this.onTap,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 92,
                decoration: BoxDecoration(
                  color: grayScaleGrey700,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 20, bottom: 20),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        status == 'COMPLETE' || status == 'SKIP'
                            ? 'asset/icons/board_icon_pass.svg'
                            : 'asset/icons/board_icon_nopass.svg',
                        width: 36.0,
                        height: 36.0,
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Image.asset('asset/image/clock.png'),
                                SvgPicture.asset(
                                  'asset/icons/mission_single_clock.svg',
                                  width: 14,
                                  height: 14,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  formatDueTo(dueTo),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    color: grayScaleGrey550,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: grayScaleGrey100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      status == 'COMPLETE' || status == 'SKIP' // 현황보기
                          ? _CompleteButton(
                              onTap: onTap,
                            )
                          : _SkipButton(onTap: onTap),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: FadeTransition(
              opacity: fadeAnimation,
              child: IgnorePointer(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 95,
                    decoration: BoxDecoration(
                      border: isRead == false
                          ? Border.all(color: coralGrey500, width: 1)
                          : null,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SkipButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 87,
      height: 43,
      margin: const EdgeInsets.only(right: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: grayScaleWhite,
          padding: const EdgeInsets.all(12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
        ),
        onPressed: onTap,
        child: const Text(
          '인증하기',
          style: TextStyle(
            color: grayScaleGrey700,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _CompleteButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CompleteButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 87,
      height: 43,
      margin: const EdgeInsets.only(right: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: grayScaleGrey500,
          padding: const EdgeInsets.all(12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
        ),
        onPressed: onTap,
        child: const Text(
          '현황보기',
          style: TextStyle(
            color: grayScaleGrey300,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
