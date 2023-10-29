import 'package:flutter/material.dart';
import 'package:moing_flutter/board/board_main_page.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_finish_and_exit_state.dart';
import 'package:moing_flutter/utils/button/white_button.dart';
import 'package:provider/provider.dart';

class GroupFinishSuccessPage extends StatelessWidget {
  static const routeName = '/group/finish/apply';

  const GroupFinishSuccessPage({super.key});

  static route(BuildContext context) {
    final int teamId = ModalRoute.of(context)?.settings.arguments as int;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GroupFinishExitState(context: context, teamId: teamId)),
      ],
      builder: (context, _) {
        return const GroupFinishSuccessPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  '소모임 강제 종료\n신청이 완료되었어요.',
                  style: headerTextStyle.copyWith(
                    color: grayScaleGrey100,
                    height: 1.5
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '모닥모닥불',
                      style: contentTextStyle.copyWith(
                        color: grayScaleGrey100
                      ),
                    ),
                    Text(
                      ' 소모임원들에게',
                      style: contentTextStyle,
                    ),
                  ],
                ),
                SizedBox(height: 4.0,),
                Text('아쉬운 이별의 소식을 전할게요',
                style: contentTextStyle,
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: WhiteButton(
                      onPressed: context.read<GroupFinishExitState>().finishSuccessPressed,
                      text: '목표보드로 돌아가기',
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
