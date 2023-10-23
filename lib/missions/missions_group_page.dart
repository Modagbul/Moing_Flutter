import 'package:flutter/material.dart';
import 'package:moing_flutter/missions/component/repeat_mission_card.dart';
import 'package:provider/provider.dart';

import '../const/color/colors.dart';
import 'component/group_single_mission_card.dart';
import 'missions_group_state.dart';
import 'missions_state.dart';

class MissionsGroupPage extends StatelessWidget {
  static const routeName = '/missons/group';

  const MissionsGroupPage({super.key});

  static route(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MissionsGroupState(),
      child: const MissionsGroupPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 52.0,
              ),
              _Title(mainText: '한번 미션', countText: '1'),
              const SizedBox(
                height: 12.0,
              ),
              const GroupSingleMissionCard(missionName: '작업한 내용 인증하기', missionTime: '작업한 내용 인증하기'),
              const SizedBox(
                height: 40.0,
              ),
              _Title(mainText: '반복 미션', countText: '1'),
              const SizedBox(
                height: 12.0,
              ),
              const RepeatMissionCard(teamName: '미라모닝', missionTitle: '평일 오전 7시 기상', totalNum: '2', doneNum: '5'),
            ],
          ),
        ),
    );
  }
}

class _Title extends StatelessWidget {
  final String mainText;
  final String countText;

  _Title({
    required this.mainText,
    required this.countText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          mainText,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: grayScaleGrey100,
          ),
        ),
        const SizedBox(
          width: 4.0,
        ),
        Text(
          countText,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: grayScaleGrey400,
          ),
        ),
      ],
    );
  }
}
