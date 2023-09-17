import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/home/home_screen.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_finish_and_exit_state.dart';
import 'package:moing_flutter/utils/button/white_button.dart';
import 'package:provider/provider.dart';

class GroupExitApplyPage extends StatelessWidget {
  static const routeName = '/group/exit/apply';
  const GroupExitApplyPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GroupFinishExitState(context: context)),
      ],
      builder: (context, _) {
        return const GroupExitApplyPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  '소모임 탈퇴가 완료되었어요.',
                  style: headerTextStyle.copyWith(
                      color: grayScaleGrey100,
                      height: 1.5
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16,),
                Text('다음에 또 만나요!',
                  style: contentTextStyle,
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: WhiteButton(
                      onPressed: (){
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeScreen.routeName, (route) => false);
                      },
                      text: '홈으로 돌아가기',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
