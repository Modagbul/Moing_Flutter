import 'package:flutter/material.dart';
import 'package:moing_flutter/main/alarm/alarm.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/mypage/setting_page.dart';
import 'package:moing_flutter/utils/dynamic_link/dynamic_link.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';

class MainState extends ChangeNotifier {
  final BuildContext context;
  final ApiCode apiCode = ApiCode();
  String? alarmCount;

  MainState({required this.context}) {
    print('Instance "MainState" has been created');
    DynamicLinkService(context: context);
    getNotReadAlarmCount();
  }

  // 알람 클릭
  void alarmPressed() async {
    final result = await Navigator.of(context).pushNamed(
      AlarmPage.routeName,
    );

    if (result as bool) {
      getNotReadAlarmCount();
    }
  }

  // 안읽음 알림 개수 조회
  void getNotReadAlarmCount() async {
    alarmCount = await apiCode.getNotReadAlarmCount();
    notifyListeners();
  }

  void settingPressed() async {
    SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
    String? teamCountString =
        await sharedPreferencesInfo.loadPreferencesData('teamCount');
    int? teamCount;
    if (teamCountString == null || teamCountString.isEmpty) {
      teamCount = 0;
    } else {
      teamCount = int.parse(teamCountString);
    }

    Navigator.of(context).pushNamed(
      SettingPage.routeName,
      arguments: teamCount,
    );
  }
}
