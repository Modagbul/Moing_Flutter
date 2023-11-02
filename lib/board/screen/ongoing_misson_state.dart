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
    getRepeatMissionStatus();
    getSingleMissionStatus();
  }

  void initState() async {
    log('Instance "OngoingMissionState" has been created');
  }

  @override
  void dispose() {
    log('Instance "OngoingMissionState" has been removed');
    super.dispose();
  }

  void getRepeatMissionStatus() async {
    repeatMissionStatus = await apiCode.getRepeatMissionStatus(teamId: teamId);
    notifyListeners();
  }

  void getSingleMissionStatus() async {
    singleMissionStatus = await apiCode.getSingleMissionStatus(teamId: teamId);
    notifyListeners();
  }
}
