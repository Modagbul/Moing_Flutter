import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_second.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_third.dart';
import 'package:moing_flutter/login/sign_in/login_page.dart';
import 'package:moing_flutter/login/sign_up/sign_up_page.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';

class OnBoardingState extends ChangeNotifier {
  final BuildContext context;
  final SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
  int pageCount = 1;

  OnBoardingState({
    required this.context,
    required this.pageCount,
  }) {
    log('Instance "OnBoardingState" has been created');
    initState();
  }

  void initState() async {
    String? oldUser = await sharedPreferencesInfo.loadPreferencesData('old');
    // 최초 진입 유저가 아닌 경우
    if (pageCount == 4 && oldUser == 'true') {
      /// TODO : 조건 분기 후 회원가입 또는 로그인 진행하여 함. 현재는 로그인으로 진행
      Navigator.of(context).pushNamed(
        LoginPage.routeName,
      );
    }

    // 최초 실행
    else {
      oldUser = 'true';
      await sharedPreferencesInfo.savePreferencesData('old', 'true');
    }
  }

  @override
  void dispose() {
    log('Instance "OnBoardingState" has been removed');
    super.dispose();
  }

  void next() {
    pageCount++;
    print(pageCount);

    /// 두 번째 온보딩 페이지로 이동
    if (pageCount == 2) {
      Navigator.of(context).pushNamed(
        OnBoardingSecondPage.routeName,
      );
    }

    /// 세 번째 온보딩 페이지로 이동
    else if (pageCount == 3) {
      Navigator.of(context).pushNamed(
        OnBoardingThirdPage.routeName,
      );
    }

    /// 닉네임 설정 페이지로 이동
    else {
      Navigator.of(context).pushNamed(
        LoginPage.routeName,
      );
    }
  }

  /// 스킵 버튼 -> 닉네임 설정 페이지로 이동
  void skip() {
    Navigator.of(context).pushNamed(
      LoginPage.routeName,
    );
  }
}
