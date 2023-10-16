import 'dart:developer';
import 'package:flutter/material.dart';

import '../main/alarm/alarm.dart';

class MissionsGroupState extends ChangeNotifier {

  // 알림 여부
  bool isNotification = false;

  final BuildContext context;

  MissionsGroupState({required this.context}) {
    log('Instance "MissionsGroupState" has been created');
    initState();
  }

  @override
  void dispose() {
    log('Instance "MissionsGroupState" has been removed');
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