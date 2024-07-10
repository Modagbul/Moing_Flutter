import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/mission_prove/component/mission_prove_argument.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/response/alarm_model.dart';

class AlarmState extends ChangeNotifier {
  final BuildContext context;
  final APICall apiCall = APICall();
  final ApiCode apiCode = ApiCode();
  final FToast fToast = FToast();
  String apiUrl = '';
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
    apiUrl = '${dotenv.env['MOING_API']}/api/history/alarm';

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
        alarmList = apiResponse.data;
        notifyListeners();
      } else {
        log('getAllAlarmData is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('알림 모아보기 실패: $e');
    }
    return null;
  }

  /// 알림 단건 조회
  Future<bool> postSingleAlarmData({required int alarmHistoryId}) async {
    apiUrl =
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
        log('postSingleAlarmData is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('알림 단건 조회 실패: $e');
    }
    return false;
  }

  /// teamId, missionId 통해 해당 미션의 종료 여부, status 값 받기
  Future<Map<String, dynamic>?> getMissionEndStatus(
      {required int teamId, required int missionId}) async {
    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive/mission-status';
    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await apiCall.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (json) => {
          'end': json['end'] as bool,
          'status': json['status'] as String,
        },
      );

      if (apiResponse.isSuccess == true) {
        log('미션 상태 조회 성공');
        return apiResponse.data;
      } else {
        log('getMissionEndStatus is Null, error code : ${apiResponse.errorCode}');
        if (apiResponse.errorCode == 'T0001') {
          showWarningToast(warningText: '존재하지 않는 소모임이에요');
        } else {
          showWarningToast(warningText: '존재하지 않는 미션이에요');
        }
      }
    } catch (e) {
      log('미션 상태 조회 실패: $e');
    }
    return null;
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
      case 'COMMENT':
        return 'asset/icons/icon_comment.svg';
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
          validateNewUploadPost(alarmData: alarmData);
          break;
        case '/missions/prove':
          // 미션 댓글 알림
          if (alarmData.type == 'COMMENT') {
            navigateToMissionDetail(alarmData: alarmData);
          } else {
            // (한번/반복) 신규 미션 업로드, 불 던지기 알림
            navigateMissionsProvePage(alarmData: alarmData);
          }
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

  void navigateToMissionDetail({required AlarmData alarmData}) {
    Map<String, dynamic> idInfoMap = json.decode(alarmData.idInfo);
    int teamId = idInfoMap['teamId'];
    int missionId = idInfoMap['missionId'];
    int missionArchiveId = idInfoMap['missionArchiveId'];

    Navigator.pushNamed(context, alarmData.path, arguments: {
      'teamId': teamId,
      'missionId': missionId,
      'missionArchiveId': missionArchiveId
    });
  }

  void validateNewUploadPost({required AlarmData alarmData}) async {
    Map<String, dynamic> idInfoMap = json.decode(alarmData.idInfo);

    final result = await apiCode.getDetailPostData(
        teamId: idInfoMap['teamId'], boardId: idInfoMap['boardId']);

    if (result == null) {
      showWarningToast(warningText: '존재하지 않는 게시글이에요');
      return;
    }

    navigatePostDetailPage(alarmData: alarmData);
  }

  void navigatePostDetailPage({required AlarmData alarmData}) {
    Map<String, dynamic> idInfoMap = json.decode(alarmData.idInfo);
    Navigator.pushNamed(context, alarmData.path, arguments: idInfoMap);
  }

  void navigateMissionsProvePage({required AlarmData alarmData}) async {
    Map<String, dynamic> idInfoMap = json.decode(alarmData.idInfo);
    bool? isEnded;
    String? status;

    if (idInfoMap['teamId'] != null && idInfoMap['missionId'] != null) {
      final missionEndStatus = await getMissionEndStatus(
          teamId: idInfoMap['teamId'], missionId: idInfoMap['missionId']);
      if (missionEndStatus != null) {
        isEnded = missionEndStatus['end'];
        status = missionEndStatus['status'];
      }
    }

    MissionProveArgument missionProveArgument = MissionProveArgument(
      isRepeated: idInfoMap['isRepeated'] ?? false,
      teamId: idInfoMap['teamId'] ?? 0,
      missionId: idInfoMap['missionId'] ?? 0,
      status: status ?? idInfoMap['status'] ?? '',
      isEnded: isEnded ?? false,
      isRead: alarmData.isRead,
    );

    Navigator.pushNamed(
      context,
      alarmData.path,
      arguments: missionProveArgument,
    );
  }

  void navigateMissionsScreen({required AlarmData alarmData}) {
    Navigator.pop(context, {'result': true, 'screenIndex': 1});
  }

  void navigateHomeScreen({required AlarmData alarmData}) {
    Navigator.pop(context, {'result': true, 'screenIndex': 0});
  }

  void showWarningToast({required String warningText}) {
    fToast.showToast(
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'asset/icons/toast_danger.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    Text(
                      warningText,
                      style: const TextStyle(
                        color: grayScaleGrey700,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )),
        ),
        toastDuration: const Duration(milliseconds: 3000),
        positionedToastBuilder: (context, child) {
          return Positioned(
            top: 100.0,
            left: 0.0,
            right: 0,
            child: child,
          );
        });
  }
}
