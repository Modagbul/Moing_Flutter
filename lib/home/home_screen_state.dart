import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/main/alarm/alarm.dart';

class HomeScreenState extends ChangeNotifier {
  final BuildContext context;
  // 알림 여부
  bool isNotification = false;

  HomeScreenState({required this.context}) {
    log('Instance "HomeScreenState" has been created');
  }

  void alarmPressed() {
    Navigator.of(context).pushNamed(
      AlarmPage.routeName,
    );
  }
}