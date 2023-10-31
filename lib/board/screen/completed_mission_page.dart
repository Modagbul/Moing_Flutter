import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/board/component/board_completed_mission_card.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import '../../missions/create/missions_create_page.dart';
import 'completed_mission_state.dart';

class CompletedMissionPage extends StatelessWidget {
  static const routeName = '/board/mission/completed';

  const CompletedMissionPage({super.key});

  static route(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    final int teamId = arguments as int;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                CompletedMissionState(context: context, teamId: teamId)),
      ],
      builder: (context, _) {
        return const CompletedMissionPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CompletedMissionState>();

    final data = state.completedMissionStatus?.data;
    if (data == null) {
      log('data is null');
    } else if (data.isEmpty) {
      log('data is empty');
    } else {
      log('data is not empty: $data');
    }

    return Scaffold(
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40.0,
            ),
            if (state.completedMissionStatus?.data.isNotEmpty ?? false)
              ...state.completedMissionStatus!.data
                  .map(
                    (e) => // ...
                        BoardCompletedMissionCard(
                      title: e.title,
                      status: e.status,
                      dueTo: e.dueTo,
                      missionType: e.missionType,
                      missionId: e.missionId,
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => MissionDetailPage(missionId: e.missionId),
                        //   ),
                        // );
                      },
                    ),
                  )
                  .toList()
            else
              const Expanded(
                child: Center(
                  child: Text(
                    '아직 미션이 없어요.',
                    style: TextStyle(
                      color: grayScaleGrey400,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            const Spacer(),
            const _BottomButton(),
          ],
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MissionsCreatePage.route(context),
              ),
            );
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(
              const Size(137, 51),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(grayScaleGrey100),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
          ),
          child: const Text(
            '만들기 +',
            style: TextStyle(
              color: grayScaleGrey700,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
