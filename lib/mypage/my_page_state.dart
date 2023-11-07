import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/response/get_my_page_data_response.dart';
import 'package:moing_flutter/mypage/profile_setting_page.dart';
import 'package:moing_flutter/mypage/setting_page.dart';

class MyPageState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  MyPageData? myPageData;

  MyPageState({
    required this.context,
  }) {
    initState();
    getMyPageData();
  }

  void initState() async {
    log('Instance "MyPageState" has been created');
  }

  @override
  void dispose() {
    log('Instance "MyPageState" has been removed');
    super.dispose();
  }

  void profilePressed() {
    Navigator.of(context).pushNamed(
      ProfileSettingPage.routeName,
    );
  }

  void getMyPageData() async {
    myPageData = await apiCode.getMyPageData();
    notifyListeners();
  }

  void settingPressed() {
    int teamCount = myPageData?.getMyPageTeamBlocks.length ?? 0;
    Navigator.of(context).pushNamed(
      SettingPage.routeName,
      arguments: teamCount,
    );
  }
}
