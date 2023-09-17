import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/make_group/group_create_success_state.dart';
import 'package:provider/provider.dart';

class GroupCreateSuccessPage extends StatelessWidget {
  static const routeName = '/meeting/create/success';

  const GroupCreateSuccessPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => GroupCreateSuccessState(context: context)),
      ],
      builder: (context, _) {
        return const GroupCreateSuccessPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 126.0, bottom: 12),
                  child: Text(
                    '모임개설이 승인되면\n푸시알림으로 알려드릴게요',
                    style: headerTextStyle.copyWith(
                        color: grayScaleGrey100, height: 1.3),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 13.0),
                  child: Text(
                    '모임 개설 후 1-2일 승인 대기시간이 필요해요',
                    style: bodyTextStyle.copyWith(
                      color: grayScaleGrey400,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Image.asset(
                  'asset/image/moing_team.png',
                  fit: BoxFit.fill,
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: grayScaleGrey900,
                      fixedSize: Size(353, 62),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      )),
                  onPressed: context.read<GroupCreateSuccessState>().submit,
                  child: Text(
                    '홈으로 돌아가기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
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
