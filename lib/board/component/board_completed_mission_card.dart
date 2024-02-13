import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../const/color/colors.dart';

import 'package:intl/intl.dart';

class BoardCompletedMissionCard extends StatelessWidget {
  final String title;
  final String status;
  final String dueTo;
  final String missionType;
  final int missionId;

  const BoardCompletedMissionCard({
    super.key,
    required this.title,
    required this.status,
    required this.dueTo,
    required this.missionType,
    required this.missionId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 124,
            decoration: BoxDecoration(
              color: grayScaleGrey600,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 14, bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MissionTag(missionType: missionType),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
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
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            children: [
                              Text(
                                status == 'COMPLETE' || status == 'SKIP' ? '성공' : '실패',                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: grayScaleGrey400,
                                ),
                              ),
                              const SizedBox(
                                width: 6.0,
                              ),
                              SvgPicture.asset(
                                'asset/icons/mission_single_clock.svg',
                                width: 14,
                                height: 14,
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                formatDate(dueTo),
                                style: const TextStyle(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: SvgPicture.asset(
                      'asset/icons/mission_repeat_plus_btn.svg',
                      width: 48,
                      height: 48,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionTag extends StatelessWidget {
  final String missionType;

  const _MissionTag({super.key, required this.missionType}); // 여기 수정

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
                  missionType == 'ONCE' ? '한번미션' : '반복미션',
                  style: const TextStyle(
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

String formatDate(String dueTo) {
  DateTime dueDate = DateTime.parse(dueTo);
  return DateFormat('yyyy.MM.dd').format(dueDate) +
      ' 종료'; // "yyyy.MM.dd" 형식으로 변환
}
