// OngoingMissionPage.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import '../component/board_repeat_mission_card.dart';
import '../component/board_single_mission_card.dart';
import 'ongoing_misson_state.dart';

class OngoingMissionPage extends StatelessWidget {
  static const routeName = '/board/mission/ongoing';

  const OngoingMissionPage({Key? key}) : super(key: key);

  static route(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    final int teamId = arguments as int;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                OngoingMissionState(context: context, teamId: teamId)),
      ],
      builder: (context, _) {
        return OngoingMissionPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OngoingMissionState>();

    final data = state.repeatMissionStatus?.data;
    if (data == null) {
      log('data is null');
    } else if (data.isEmpty) {
      log('data is empty');
    } else {
      log('data is not empty: $data');
    }

    final singleMissionData = state.singleMissionStatus?.data;
    if (singleMissionData == null) {
      log('singleMissionData is null');
    } else {
      log('singleMissionData is not empty: $singleMissionData');
    }

    return Scaffold(
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40.0,
              ),
              _Title(
                mainText: '반복 미션',
                countText:
                    '${context.watch<OngoingMissionState>().repeatMissionStatus?.data.length ?? 0}',
              ),
              const SizedBox(
                height: 12.0,
              ),
              if (state.repeatMissionStatus?.data.isNotEmpty ?? false)
                ...state.repeatMissionStatus!.data
                    .map(
                      (e) => // ...
                          BoardRepeatMissionCard(
                        title: e.title,
                        dueTo: e.dueTo,
                        done: e.done,
                        number: e.number,
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
              const SizedBox(
                height: 40.0,
              ),
              _Title(
                mainText: '한번 미션',
                countText:
                    '${context.watch<OngoingMissionState>().singleMissionStatus?.data.length ?? 0}',
              ),
              const SizedBox(
                height: 12.0,
              ),
              if (state.singleMissionStatus?.data.isNotEmpty ?? false)
                ...state.singleMissionStatus!.data
                    .map(
                      (e) => // ...
                          BoardSingleMissionCard(
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
              _BottomButton(),
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
          style: TextStyle(
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
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: grayScaleGrey400,
          ),
        ),
      ],
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
          onPressed: () {},
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
