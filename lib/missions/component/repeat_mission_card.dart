import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../const/color/colors.dart';

class RepeatMissionCard extends StatelessWidget {
  final String teamName;
  final String missionTitle;
  final String totalNum;
  final String doneNum;

  const RepeatMissionCard({
    super.key,
    required this.teamName,
    required this.missionTitle,
    required this.totalNum,
    required this.doneNum,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  percent: 0.4,
                  center: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        totalNum,
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
                              doneNum,
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
                  footer: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      teamName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: grayScaleGrey550,
                      ),
                    ),
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
            /// ? 연동 안 하나?
            const Padding(
              padding: EdgeInsets.only(top: 8.0, left: 8.0),
              child: Text(
                '주 3회',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: grayScaleGrey550,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
