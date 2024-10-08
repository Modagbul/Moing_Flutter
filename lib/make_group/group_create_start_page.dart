import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/elevated_button.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/home/home_screen.dart';
import 'package:moing_flutter/make_group/group_create_category_state.dart';
import 'package:moing_flutter/make_group/group_create_start_state.dart';
import 'package:moing_flutter/utils/app_bar/moing_app_bar.dart';

import 'package:provider/provider.dart';

import 'group_create_category_page.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: IconButton(
            icon: const Icon(
              Icons.close,
            ),
            onPressed: context.read<GroupCreateStartState>().pressCloseButton,
          ),
        ),
      ),
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
                    '모잉과 함께 새로운 불씨를 키워봐요',
                    // \n모임 개설 후 1-2일 승인 대기시간이 필요해요
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
                  /// 버버벅 없앰 --> 시뮬레이터만 그런거 일수도 있어서 나중에 폰으로 봤을 때 괜찮으면 기존 간단 코드로 수정
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          ChangeNotifierProvider(
                            create: (_) => GroupCreateCategoryState(context: context),
                            child: const GroupCreateCategoryPage(),
                          ),
                      transitionsBuilder: (context, animation1, animation2, child) {
                        return child; // 애니메이션 없이 바로 child 위젯을 반환
                      },
                      transitionDuration: const Duration(milliseconds: 0), // 전환 시간을 0으로 설정
                    ),
                  );
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
