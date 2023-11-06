import 'dart:developer';
import 'package:flutter/material.dart';

import '../../main/alarm/alarm.dart';
import '../../model/api_code/api_code.dart';
import '../../model/response/aggregate_repeat_mission_response.dart';
import '../../model/response/aggregate_single_mission_response.dart';

class MissionsAllState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();

  AggregateSingleMissionResponse? aggregateSingleMissionStatus;
  AggregateRepeatMissionStatusResponse? aggregateRepeatMissionStatus;

  // 알림 여부
  bool isNotification = false;

  final BuildContext context;

  MissionsAllState({
    required this.context,
  }) {
    initState();
    getAggregateSingleMissionStatus();
    getAggregateRepeatMissionStatus();
  }

  @override
  void dispose() {
    log('Instance "MissionsAllState" has been removed');
    super.dispose();
  }

  void initState() {}

  void alarmPressed() {
    Navigator.of(context).pushNamed(
      AlarmPage.routeName,
    );
  }

  void getAggregateRepeatMissionStatus() async {
    aggregateRepeatMissionStatus =
        await apiCode.getAggregateRepeatMissionStatus();
    notifyListeners();
  }

  void getAggregateSingleMissionStatus() async {
    aggregateSingleMissionStatus =
        await apiCode.getAggregateSingleMissionStatus();
    notifyListeners();
  }
}
