import 'package:flutter/material.dart';

import '../../const/color/colors.dart';

class BoardCompletedMissionCard extends StatelessWidget {
  const BoardCompletedMissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 124,
          decoration: BoxDecoration(
            color: grayScaleGrey700,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 14, bottom: 20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MissionTag(),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        '2차 작업물 공유하기',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: grayScaleGrey100,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Row(
                        children: [
                          const Text(
                            '성공',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: grayScaleGrey400,
                            ),
                          ),
                          const SizedBox(
                            width: 6.0,
                          ),
                          Image.asset(
                            'asset/image/clock.png',
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          const Text(
                            '2023.08.10 종료',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: grayScaleGrey550,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Image.asset(
                    'asset/image/plus_btn.png',
                    width: 48.0,
                    height: 48.0,
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


class _MissionTag extends StatelessWidget {
  const _MissionTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 68,
          height: 27,
          decoration: BoxDecoration(
            color: grayScaleGrey500,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  '반복미션',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: grayScaleGrey400,
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
