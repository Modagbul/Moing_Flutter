import 'dart:developer';
import 'package:flutter/material.dart';

import '../../main/alarm/alarm.dart';
import '../../model/api_code/api_code.dart';
import '../../model/response/team_list_response.dart';

class MissionsState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();

  List<TeamList> get teams => teamListStatus?.data ?? [];

  TeamListResponse? teamListStatus;

  int _selectedTeamId = 0;

  int get selectedTeamId => _selectedTeamId;

  void setSelectedTeamId(int teamId) {
    if (_selectedTeamId != teamId) {
      _selectedTeamId = teamId;
      notifyListeners();
      log('MissionsState Selected team ID changed to: $_selectedTeamId');
    }
  }

  // 알림 여부
  bool isNotification = false;

  final BuildContext context;

  MissionsState({required this.context}) {
    log('Instance "MissionsState" has been created');
    initState();
    getTeamListStatus();
    notifyListeners();
  }

  @override
  void dispose() {
    log('Instance "MissionsState" has been removed');
    super.dispose();
  }

  void initState() {
    getTeamListStatus();
    log('Instance "OngoingMissionState" has been created');
    notifyListeners();
  }

  void alarmPressed() {
    Navigator.of(context).pushNamed(
      AlarmPage.routeName,
    );
  }

  Future<void> getTeamListStatus() async {
    var teamListResponse = await apiCode.getTeamListStatus();
    if (teamListResponse != null && teamListResponse.isSuccess) {
      teamListStatus = teamListResponse;
      if (teamListStatus!.data.isNotEmpty) {
        setSelectedTeamId(teamListStatus!.data[0].teamId);
      }
      notifyListeners();
    }
  }

}