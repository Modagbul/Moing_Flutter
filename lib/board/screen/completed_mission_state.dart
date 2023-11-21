import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/response/board_completed_mission_response.dart';

import '../../model/api_code/api_code.dart';

class CompletedMissionState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  int teamId;
  BoardCompletedMissionResponse? completedMissionStatus;

  CompletedMissionState({
    required this.context,
    required this.teamId,
  }) {
    log('Instance "CompletedMissionState" has been created');
    initState();
    getCompletedMissionStatus();
  }

  void initState() async {
    log('Instance "CompletedMissionState" has been created');
  }

  @override
  void dispose() {
    log('Instance "CompletedMissionState" has been removed');
    super.dispose();
  }

  void getCompletedMissionStatus() async {
    completedMissionStatus = await apiCode.getCompletedMissionStatus(teamId: teamId);
    notifyListeners();
  }
}
