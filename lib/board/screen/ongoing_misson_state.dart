import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/utils/toast/toast_message.dart';

import '../../model/response/board_repeat_mission_response.dart';
import '../../model/response/board_single_mission_response.dart';
import 'completed_mission_page.dart';

class OngoingMissionState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  final ToastMessage toastMessage = ToastMessage();
  final FToast fToast = FToast();
  int teamId;
  bool? isLeader;
  RepeatMissionStatusResponse? repeatMissionStatus;
  BoardSingleMissionResponse? singleMissionStatus;
  APICall call = APICall();

  String apiUrl = '';

  OngoingMissionState({
    required this.context,
    required this.teamId,
  }) {
    initState();
  }

  void initState() async {
    fToast.init(context);
    await getRepeatMissionStatus();
    await getSingleMissionStatus();
    await checkMeIsLeader();
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

  Future<void> checkMeIsLeader() async {
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
        print('onGoing에서 isLeader : $isLeader');
      }
      else {
        print('OnGoingIsLeader is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      print('OnGoingIsLeader - 내가 리더인지 조회 실패: $e');
    }
    notifyListeners();
  }

  void reloadMissionStatus() async {
    await getRepeatMissionStatus();
    await getSingleMissionStatus();
    notifyListeners();
  }

  void showToast(bool isRepeated) {
    print('미션 종료토스트 문구가 출력됩니다.');
      toastMessage.showToastMessage(
        fToast: fToast,

        warningText: isRepeated ? "해당 반복미션이 종료되었어요" : "해당 한번미션이 종료되었어요",
        isWarning: false,
        toastLeft: 0,
        toastRight: 0,
        toastTop: 114,
      );
  }

  // Future<void> missionDelete(int missionId) async {
  //   apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId';
  //
  //   try {
  //     ApiResponse<int> apiResponse = await call.makeRequest<int>(
  //       url: apiUrl,
  //       method: 'DELETE',
  //       fromJson: (dataJson) => dataJson as int,
  //     );
  //
  //     if (apiResponse.isSuccess) {
  //       print('${apiResponse.data} 미션 삭제가 완료되었습니다.');
  //
  //       notifyListeners();
  //     } else {
  //       throw Exception('미션 삭제 실패, error code : ${apiResponse.errorCode}');
  //     }
  //   } catch (e) {
  //     log('미션 삭제 실패: $e');
  //   }
  //
  //   notifyListeners();
  //
  // }

}

