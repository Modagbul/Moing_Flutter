import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/response/board_completed_mission_response.dart';
import '../../model/api_code/api_code.dart';

class CompletedMissionState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  int teamId;
  bool? isLeader;
  BoardCompletedMissionResponse? completedMissionStatus;

  CompletedMissionState({
    required this.context,
    required this.teamId,
    this.isLeader,
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
    var response = await apiCode.getCompletedMissionStatus(teamId: teamId);

    if (response != null && response.isSuccess) {
      var filteredMissions = response.data?.where((mission) {
        var dueToDate = DateTime.parse(mission.dueTo);

        return dueToDate.isBefore(DateTime.now()) || mission.status == 'COMPLETE';
      }).toList() ?? [];

      completedMissionStatus = BoardCompletedMissionResponse(
        isSuccess: true,
        message: 'Filtered missions successfully',
        data: filteredMissions,
      );
    } else {
      completedMissionStatus = BoardCompletedMissionResponse(
        isSuccess: false,
        message: response?.message ?? 'Error: Response was null',
        data: [],
      );
    }
    notifyListeners();
  }

  @override
  notifyListeners();

}
