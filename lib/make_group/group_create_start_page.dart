import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/elevated_button.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/make_group/group_create_start_state.dart';

import 'package:provider/provider.dart';

class GroupCreateStartPage extends StatelessWidget {
  static const routeName = '/meeting/create/start';

  const GroupCreateStartPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => GroupCreateStartState(context: context)),
      ],
      builder: (context, _) {
        return const GroupCreateStartPage();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  const Text(
                    '모임 만들기',
                    style: headerTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    '모잉과 함께 새로운 불씨를 키워봐요\n모임 개설 후 1-2일 승인 대기시간이 필요해요',
                    style: bodyTextStyle.copyWith(
                      height: 1.5,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Image.asset(
                'asset/image/meeting_create_start_body.png',
                fit: BoxFit.contain,
              ),
              ElevatedButton(
                style: brightButtonStyle.copyWith(),
                onPressed: () {
                  context.read<GroupCreateStartState>().navigateCategory();
                },
                child: const Text('네, 확인했어요'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
