import 'dart:developer';
import 'package:flutter/material.dart';

import '../main/alarm/alarm.dart';

class MissionsGroupState extends ChangeNotifier {

  // 알림 여부
  bool isNotification = false;

  MissionsGroupState() {
    log('Instance "MissionsGroupState" has been created');
    initState();
  }

  @override
  void dispose() {
    log('Instance "MissionsGroupState" has been removed');
    super.dispose();
  }

  void initState() {
    // 초기화 로직
  }

  void alarmPressed(BuildContext context) {
    Navigator.of(context).pushNamed(
      AlarmPage.routeName,
    );
  }

}