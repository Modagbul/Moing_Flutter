import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/response/board_completed_mission_response.dart';
import '../../model/api_code/api_code.dart';

class CompletedMissionState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  int teamId;
  bool? isLeader;
  BoardCompletedMissionResponse? completedMissionStatus;
  APICall call = APICall();

  CompletedMissionState({
    required this.context,
    required this.teamId,
  }) {
    log('Instance "CompletedMissionState" has been created');
    initState();
  }

  void initState() async {
    log('Instance "CompletedMissionState" has been created');
    await getCompletedMissionStatus();
    await checkMeIsLeader();
  }

  @override
  void dispose() {
    log('Instance "CompletedMissionState" has been removed');
    super.dispose();
  }

  Future<void> checkMeIsLeader() async {
    try {
      final String apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/isLeader';
      ApiResponse<bool> apiResponse =
      await call.makeRequest<bool>(
        url: apiUrl,
        method: 'GET',
        fromJson: (json) => json as bool,
      );

      print('내가 리더인가~2? : ${apiResponse.data}');
      if(apiResponse.isSuccess == true) {
        isLeader = apiResponse.data;
      }
      else {
        print('CompletedIsLeaeder Error : ${apiResponse.errorCode}');
      }
    } catch (e) {
      print('CompletedIsLeader - 내가 리더인지 조회 실패: $e');
    }
    notifyListeners();
  }

  Future<void> getCompletedMissionStatus() async {
    var response = await apiCode.getCompletedMissionStatus(teamId: teamId);

    if (response != null && response.isSuccess) {
      var filteredMissions = response.data.toList();
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
