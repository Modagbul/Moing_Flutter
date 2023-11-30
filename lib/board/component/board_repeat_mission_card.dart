import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../const/color/colors.dart';

class BoardRepeatMissionCard extends StatelessWidget {
  final String title;
  final String dueTo;
  final String status;
  final int done;
  final int number;
  final int missionId;
  final VoidCallback onTap;
  final Animation<double> fadeAnimation;

  const BoardRepeatMissionCard({
    super.key,
    required this.title,
    required this.dueTo,
    required this.status,
    required this.done,
    required this.number,
    required this.missionId,
    required this.onTap,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    String tagText = _getTagText(status);

    return GestureDetector(
      onTap: (tagText == '내일 리셋' || tagText.isEmpty) ? onTap : null,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                    color: grayScaleGrey600,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularPercentIndicator(
                        backgroundColor: grayScaleGrey500,
                        radius: 60.0,
                        lineWidth: 3.0,
                        animation: true,
                        percent: done / number,
                        center: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              done.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 28.0,
                                  color: grayScaleGrey100),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Row(
                                children: [
                                  const Text(
                                    "/",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                        color: grayScaleGrey400),
                                  ),
                                  Text(
                                    number.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                        color: grayScaleGrey400),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: coralGrey500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 12),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: grayScaleGrey100,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Text(
                  '주 ${number}회',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    color: grayScaleGrey550,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: Platform.isIOS
                ? MediaQuery.of(context).size.height * 0.1
                : MediaQuery.of(context).size.height * 0.125,
            left: MediaQuery.of(context).size.width * 0.03,
            child: _Tag(status: status),
          ),
          Positioned.fill(
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    border: status == 'WAIT'
                        ? Border.all(color: coralGrey500, width: 1)
                        : null,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTagText(String status) {
    DateTime now = DateTime.now();
    String tagText = '';

    if (status == 'WAIT') {
      if (now.weekday == DateTime.sunday) {
        tagText = '내일 시작';
      } else {
        int daysToSunday = DateTime.sunday - now.weekday;
        if (daysToSunday > 0) {
          tagText = '${daysToSunday}일 후 시작';
        }
      }
    } else if (status == 'ONGOING' && now.weekday == DateTime.sunday) {
      tagText = '내일 리셋';
    }

    return tagText;
  }

}

class _Tag extends StatelessWidget {
  final String status;

  const _Tag({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String tagText = '';

    if (status == 'WAIT') {
      if (now.weekday == DateTime.sunday) {
        tagText = '내일 시작';
      } else {
        int daysToSunday = DateTime.sunday - now.weekday;
        if (daysToSunday > 0) {
          tagText = '${daysToSunday}일 후 시작';
        }
      }
    } else if (status == 'ONGOING' && now.weekday == DateTime.sunday) {
      tagText = '내일 리셋';
    }

    if (status == 'SKIP' || status == 'COMPLETE') {
      debugPrint('Status: $status');
    }

    return tagText.isNotEmpty
        ? IntrinsicWidth(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: coralGrey900,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Image.asset(
                      'asset/image/timer.png',
                      width: 16.0,
                      height: 16.0,
                    ),
                    const SizedBox(width: 1.0),
                    Flexible(
                      child: Text(
                        tagText,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: coralGrey300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
