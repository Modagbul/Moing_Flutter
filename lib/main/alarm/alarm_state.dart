import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/mission_prove/component/mission_prove_argument.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/response/alarm_model.dart';

class AlarmState extends ChangeNotifier {
  final BuildContext context;
  final APICall apiCall = APICall();
  List<AlarmData>? alarmList;

  AlarmState({required this.context}) {
    log('Instance "AlarmState" has been created');
    initState();
  }

  void initState() async {
    await getAllAlarmData();
  }

  /// 알림 전체 조회
  Future<List<AlarmData>?> getAllAlarmData() async {
    final String apiUrl = '${dotenv.env['MOING_API']}/api/history/alarm';

    try {
      ApiResponse<List<AlarmData>> apiResponse =
          await apiCall.makeRequest<List<AlarmData>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) {
          return (data as List<dynamic>)
              .map((item) => AlarmData.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );

      if (apiResponse.data != null) {
        log('알림 모아보기 성공: ${apiResponse.data}');
        alarmList = apiResponse.data;
        notifyListeners();
      } else {
        print('getAllAlarmData is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('알림 모아보기 실패: $e');
    }
    return null;
  }

  /// 알림 단건 조회
  Future<bool> postSingleAlarmData({required int alarmHistoryId}) async {
    final String apiUrl =
        '${dotenv.env['MOING_API']}/api/history/alarm/read?alarmHistoryId=$alarmHistoryId';

    try {
      ApiResponse<void> apiResponse = await apiCall.makeRequest<void>(
        url: apiUrl,
        method: 'POST',
        fromJson: (_) {},
      );

      if (apiResponse.isSuccess == true) {
        log('알림 단건 조회 성공');
        return true;
      } else {
        print(
            'postSingleAlarmData is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('알림 단건 조회 실패: $e');
    }
    return false;
  }

  String convertAlarmTypeToImage({required String type}) {
    switch (type) {
      case 'NEW_UPLOAD':
        return 'asset/icons/icon_new_upload.svg';
      case 'FIRE':
        return 'asset/icons/icon_throw_fire.svg';
      case 'REMIND':
        return 'asset/icons/icon_remind_alarm.svg';
      case 'APPROVE_TEAM':
        return 'asset/icons/icon_approve_team.svg';
      case 'REJECT_TEAM':
        return 'asset/icons/icon_reject_team.svg';
      default:
        throw ArgumentError('Invalid alarm type: $type');
    }
  }

  void onTapAlarm({required int index}) async {
    if (alarmList == null) {
      return;
    }

    // 알림 읽음 처리 성공 -> 화면 이동
    AlarmData alarmData = alarmList![index];
    if (await postSingleAlarmData(alarmHistoryId: alarmData.alarmHistoryId)) {
      await getAllAlarmData();
      notifyListeners();

      switch (alarmData.path) {
        case '/post/detail': // 신규 공지 업로드 알림
          navigatePostDetailPage(alarmData: alarmData);
          break;
        case '/missions/prove': // (한번/반복) 신규 미션 업로드, 불 던지기 알림
          navigateMissionsProvePage(alarmData: alarmData);
          break;
        case '/missions': // (한번/반복) 미션 리마인드 알림
          navigateMissionsScreen(alarmData: alarmData);
          break;
        case '/home': // 소모임 생성 (승인/반려) 알림
          navigateHomeScreen(alarmData: alarmData);
          break;
        default:
          throw ArgumentError('Invalid alarm path: ${alarmData.path}');
      }
    }
  }

  void navigatePostDetailPage({required AlarmData alarmData}) {
    Map<String, dynamic> idInfoMap = json.decode(alarmData.idInfo);
    Navigator.pushNamed(context, alarmData.path, arguments: idInfoMap);
  }

  void navigateMissionsProvePage({required AlarmData alarmData}) {
    Map<String, dynamic> idInfoMap = json.decode(alarmData.idInfo);

    MissionProveArgument missionProveArgument = MissionProveArgument(
      isRepeated: idInfoMap['isRepeated'] ?? false,
      teamId: idInfoMap['teamId'] ?? 0,
      missionId: idInfoMap['missionId'] ?? 0,
      status: idInfoMap['status'] ?? '',
    );

    Navigator.pushNamed(context, alarmData.path,
        arguments: missionProveArgument);
  }

  void navigateMissionsScreen({required AlarmData alarmData}) {
    Navigator.pop(context, {'result': true, 'screenIndex': 1});
  }

  void navigateHomeScreen({required AlarmData alarmData}) {
    Navigator.pop(context, {'result': true, 'screenIndex': 0});
  }
}
