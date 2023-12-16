import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_finish_and_exit_state.dart';
import 'package:moing_flutter/utils/button/white_button.dart';
import 'package:provider/provider.dart';

class GroupFinishSuccessPage extends StatelessWidget {
  static const routeName = '/group/finish/apply';

  const GroupFinishSuccessPage({super.key});

  static route(BuildContext context) {
    final Map<String, dynamic> data =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final int teamId = data['teamId'] as int;
    final String text = data['text'] as String;
    final String? teamName = data['teamName'] as String?;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GroupFinishExitState(
            context: context, teamId: teamId, text: text, teamName: teamName ?? '')),
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
                const Spacer(),
                Text(
                  context.read<GroupFinishExitState>().text,
                  style: headerTextStyle.copyWith(
                    color: grayScaleGrey100,
                    height: 1.5
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16,),
                if(!context.read<GroupFinishExitState>().text.contains('종료가'))
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.read<GroupFinishExitState>().teamName ?? '',
                            style: contentTextStyle.copyWith(
                                color: grayScaleGrey100
                            ),
                          ),
                          const Text(
                            ' 소모임원들에게',
                            style: contentTextStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0,),
                      const Text('아쉬운 이별의 소식을 전할게요',
                        style: contentTextStyle,
                      ),
                    ],
                  ),
                if(context.read<GroupFinishExitState>().text.contains('종료가'))
                  Column(
                    children: [
                      SizedBox(height: 16),
                      Text(
                        '다음에 또 만나요!',
                          style: contentTextStyle,
                      )
                    ],
                  ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: WhiteButton(
                      onPressed: context.read<GroupFinishExitState>().finishSuccessPressed,
                      text: context.read<GroupFinishExitState>().text.contains('종료가')
                      ? '홈으로 돌아가기' : '목표보드로 돌아가기',
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
