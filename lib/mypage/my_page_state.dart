import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/mypage/profile_setting_page.dart';

class MyPageState extends ChangeNotifier {
  final BuildContext context;

  MyPageState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "ProfileSettingState" has been created');
  }

  @override
  void dispose() {
    log('Instance "ProfileSettingState" has been removed');
    super.dispose();
  }


  void profilePressed() {
    Navigator.of(context).pushNamed(
      ProfileSettingPage.routeName,
    );
  }
}
