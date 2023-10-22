import 'package:flutter/material.dart';

import '../../const/color/colors.dart';

class GroupSingleMissionCard extends StatelessWidget {
  final String missionName;
  final String missionTime;

  const GroupSingleMissionCard({super.key,
    required this.missionName,
    required this.missionTime,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            width: 272,
            height: 118,
            decoration: BoxDecoration(
              color: grayScaleGrey700,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 21.0, top: 19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Text(
                      missionName,
                      style: const TextStyle(
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
                        Text(
                          missionTime,
                          style: const TextStyle(
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
