import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import '../../mission_prove/mission_prove_page.dart';
import '../component/group_repeat_mission_card.dart';
import '../component/group_single_mission_card.dart';
import 'missions_group_state.dart';
import 'missions_state.dart';

class MissionsGroupPage extends StatefulWidget {
  static const routeName = '/missons/group';

  const MissionsGroupPage({super.key});

  static route(BuildContext context) {
    final selectedTeamId =
        Provider.of<MissionsState>(context, listen: false).selectedTeamId;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MissionsState(
            context: context,
          ),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => MissionsGroupState(
            context: context,
            selectedTeamId: selectedTeamId,
          ),
          lazy: false,
        ),
      ],
      builder: (context, _) {
        return const MissionsGroupPage();
      },
    );
  }

  @override
  State<MissionsGroupPage> createState() => _MissionsGroupPageState();
}

class _MissionsGroupPageState extends State<MissionsGroupPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MissionsState>(
      builder: (context, missionsState, child) {
        final currentSelectedTeamId = missionsState.selectedTeamId;
        log('currentSelectedTeamId: $currentSelectedTeamId');

        return Consumer<MissionsGroupState>(
          builder: (context, state, child) {
            if (currentSelectedTeamId != null &&
                state.selectedTeamId != currentSelectedTeamId) {
              state.updateSelectedTeamId(currentSelectedTeamId);
            }

            final repeatMissionData =
                state.aggregateTeamRepeatMissionStatus?.data;

            // final currentSelectedTeamId = missionsState.selectedTeamId;
            // log('currentSelectedTeamId: $currentSelectedTeamId');
            //
            // final missionsGroupState =
            //     Provider.of<MissionsGroupState>(context, listen: false);
            //
            // if (currentSelectedTeamId != null &&
            //     missionsGroupState.selectedTeamId != currentSelectedTeamId) {
            //   missionsGroupState.updateSelectedTeamId(currentSelectedTeamId);
            // }

            // final state = context.watch<MissionsGroupState>();
            //
            // final data = state.aggregateTeamRepeatMissionStatus?.data;
            // if (data == null) {
            //   log('data is null');
            // } else if (data.isEmpty) {
            //   log('data is empty');
            // } else {
            //   log('data is not empty: $data');
            // }
            //
            // final singleMissionData = state.aggregateTeamSingleMissionStatus?.data;
            // if (singleMissionData == null) {
            //   log('singleMissionData is null');
            // } else {
            //   log('singleMissionData is not empty: $singleMissionData');
            // }

            return Scaffold(
              backgroundColor: grayBackground,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 52.0,
                      ),
                      _Title(
                        mainText: '한번 미션',
                        countText: '${state.aggregateTeamSingleMissionStatus?.data?.length ?? 0}',
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      if (state.aggregateTeamSingleMissionStatus?.data != null &&
                          state.aggregateTeamSingleMissionStatus!.data.isNotEmpty)
                        SizedBox(
                          height: 126,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.aggregateTeamSingleMissionStatus?.data.length,
                            itemBuilder: (context, index) {
                              final e = state.aggregateTeamSingleMissionStatus?.data[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GroupSingleMissionCard(
                                  missionId: e!.missionId,
                                  teamId: e.teamId,
                                  missionTitle: e.missionTitle,
                                  dueTo: e.dueTo,
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        MissionProvePage.routeName,
                                        arguments: {
                                          'isRepeated': false,
                                          'teamId': e.teamId,
                                          'missionId': e.missionId,
                                        });
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      else
                        const Center(
                          child: Text(
                            '아직 미션이 없어요.',
                            style: TextStyle(
                              color: grayScaleGrey400,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      _Title(
                        mainText: '반복 미션',
                        countText: '${repeatMissionData?.length ?? 0}',
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      if (repeatMissionData != null &&
                          repeatMissionData.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 170 / 249,
                          ),
                          itemCount: repeatMissionData.length,
                          itemBuilder: (context, index) {
                            final e = repeatMissionData[index];
                            return GroupRepeatMissionCard(
                              missionId: e.missionId,
                              teamId: e.teamId,
                              missionTitle: e.missionTitle,
                              totalNum: e.totalNum,
                              doneNum: e.doneNum,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    MissionProvePage.routeName,
                                    arguments: {
                                      'isRepeated': true,
                                      'teamId': e.teamId,
                                      'missionId': e.missionId,
                                    });
                              },
                            );
                          },
                        )
                      else
                        const Center(
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
            );
          },
        );
      },
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
