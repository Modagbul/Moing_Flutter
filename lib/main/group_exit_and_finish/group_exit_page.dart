import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/main/group_exit_and_finish/component/group_exit_card.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_finish_and_exit_state.dart';
import 'package:moing_flutter/utils/app_bar/moing_app_bar.dart';
import 'package:moing_flutter/utils/button/black_button.dart';
import 'package:moing_flutter/utils/button/white_button.dart';
import 'package:provider/provider.dart';

class GroupExitPage extends StatelessWidget {
  static const routeName = '/group/exit';

  const GroupExitPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GroupFinishExitState(context: context)),
      ],
      builder: (context, _) {
        return const GroupExitPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayScaleGrey900,
      appBar: MoingAppBar(
        title: '소모임 탈퇴',
        imagePath: 'asset/image/icon_exit.png',
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 44,
                ),
                Text(
                  '정말 모닥모닥불 모임과\n이별하시겠어요?',
                  style: headerTextStyle.copyWith(
                    color: grayScaleGrey100,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 62,),
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
                    if(context.watch<GroupFinishExitState>().exitCount == 0)
                      Positioned(
                        top: 101,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          width: double.infinity,
                          height: 137,
                          child: ExitCard(
                            number: '9',
                            time: '245',
                            missionClear: '78',
                            level: 'Lv.8',
                          ),
                        ),
                      )
                    else
                      Positioned(
                        top: 101,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          width: double.infinity,
                          height: 137,
                          child: ExitCard(),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 144,),
                Text(
                  '강제 종료 절차가 시작되면 그간의 데이터를\n복구할 수 없으니 신중하게 고민해주세요.',
                  style: bodyTextStyle.copyWith(
                    color: grayScaleGrey400,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: BlackButton(
                      onPressed: context.read<GroupFinishExitState>().exitPressed,
                      text: context.watch<GroupFinishExitState>().exitButtonText,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: WhiteButton(
                      onPressed: (){
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