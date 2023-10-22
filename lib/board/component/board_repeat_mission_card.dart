import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../const/color/colors.dart';

class BoardRepeatMissionCard extends StatelessWidget {
  const BoardRepeatMissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
                      percent: 1,
                      center: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "2",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 28.0,
                                color: grayScaleGrey100),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 18.0),
                            child: Text(
                              "/2",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: grayScaleGrey400),
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
                  padding: EdgeInsets.only(top: 12.0, left: 8.0),
                  child: Text(
                    '독서기록 쓰기',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: grayScaleGrey100,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Text(
                    '주 2회',
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
        ),
        Positioned(
          bottom: 70,
          left: 10.0,
          child: _Tag(),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 87,
          height: 25,
          decoration: BoxDecoration(
            color: coralGrey900,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                const SizedBox(width: 1.0),
                Image.asset(
                  'asset/image/timer.png',
                  width: 16.0,
                  height: 16.0,
                ),
                const SizedBox(width: 1.0),
                Text(
                  '내일 리셋',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: coralGrey300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}