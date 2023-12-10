import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moing_flutter/mission_prove/mission_prove_page.dart';
import 'package:provider/provider.dart';
import 'package:speech_balloon/speech_balloon.dart';

import '../../const/color/colors.dart';
import '../../const/style/text.dart';
import '../../missions/create/missions_create_page.dart';
import '../component/board_repeat_mission_card.dart';
import '../component/board_single_mission_card.dart';
import 'ongoing_misson_state.dart';

class OngoingMissionPage extends StatefulWidget {
  static const routeName = '/board/mission/ongoing';
  const OngoingMissionPage({Key? key}) : super(key: key);


  static route(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final int teamId = arguments['teamId'];
    print('미션 인증에서 teamId : $teamId');

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
  State<OngoingMissionPage> createState() => _OngoingMissionPageState();
}

class _OngoingMissionPageState extends State<OngoingMissionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  void handleMissionTap(BuildContext context, int missionId, bool isRepeated) {
    Navigator.of(context).pushNamed(
      MissionProvePage.routeName,
      arguments: {
        'isRepeated': isRepeated,
        'teamId': context.read<OngoingMissionState>().teamId,
        'missionId': missionId,
      },
    ).then((_) {
      context.read<OngoingMissionState>().reloadMissionStatus();
    });
  }

  final FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    fToast.removeCustomToast();
    super.dispose();
  }

  void showToast(String message) {
    fToast.showToast(
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 51,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Text(
              message,
              style: bodyTextStyle.copyWith(
                color: grayScaleGrey700,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      toastDuration: const Duration(milliseconds: 3000),
      positionedToastBuilder: (context, child) {
        return Positioned(
          top: 114.0,
          left: 0.0,
          right: 0,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OngoingMissionState>();
    final data = state.repeatMissionStatus?.data;
    if (data == null) {
      log('repeatMissionData is null');
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
          child: SingleChildScrollView(
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
                if (state.repeatMissionStatus?.data != null &&
                    state.repeatMissionStatus!.data.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 170 / 245,
                    ),
                    itemCount: state.repeatMissionStatus!.data.length,
                    itemBuilder: (context, index) {
                      final e = state.repeatMissionStatus!.data[index];
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          BoardRepeatMissionCard(
                            ftoast: fToast,
                            title: e.title,
                            dueTo: e.dueTo,
                            done: e.done,
                            number: e.number,
                            missionId: e.missionId,
                            status: e.status,
                            fadeAnimation: _fadeAnimation,
                            onShowToast: showToast,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                MissionProvePage.routeName,
                                arguments: {
                                  'isRepeated': true,
                                  'teamId': context
                                      .read<OngoingMissionState>()
                                      .teamId,
                                  'missionId': e.missionId,
                                },
                              ).then((_) {
                                Provider.of<OngoingMissionState>(context,
                                        listen: false)
                                    .reloadMissionStatus();
                              });
                            },
                          ),
                          if (e.status == "WAIT")
                            Positioned(
                              top: -25,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: SpeechBalloon(
                                  color: coralGrey500,
                                  width: 91,
                                  height: 33,
                                  borderRadius: 24,
                                  nipLocation: NipLocation.bottom,
                                  child: Center(
                                    child: Text(
                                      'NEW 미션',
                                      style: bodyTextStyle.copyWith(
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  )
                else
                  Visibility(
                    visible: state.repeatMissionStatus?.data.isEmpty ?? true,
                    replacement: const SizedBox(height: 182),
                    child: const SizedBox(
                      height: 182,
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
                  ),
                const SizedBox(height: 24.0),
                _Title(
                  mainText: '한번 미션',
                  countText:
                      '${context.watch<OngoingMissionState>().singleMissionStatus?.data.length ?? 0}',
                ),
                const SizedBox(
                  height: 12.0,
                ),
                if (state.singleMissionStatus?.data != null &&
                    state.singleMissionStatus!.data.isNotEmpty)
                  ...state.singleMissionStatus!.data
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              BoardSingleMissionCard(
                                title: e.title,
                                status: e.status,
                                dueTo: e.dueTo,
                                missionType: e.missionType,
                                missionId: e.missionId,
                                fadeAnimation: _fadeAnimation,
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    MissionProvePage.routeName,
                                    arguments: {
                                      'isRepeated': false,
                                      'teamId': context
                                          .read<OngoingMissionState>()
                                          .teamId,
                                      'missionId': e.missionId,
                                    },
                                  ).then((_) {
                                    Provider.of<OngoingMissionState>(context,
                                            listen: false)
                                        .reloadMissionStatus();
                                  });
                                },
                              ),
                              if (e.status == "WAIT")
                                Positioned(
                                  top: -25,
                                  right: 15,
                                  child: FadeTransition(
                                    opacity: _fadeAnimation,
                                    child: SpeechBalloon(
                                      color: coralGrey500,
                                      width: 91,
                                      height: 33,
                                      borderRadius: 24,
                                      nipLocation: NipLocation.bottom,
                                      child: Center(
                                        child: Text(
                                          'NEW 미션',
                                          style: bodyTextStyle.copyWith(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                      .toList()
                else
                  Visibility(
                    visible: state.singleMissionStatus?.data.isEmpty ?? true,
                    replacement: const SizedBox(height: 126),
                    child: const SizedBox(
                      height: 126,
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
                  ),
                const SizedBox(height: 100.0),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: (state.isLeader != null && state.isLeader!) ? const _BottomButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

class _BottomButton extends StatelessWidget {
  const _BottomButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final ongoingMissionState =
            Provider.of<OngoingMissionState>(context, listen: false);
        var result = await Navigator.of(context)
            .pushNamed(MissionsCreatePage.routeName, arguments: {
          'teamId': ongoingMissionState.teamId,
          'repeatMissions':
              ongoingMissionState.repeatMissionStatus?.data.length ?? 0,
        });

        if (result != null && result == true) {
          print('미션 만들기 성공!!');
          ongoingMissionState.initState();
        }
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

String formatDueTo(String dueToString) {
  DateTime dueTo = DateTime.parse(dueToString);
  DateTime now = DateTime.now();
  Duration difference = dueTo.difference(now);

  if (difference.isNegative) {
    return '기한 종료';
  } else if (difference.inDays == 0) {
    int hours = difference.inHours;
    int minutes = difference.inMinutes % 60;
    if (hours > 0) {
      return '${hours}시간 ${minutes}분 후 종료';
    } else if (minutes > 0) {
      return '${minutes}분 후 종료';
    } else {
      return '기한 종료';
    }
  } else {
    String formattedString = '';
    if (difference.inDays > 0) {
      formattedString += '${difference.inDays}일 ';
    }
    int hours = difference.inHours % 24;
    if (hours > 0) {
      formattedString += '$hours시간 ';
    }
    int minutes = difference.inMinutes % 60;
    if (minutes > 0) {
      formattedString += '$minutes분 ';
    }
    return formattedString + '후 종료';
  }
}
