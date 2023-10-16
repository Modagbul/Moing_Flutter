import 'package:flutter/material.dart';

import '../../const/color/colors.dart';

class SingleMissionCard extends StatelessWidget {
  const SingleMissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            width: 272,
            height: 126,
            decoration: BoxDecoration(
              color: grayScaleGrey700,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 21.0, top: 19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      '모닥모닥불',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: grayScaleGrey400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      '작업한 내용 인증하기',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: grayScaleGrey100,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'asset/image/clock.png',
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        const Text(
                          '13시간 11분 후 종료',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: grayScaleGrey550,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
