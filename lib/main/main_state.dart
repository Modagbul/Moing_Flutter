import 'package:flutter/material.dart';
import 'package:moing_flutter/main/alarm/alarm.dart';
import 'package:moing_flutter/mypage/setting_page.dart';
import 'package:moing_flutter/utils/dynamic_link/dynamic_link.dart';
import 'package:moing_flutter/utils/global/api_code/api_code.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';

class MainState extends ChangeNotifier {
  final BuildContext context;
  final ApiCode apiCode = ApiCode();

  String? alarmCount;

  int _mainIndex = 0;

  int get mainIndex => _mainIndex;

  set mainIndex(int index) {
    _mainIndex = index;
    notifyListeners();
  }

  moveToHomeScreen() => mainIndex = 0;

  moveToMissionsScreen() => mainIndex = 1;

  moveToMyPageScreen() => mainIndex = 2;

  MainState({required this.context}) {
    print('Instance "MainState" has been created');
    DynamicLinkService(context: context);
    initState();
  }

  void initState() async {
    await getNotReadAlarmCount();
  }

  // 알람 클릭
  void alarmPressed() async {
    final result = await Navigator.of(context).pushNamed(
      AlarmPage.routeName,
    );

    Map<String, dynamic> resultMap = result as Map<String, dynamic>;

    bool resultValue = resultMap['result'] ?? false;
    int screenIndexValue = resultMap['screenIndex'] ?? 0;

    if (resultValue) {
      await getNotReadAlarmCount();
    }

    switch (screenIndexValue) {
      case 0:
        moveToHomeScreen();
        break;
      case 1:
        moveToMissionsScreen();
        break;
      case 2:
        moveToMyPageScreen();
        break;
      default:
        throw ArgumentError('Invalid screenIndexValue: $screenIndexValue');
    }
  }

  // 안읽음 알림 개수 조회
  Future<void> getNotReadAlarmCount() async {
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
