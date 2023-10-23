import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/init/init_state.dart';
import 'package:moing_flutter/missions/missions_all_state.dart';
import 'package:provider/provider.dart';

import '../const/color/colors.dart';
import 'component/repeat_mission_card.dart';
import 'component/single_mission_card.dart';

class MissionsAllPage extends StatelessWidget {
  static const routeName = '/missons/all';

  const MissionsAllPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MissionsAllState(context: context),
          lazy: false,
        ),
      ],
      builder: (context, _) {
        return const MissionsAllPage();
      },
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
            const SingleMissionCard(teamName: '모닥모닥불', missionName: '작업한 내용 인증하기', missionTime: '13시간 11분 후 종료'),
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

