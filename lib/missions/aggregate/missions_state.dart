import 'dart:developer';
import 'package:flutter/material.dart';

import '../../main/alarm/alarm.dart';
import '../../model/api_code/api_code.dart';
import '../../model/response/team_list_response.dart';

class MissionsState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();

  TeamListResponse? teamListStatus;

  // 알림 여부
  bool isNotification = false;

  final BuildContext context;

  MissionsState({required this.context}) {
    log('Instance "MissionsState" has been created');
    initState();
    getTeamListStatus();
  }

  @override
  void dispose() {
    log('Instance "MissionsState" has been removed');
    super.dispose();
  }

  void initState() {
  }

  void alarmPressed() {
    Navigator.of(context).pushNamed(
      AlarmPage.routeName,
    );
  }

  void getTeamListStatus() async {
    teamListStatus =
    await apiCode.getTeamListStatus();
    notifyListeners();
  }

}