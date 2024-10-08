import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/board/component/board_completed_mission_card.dart';
import 'package:moing_flutter/mission_prove/component/mission_prove_argument.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/response/board_repeat_mission_response.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import '../../mission_prove/mission_prove_page.dart';
import '../../missions/create/missions_create_page.dart';
import 'completed_mission_state.dart';

class CompletedMissionPage extends StatelessWidget {
  static const routeName = '/board/mission/completed';
  const CompletedMissionPage({Key? key}) : super(key: key);

  static route(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    final int teamId = arguments['teamId'] as int;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                CompletedMissionState(context: context, teamId: teamId)),
      ],
      builder: (context, _) {
        return CompletedMissionPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CompletedMissionState>();
    print(
        'state.completedMissionStatus?.data.isNotEmpty : ${state.completedMissionStatus?.data.isNotEmpty}');
    return Scaffold(
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40.0,
              ),
              if ((state.completedMissionStatus != null &&
                  state.completedMissionStatus!.data.isNotEmpty))
                ...state.completedMissionStatus!.data
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                MissionProvePage.routeName,
                                arguments: MissionProveArgument(
                                  isRepeated: e.missionType == 'ONCE' ? false : true,
                                  teamId: context
                                      .read<CompletedMissionState>()
                                      .teamId,
                                  missionId: e.missionId,
                                  status: e.status,
                                  isEnded: true,
                                  isRead: true,
                                ));
                          },
                          child: BoardCompletedMissionCard(
                          title: e.title,
                          status: e.status,
                          dueTo: e.dueTo,
                          missionType: e.missionType,
                          missionId: e.missionId,
                      ),
                        ),
                    ),
                  ).toList()
            else const Center(
                child: Text(
                  '아직 미션이 없어요.',
                  style: TextStyle(
                    color: grayScaleGrey400,
                    fontSize: 14.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
      floatingActionButton: const _BottomButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton();

  @override
  Widget build(BuildContext context) {
    final completeMissionState = Provider.of<CompletedMissionState>(context, listen: false);
    return FloatingActionButton.extended(
      onPressed: () async {
        var teamId = context.read<CompletedMissionState>().teamId;
        ApiCode apiCode = ApiCode();
        RepeatMissionStatusResponse? repeatMissionStatus = await apiCode.getRepeatMissionStatus(teamId: teamId);

        Navigator.of(context).pushNamed(
          MissionsCreatePage.routeName,
          arguments: {
           'teamId': teamId,
            'repeatMissions': repeatMissionStatus?.data.length ?? 0,
            'isLeader': completeMissionState.isLeader,
          }
        );
      },
      backgroundColor: grayScaleGrey100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
      label: const Text(
        '만들기 +',
        style: TextStyle(
          color: grayScaleGrey700,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
