import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/main/group_exit_and_finish/component/group_finish_card.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_finish_and_exit_state.dart';
import 'package:moing_flutter/utils/app_bar/moing_app_bar.dart';
import 'package:moing_flutter/utils/button/black_button.dart';
import 'package:moing_flutter/utils/button/white_button.dart';
import 'package:provider/provider.dart';

class GroupFinishPage extends StatelessWidget {
  static const routeName = '/group/finish';

  const GroupFinishPage({super.key});

  static route(BuildContext context) {
    final int teamId = ModalRoute.of(context)?.settings.arguments as int;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => GroupFinishExitState(
                context: context, teamId: teamId, text: '', teamName: null)),
      ],
      builder: (context, _) {
        return const GroupFinishPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<GroupFinishExitState>();
    return Scaffold(
      appBar: MoingAppBar(
        title: state.teamInfo?.isLeader == true ? '소모임 강제종료' : '소모임 탈퇴',
        imagePath: 'asset/icons/icon_close.svg',
        onTap: () => Navigator.pop(context, true),
      ),
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  '정말 ${state.teamInfo?.teamName ?? '해당'} 모임과\n이별하시겠어요?',
                  style: headerTextStyle.copyWith(
                    color: grayScaleGrey100,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 62),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 240,
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          'asset/image/moing_icon_sad.png',
                          fit: BoxFit.none,
                        ),
                      ),
                    ),
                    if (state.finishCount == 0 && state.teamInfo != null)
                      Positioned(
                        top: 101,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          width: double.infinity,
                          height: 137,
                          child: ExitCard(
                            number: state.teamInfo!.numOfMember.toString(),
                            time: state.teamInfo!.duration.toString(),
                            missionClear:
                                state.teamInfo!.numOfMission.toString(),
                            level: 'Lv.${state.teamInfo!.levelOfFire}',
                          ),
                        ),
                      ),
                    if (state.finishCount != 0)
                      Positioned(
                        top: 101,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          width: double.infinity,
                          height: 137,
                          child: ExitCard(isLeader: state.teamInfo!.isLeader),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    '강제 종료 절차가 시작되면 그간의 데이터를\n복구할 수 없으니 신중하게 고민해주세요.',
                    style: bodyTextStyle.copyWith(
                      color: grayScaleGrey400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: BlackButton(
                      color: grayScaleGrey900,
                      onPressed:
                          context.read<GroupFinishExitState>().finishPressed,
                      text: state.finishButtonText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: WhiteButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: '다시 생각해볼게요',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
