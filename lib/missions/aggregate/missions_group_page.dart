import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/mission_prove/component/mission_prove_argument.dart';
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
    final selectedTeamId = Provider.of<MissionsState>(context, listen: false).teams.isNotEmpty
        ? Provider.of<MissionsState>(context, listen: false).teams[0].teamId
        : null;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MissionsGroupState(
            context: context,
            selectedTeamId: selectedTeamId ?? 0,
          ),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => MissionsState(
            context: context,
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

    final state = context.watch<MissionsGroupState>();
    log('Building MissionsGroupPage with state: ${state.selectedTeamId}');

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
                countText:
                    '${state.aggregateTeamSingleMissionStatus?.data.length ?? 0}',
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
                    itemCount:
                        state.aggregateTeamSingleMissionStatus?.data.length,
                    itemBuilder: (context, index) {
                      final e = state.aggregateTeamSingleMissionStatus?.data[index];
                      print('e : ${e.toString()}');
                      log('Building item: ${e?.missionTitle}');

                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: GroupSingleMissionCard(
                          missionId: e!.missionId,
                          teamId: e.teamId,
                          teamName: e.teamName,
                          missionTitle: e.missionTitle,
                          dueTo: e.dueTo,
                          done: e.done,
                          total: e.total,
                          status: e.status,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                MissionProvePage.routeName,
                                arguments: MissionProveArgument(
                                  isRepeated: false,
                                  teamId: e.teamId,
                                  missionId: e.missionId,
                                  status: e.status,
                                  isEnded: false,
                                  isRead: true,
                                ),
                            ).then((_) {
                              Provider.of<MissionsGroupState>(context,
                                  listen: false)
                                  .reloadMissionStatus();
                            });
                          },
                        ),
                      );
                    },
                  ),
                )
              else
                Visibility(
                  visible: state.aggregateTeamSingleMissionStatus?.data.isEmpty ?? true,
                  replacement: const SizedBox(height: 126),
                  child: const SizedBox(
                    height: 126,
                    child: Center(
                      child: Text(
                        '진행 중인 한번 미션이 없어요.',
                        style: TextStyle(
                          color: grayScaleGrey400,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 40.0,
              ),
              _Title(
                mainText: '반복 미션',
                countText:
                    '${state.aggregateTeamRepeatMissionStatus?.data?.length ?? 0}',
              ),
              const SizedBox(
                height: 12.0,
              ),
              if (state.aggregateTeamRepeatMissionStatus?.data != null &&
                  state.aggregateTeamRepeatMissionStatus!.data.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 170 / 249,
                  ),
                  itemCount:
                      state.aggregateTeamRepeatMissionStatus?.data.length,
                  itemBuilder: (context, index) {
                    final e =
                        state.aggregateTeamRepeatMissionStatus?.data[index];
                    return GroupRepeatMissionCard(
                      missionId: e!.missionId,
                      teamId: e.teamId,
                      teamName: e.teamName,
                      missionTitle: e.missionTitle,
                      totalNum: e.totalNum,
                      doneNum: e.doneNum,
                      donePeople: e.donePeople,
                      totalPeople: e.totalPeople,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          MissionProvePage.routeName,
                          arguments: MissionProveArgument(
                            isRepeated: true,
                            teamId: e.teamId,
                            missionId: e.missionId,
                            status: e.status,
                            isEnded: false,
                            isRead: true,
                          ),
                        ).then((_) {
                          Provider.of<MissionsGroupState>(
                              context, listen: false).reloadMissionStatus();
                        });
                      },
                    );
                  },
                )
              else
                Visibility(
                  visible: state.aggregateTeamRepeatMissionStatus?.data.isEmpty ?? true,
                  replacement: const SizedBox(height: 182),
                  child: const SizedBox(
                    height: 182,
                    child: Center(
                      child: Text(
                        '진행 중인 반복 미션이 없어요.',
                        style: TextStyle(
                          color: grayScaleGrey400,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
