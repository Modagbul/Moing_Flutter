import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moing_flutter/home/home_screen.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_first.dart';
import 'package:moing_flutter/login/sign_in/login_page.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/mission_fire/mission_fire_page.dart';
import 'package:moing_flutter/mission_prove/mission_prove_page.dart';
import 'package:moing_flutter/missions/create/missions_create_page.dart';
import 'package:moing_flutter/mypage/revoke/mypage_revoke_page.dart';
import 'package:moing_flutter/utils/api/refresh_token.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';

class InitState extends ChangeNotifier {
  BuildContext context;
  final SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
  final TokenManagement tokenManagement = TokenManagement();

  InitState({required this.context}) {
    print('Instance "InitState" has been created');
    initStart();
    // asyncInitState();
  }

  @override
  void dispose() {
    print('Instance "InitState" has been removed');
    super.dispose();
  }

  /// 테스트 용도로 처음에는 무조건 로그인 페이지로 이동하도록 함
  // void initStart() async {
  //   await Future.delayed(
  //     const Duration(
  //       seconds: 1,
  //       milliseconds: 0,
  //     ),
  //   );

    // Navigator.of(context).pushNamed(
    //     MissionFirePage.routeName,
    // );
    /// 이전에 가입한 적 있는 유저
    // String? oldUser = await sharedPreferencesInfo.loadPreferencesData('old');

    //이전에 가입한 적 있는 유저
    // if (oldUser == 'true') {
    //   String? accessToken = await tokenManagement.loadAccessToken();
    //   if (accessToken != null) {
    //     Navigator.pushNamedAndRemoveUntil(
    //         context, MainPage.routeName, (route) => false);
    //   } else {
    //     Navigator.pushNamedAndRemoveUntil(
    //         context, LoginPage.routeName, (route) => false);
    //   }
    // } else {
    //   Navigator.pushNamedAndRemoveUntil(
    //       context, OnBoardingFirstPage.routeName, (route) => false);
    // }

    void initStart() async {

      await Future.delayed(
        const Duration(
          seconds: 1,
          milliseconds: 0,
        ),
      );

      String? oldUser = await sharedPreferencesInfo.loadPreferencesData('old');

      if (oldUser == 'true') {
        // 이전에 로그인 한 적 있는 경우
        String? accessToken = await tokenManagement.loadAccessToken();
        if (accessToken != null) {
          // 유효한 액세스 토큰이 있는 경우 메인 페이지로 이동
          Navigator.pushNamedAndRemoveUntil(context, MainPage.routeName, (route) => false);
        } else {
          // 액세스 토큰이 유효하지 않은 경우 로그인 페이지로 이동
          Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, (route) => false);
        }
      } else {
        // 이전에 로그인 한 적 없는 경우 온보딩 페이지로 이동
        Navigator.pushNamedAndRemoveUntil(context, OnBoardingFirstPage.routeName, (route) => false);
      }

    // oldUser == 'true'
    // ? Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, (route) => false)
    // :Navigator.pushNamedAndRemoveUntil(context, OnBoardingFirstPage.routeName, (route) => false);
  }
}
