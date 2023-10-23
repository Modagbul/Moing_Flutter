import 'dart:developer';
import 'package:flutter/material.dart';

import '../main/alarm/alarm.dart';

class MissionsState extends ChangeNotifier {

  // 알림 여부
  bool isNotification = false;

  final BuildContext context;

  MissionsState({required this.context}) {
    log('Instance "MissionsState" has been created');
    initState();
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

}