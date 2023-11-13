import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../const/color/colors.dart';

class GroupRepeatMissionCard extends StatelessWidget {
  final int missionId;
  final int? teamId;
  final String missionTitle;
  final String totalNum;
  final String doneNum;
  final VoidCallback onTap;

  const GroupRepeatMissionCard({
    super.key,
    required this.missionId,
    required this.teamId,
    required this.missionTitle,
    required this.totalNum,
    required this.doneNum,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    int done = int.tryParse(doneNum) ?? 0;
    int total = int.tryParse(totalNum) ?? 1;

    double percent = (total > 0) ? done / total : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              color: grayScaleGrey700,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularPercentIndicator(
                    backgroundColor: grayScaleGrey600,
                    radius: 60.0,
                    lineWidth: 3.0,
                    animation: true,
                    percent: percent,
                    center: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          doneNum,
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
                                totalNum,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 8.0),
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
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text(
                  '주 ${doneNum}회',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    color: grayScaleGrey550,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
