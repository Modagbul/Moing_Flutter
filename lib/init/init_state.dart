import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_first.dart';
import 'package:moing_flutter/login/sign_in/login_page.dart';
import 'package:moing_flutter/mission_fire/mission_fire_page.dart';
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
  void initStart() async {
    await Future.delayed(
      const Duration(
        seconds: 1,
        milliseconds: 0,
      ),
    );

    //String? oldUser = await sharedPreferencesInfo.loadPreferencesData('old');

    /// 이전에 가입한 적 있는 유저
    /// MissionFirePage
    Navigator.pushNamedAndRemoveUntil(context, MissionsCreatePage.routeName, (route) => false);
    //Navigator.pushNamedAndRemoveUntil(context, MissionFirePage.routeName, (route) => false);

    //String? oldUser = await sharedPreferencesInfo.loadPreferencesData('old');

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

    // oldUser == 'true'
    // ? Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, (route) => false)
    // : Navigator.pushNamedAndRemoveUntil(context, OnBoardingFirstPage.routeName, (route) => false);
  }
}
