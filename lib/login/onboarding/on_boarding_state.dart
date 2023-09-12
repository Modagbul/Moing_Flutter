import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_second.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_third.dart';
import 'package:moing_flutter/login/sign_up/sign_up_page.dart';

class OnBoardingState extends ChangeNotifier {
  final BuildContext context;
  int pageCount = 1;

  OnBoardingState({required this.context, required this.pageCount,}) {
    log('Instance "OnBoardingState" has been created');
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
        SignUpPage.routeName,
      );
    }
  }

  /// 스킵 버튼 -> 닉네임 설정 페이지로 이동
  void skip() {
    Navigator.of(context).pushNamed(
      SignUpPage.routeName,
    );
  }
}