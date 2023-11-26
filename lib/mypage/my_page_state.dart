import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/response/get_my_page_data_response.dart';
import 'package:moing_flutter/mypage/profile_setting_page.dart';
import 'package:moing_flutter/mypage/setting_page.dart';

class MyPageState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  final int teamCount;
  MyPageData? myPageData;

  MyPageState({
    required this.context,
    required this.teamCount,
  }) {
    initState();
  }

  void initState() async {
    log('Instance "MyPageState" has been created');
    print('teamCount : $teamCount');
    getMyPageData();
  }

  @override
  void dispose() {
    log('Instance "MyPageState" has been removed');
    super.dispose();
  }

  void profilePressed() async {
    var result = await Navigator.of(context).pushNamed(
      ProfileSettingPage.routeName,
    );

    if(result != null && result == true) {
      getMyPageData();
    }
  }

  void getMyPageData() async {
    myPageData = await apiCode.getMyPageData();
    notifyListeners();
  }

  void settingPressed() {
    Navigator.of(context).pushNamed(
      SettingPage.routeName,
      arguments: teamCount,
    );
  }
}
