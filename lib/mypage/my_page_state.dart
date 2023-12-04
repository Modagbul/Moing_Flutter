import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/response/get_my_page_data_response.dart';
import 'package:moing_flutter/mypage/profile_setting_page.dart';
import 'package:moing_flutter/mypage/setting_page.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';

class MyPageState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  MyPageData? myPageData;

  MyPageState({
    required this.context,
  }) {
    initState();
  }

  void initState() async {
    log('Instance "MyPageState" has been created');
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

  void settingPressed() async {
    SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
    String? teamCountString = await sharedPreferencesInfo.loadPreferencesData('teamCount');
    int? teamCount;
    if (teamCountString == null || teamCountString.isEmpty || teamCountString.length < 1) {
      teamCount = 0;
    }
    else {
      teamCount = int.parse(teamCountString);
    }
    print('mypageScreen teamCount : $teamCount');
    Navigator.of(context).pushNamed(
      SettingPage.routeName,
      arguments: teamCount,
    );
  }
}
