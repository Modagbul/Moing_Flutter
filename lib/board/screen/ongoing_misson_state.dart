import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';

import '../../model/response/board_repeat_mission_response.dart';
import '../../model/response/board_single_mission_response.dart';

class OngoingMissionState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  int teamId;
  RepeatMissionStatusResponse? repeatMissionStatus;
  BoardSingleMissionResponse? singleMissionStatus;

  OngoingMissionState({
    required this.context,
    required this.teamId,
  }) {
    initState();
  }

  void initState() async {
    getRepeatMissionStatus();
    getSingleMissionStatus();
    log('Instance "OngoingMissionState" has been created');
  }

  @override
  void dispose() {
    log('Instance "OngoingMissionState" has been removed');
    super.dispose();
  }

  Future<void> getRepeatMissionStatus() async {
    repeatMissionStatus = await apiCode.getRepeatMissionStatus(teamId: teamId);
    notifyListeners();
  }

  Future<void> getSingleMissionStatus() async {
    singleMissionStatus = await apiCode.getSingleMissionStatus(teamId: teamId);
    notifyListeners();
  }

  void reloadMissionStatus() async {
    await getRepeatMissionStatus();
    await getSingleMissionStatus();
    notifyListeners();
  }

}
