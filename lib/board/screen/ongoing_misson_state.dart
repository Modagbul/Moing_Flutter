import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';

import '../../model/response/board_repeat_mission_response.dart';
import '../../model/response/board_single_mission_response.dart';
import 'completed_mission_page.dart';

class OngoingMissionState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  int teamId;
  bool? isLeader;
  RepeatMissionStatusResponse? repeatMissionStatus;
  BoardSingleMissionResponse? singleMissionStatus;
  APICall call = APICall();

  OngoingMissionState({
    required this.context,
    required this.teamId,
  }) {
    initState();
  }

  void initState() async {
    getRepeatMissionStatus();
    getSingleMissionStatus();
    checkMeIsLeader();
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

  void checkMeIsLeader() async {
    try {
      final String apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/isLeader';
      ApiResponse<bool> apiResponse =
      await call.makeRequest<bool>(
        url: apiUrl,
        method: 'GET',
        fromJson: (json) => json as bool,
      );

      if(apiResponse.isSuccess == true) {
        isLeader = apiResponse.data;
      }
      else {
        if(apiResponse.errorCode == 'J0003') {
          checkMeIsLeader();
        }
        else {
          throw Exception('OnGoingIsLeader is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      print('OnGoingIsLeader - 내가 리더인지 조회 실패: $e');
    }
  }

  void reloadMissionStatus() async {
    await getRepeatMissionStatus();
    await getSingleMissionStatus();
    notifyListeners();
  }
}
