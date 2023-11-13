import 'package:flutter/material.dart';

import '../../const/color/colors.dart';

class GroupSingleMissionCard extends StatelessWidget {
  final int missionId;
  final int? teamId;
  final String missionTitle;
  final String dueTo;
  final VoidCallback onTap;

  const GroupSingleMissionCard({
    super.key,
    required this.missionId,
    required this.teamId,
    required this.missionTitle,
    required this.dueTo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
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
                      missionTitle,
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
                          formatDueTo(dueTo),
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
        ),
      ],
    );
  }
}

String formatDueTo(String dueTo) {
  DateTime dueDate = DateTime.parse(dueTo);
  DateTime now = DateTime.now();

  Duration difference = dueDate.difference(now);

  int hours = difference.inHours;
  int minutes = difference.inMinutes - hours * 60;

  return '$hours시간 $minutes분 후 종료';
}
