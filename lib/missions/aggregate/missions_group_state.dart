import 'dart:developer';
import 'package:flutter/material.dart';

import '../../model/api_code/api_code.dart';
import '../../model/response/aggregate_team_repeat_mission_response.dart';
import '../../model/response/aggregate_team_single_mission_response.dart';

class MissionsGroupState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();

  AggregateTeamSingleMissionResponse? aggregateTeamSingleMissionStatus;
  AggregateTeamRepeatMissionStatusResponse? aggregateTeamRepeatMissionStatus;

  bool isNotification = false;
  int? selectedTeamId;
  final BuildContext context;

  MissionsGroupState({
    required this.context,
    this.selectedTeamId,
  }) {
    _initState();
  }

  void _initState() {
    _fetchData();
  }

  void updateSelectedTeamId(int newTeamId) async {
    if (selectedTeamId != newTeamId) {
      selectedTeamId = newTeamId;
      await _fetchData();
      notifyListeners();
      log('updateSelectedTeamId: $selectedTeamId');
    }
  }

  Future<void> _fetchData() async {
    if (selectedTeamId != null) {
      await getAggregateTeamSingleMissionStatus();
      await getAggregateTeamRepeatMissionStatus();
      notifyListeners();
    } else {
      log('No team selected for fetching mission status');
    }
  }

  Future<void> getAggregateTeamRepeatMissionStatus() async {
    if (selectedTeamId != null) {
      aggregateTeamRepeatMissionStatus =
      await apiCode.getAggregateTeamRepeatMissionStatus(teamId: selectedTeamId!);
      notifyListeners();
    } else {
      log('No team selected for fetching repeat mission status');
    }
  }

  Future<void> getAggregateTeamSingleMissionStatus() async {
    if (selectedTeamId != null) {
      aggregateTeamSingleMissionStatus =
      await apiCode.getAggregateTeamSingleMissionStatus(teamId: selectedTeamId!);
      notifyListeners();
    } else {
      log('No team selected for fetching single mission status');
    }
  }

}
