import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../main/alarm/alarm.dart';
import '../../model/api_code/api_code.dart';
import '../../model/api_generic.dart';
import '../../model/api_response.dart';
import '../../model/response/aggregate_repeat_mission_response.dart';
import '../../model/response/aggregate_single_mission_response.dart';

class MissionsAllState extends ChangeNotifier {
  String apiUrl = '';
  final APICall call = APICall();
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

  void initState() async{
    // log('teamId : $teamId, missionId : $missionId');
  }

  void alarmPressed() {
    Navigator.of(context).pushNamed(
      AlarmPage.routeName,
    );
  }

  Future<void> getAggregateRepeatMissionStatus() async {
    aggregateRepeatMissionStatus =
        await apiCode.getAggregateRepeatMissionStatus();
    notifyListeners();
  }

  Future<void> getAggregateSingleMissionStatus() async {
    aggregateSingleMissionStatus =
        await apiCode.getAggregateSingleMissionStatus();
    notifyListeners();
  }

  void reloadMissionStatus() async {
    await getAggregateRepeatMissionStatus();
    await getAggregateSingleMissionStatus();
    notifyListeners();
  }
}
