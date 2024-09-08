import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_first.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_last.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_second.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_third.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_zero.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';

import '../../home/home_screen.dart';

class TutorialState extends ChangeNotifier {
  final BuildContext context;
  final SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();

  TutorialState({
    required this.context,
  }) {
    initState();
  }

  void initState() async {
    // String? oldUser = await sharedPreferencesInfo.loadPreferencesData('old');
    // 최초 진입 유저가 아닌 경우
    // if (pageCount == 6 && oldUser == 'true') {
    //   /// TODO : 조건 분기 후 회원가입 또는 로그인 진행하여 함. 현재는 로그인으로 진행
    //   Navigator.of(context).pushNamed(
    //     HomeScreen.routeName,
    //   );
    // }

    // 최초 실행
    // else {
    //   oldUser = 'true';
    //   await sharedPreferencesInfo.savePreferencesData('old', 'true');
    // }
  }

  @override
  void dispose() {
    log('Instance "OnBoardingState" has been removed');
    super.dispose();
  }

  // /// 스킵 버튼 -> 닉네임 설정 페이지로 이동
  // void skip() {
  //   Navigator.of(context).pushNamed(
  //     LoginPage.routeName,
  //   );
  // }
}
