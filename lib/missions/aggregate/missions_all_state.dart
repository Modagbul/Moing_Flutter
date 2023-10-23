import 'dart:developer';
import 'package:flutter/material.dart';

import '../../main/alarm/alarm.dart';

class MissionsAllState extends ChangeNotifier {

  // 알림 여부
  bool isNotification = false;

  final BuildContext context;

  MissionsAllState({required this.context}) {
    log('Instance "MissionsAllState" has been created');
    initState();
  }

  @override
  void dispose() {
    log('Instance "MissionsAllState" has been removed');
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