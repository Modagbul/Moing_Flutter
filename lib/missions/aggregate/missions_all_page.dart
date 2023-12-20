import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/mission_prove/component/mission_prove_argument.dart';
import 'package:moing_flutter/missions/aggregate/missions_all_state.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import '../../mission_prove/mission_prove_page.dart';
import '../component/repeat_mission_card.dart';
import '../component/single_mission_card.dart';

class MissionsAllPage extends StatelessWidget {
  static const routeName = '/missons/all';

  const MissionsAllPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MissionsAllState(
            context: context,
          ),
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
    final state = context.watch<MissionsAllState>();
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
                    '${context.watch<MissionsAllState>().aggregateSingleMissionStatus?.data.length ?? 0}',
              ),
              const SizedBox(
                height: 12.0,
              ),
              if (state.aggregateSingleMissionStatus?.data != null &&
                  state.aggregateSingleMissionStatus!.data.isNotEmpty)
                SizedBox(
                  height: 126,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.aggregateSingleMissionStatus!.data.length,
                    itemBuilder: (context, index) {
                      final e = state.aggregateSingleMissionStatus!.data[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: SingleMissionCard(
                          missionId: e.missionId,
                          teamId: e.teamId,
                          teamName: e.teamName,
                          missionTitle: e.missionTitle,
                          dueTo: e.dueTo,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              MissionProvePage.routeName,
                              arguments: MissionProveArgument(
                                  isRepeated: false,
                                  teamId: e.teamId,
                                  missionId: e.missionId,
                                  status: e.status)
                            ).then((_) {
                              Provider.of<MissionsAllState>(context,
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
                  visible: state.aggregateSingleMissionStatus?.data.isEmpty ?? true,
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
                    '${context.watch<MissionsAllState>().aggregateRepeatMissionStatus?.data.length ?? 0}',
              ),
              const SizedBox(
                height: 12.0,
              ),
              if (state.aggregateRepeatMissionStatus?.data != null &&
                  state.aggregateRepeatMissionStatus!.data.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 170 / 249,
                  ),
                  itemCount: state.aggregateRepeatMissionStatus!.data.length,
                  itemBuilder: (context, index) {
                    final e = state.aggregateRepeatMissionStatus!.data[index];
                    return RepeatMissionCard(
                      missionId: e.missionId,
                      teamName: e.teamName,
                      missionTitle: e.missionTitle,
                      totalNum: e.totalNum,
                      doneNum: e.doneNum,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          MissionProvePage.routeName,
                            arguments: MissionProveArgument(
                                isRepeated: true,
                                teamId: e.teamId,
                                missionId: e.missionId,
                                status: e.status)
                        ).then((_) {
                          Provider.of<MissionsAllState>(context, listen: false)
                              .reloadMissionStatus();
                        });
                      },
                    );
                  },
                )
              else
                Visibility(
                  visible: state.aggregateRepeatMissionStatus?.data.isEmpty ?? true,
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
              const SizedBox(
                height: 59.0,
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
