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

  int singleMissionMyCount = 0;
  int singleMissionTotalCount = 0;

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

  /// 모임원 미션 인증 성공 인원 조회 API
  Future<void> loadTeamMissionProveCount(int teamId, int missionId) async {
    apiUrl =
    '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive/status';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (dataJson) => dataJson as Map<String, dynamic>,
      );

      if (apiResponse.data != null) {
        singleMissionMyCount = int.parse(apiResponse.data?['done']);
        singleMissionTotalCount = int.parse(apiResponse.data?['total']);
        notifyListeners();
      } else {
        log('loadTeamMissionProveCount is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('나의 성공 횟수 조회 실패: $e');
    }
  }

  Future<void> getAggregateRepeatMissionStatus() async {
    aggregateRepeatMissionStatus = await apiCode.getAggregateRepeatMissionStatus();
    if (aggregateRepeatMissionStatus != null && aggregateRepeatMissionStatus!.isSuccess) {
      for (var mission in aggregateRepeatMissionStatus!.data) {
        int currentMissionId = mission.missionId;
        int currentTeamId = mission.teamId;

        // 예시: 다른 함수 호출 또는 처리
        await loadTeamMissionProveCount(currentTeamId, currentMissionId);
      }
    }
    notifyListeners();
  }

  // Future<void> getAggregateRepeatMissionStatus() async {
  //   aggregateRepeatMissionStatus =
  //       await apiCode.getAggregateRepeatMissionStatus();
  //   notifyListeners();
  // }

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
