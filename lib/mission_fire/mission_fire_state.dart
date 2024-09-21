import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/config/amplitude_config.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/response/mission/fire_person_list_repsonse.dart';

class MissionFireState extends ChangeNotifier {
  final BuildContext context;
  final ApiCode apiCode = ApiCode();
  final int teamId;
  final int missionId;
  int singleMissionMyCount = 0;
  int singleMissionTotalCount = 0;
  final TextEditingController messageController = TextEditingController();

  String selectedUserName = '모임원 프로필을 클릭해보세요';
  int? selectedIndex;
  List<FireReceiverData>? userList;
  String apiUrl = '';
  final APICall call = APICall();
  bool _isThrowFireInProgress = false;

  List<String> userNameList = [
    '뮹뮹',
    'JeffCollin',
    '채채채리',
    '현석쿤',
    '여비',
    '으냥',
    '모닥부리부리',
    // '열정열정',
    // '근육맨',
  ];

  MissionFireState({
    required this.context,
    required this.teamId,
    required this.missionId,
  }) {
    initState();
  }

  void initState() async {
    log('Instance "MissionFireState" has been created');
    log('teamId : $teamId, missionId : $missionId');
    await loadFirePersonList();
    await loadTeamMissionProveCount();
  }

  /// 모임원 미션 인증 성공 인원 조회 API
  Future<void> loadTeamMissionProveCount() async {
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

  /// 불 던질 인원 조회 API
  Future<void> loadFirePersonList() async {
    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/fire';

    try {
      ApiResponse<List<FireReceiverData>> apiResponse =
          await call.makeRequest<List<FireReceiverData>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (dataJson) => List<FireReceiverData>.from(
          (dataJson as List).map(
            (item) => FireReceiverData.fromJson(item as Map<String, dynamic>),
          ),
        ),
      );

      if (apiResponse.data != null && apiResponse.data!.isNotEmpty) {
        userList = apiResponse.data;
        notifyListeners();
      } else {
        log('loadFirePersonList is Null or Empty, error code: ${apiResponse.errorCode}');
        userList = [];
        notifyListeners();
      }
    } catch (e) {
      log('불 던질 사람 조회 실패: $e');
      userList = [];
      notifyListeners();
    }
  }

  /// 불 던지기 API
  Future<void> throwFire() async {
    _isThrowFireInProgress = true;
    notifyListeners();

    if (selectedIndex == null || userList == null || userList!.isEmpty || selectedIndex! >= userList!.length) {
      _isThrowFireInProgress = false;
      notifyListeners();
      return;
    }

    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/fire/${userList![selectedIndex!].receiveMemberId}';

    try {
      Map<String, dynamic> body = {};
      if (messageController.text.isNotEmpty) {
        body['message'] = messageController.text;
      }

      log('불던지기 메세지: $body');

      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        body: body.isNotEmpty ? body : null,
        fromJson: (data) => data as Map<String, dynamic>,
      );

      log('throwFire response: ${apiResponse.data}');

      // 불 던지기 메세지 추가 유무
      if (apiResponse.data != null) {
        AmplitudeConfig.analytics.logEvent(
            messageController.text.isNotEmpty
                ? "dropfire_message_complete"
                : "dropfire_nomessage_complete",
            eventProperties: {
              // 사용자가 보낸 메세지 길이(필요 없을 거 같긴 함)
              "message_length": messageController.text.length,
              // 메세지 받는 사람 이름(필요 없을 거 같긴 함22)
              "receiver": userList![selectedIndex!].nickname
            });
      }

      // 불 던지기 성공적으로 완료
      if (apiResponse.data != null) {
        String? nickname = await AmplitudeConfig.analytics.getUserId();
        if (nickname == null) {
          AmplitudeConfig.analytics.logEvent("dropfire_complete",
              eventProperties: {
                "receiver": userList![selectedIndex!].nickname
              });
        } else {
          AmplitudeConfig.analytics.logEvent("dropfire_complete",
              eventProperties: {
                "receiver": userList![selectedIndex!].nickname,
                "sender": nickname
              });
        }
        messageController.clear();

        loadFirePersonList();
        completeThrowFireModal();
        initSelectedUser();
        notifyListeners();
      } else {
        log('loadFirePersonList is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('불던지기 실패: $e');
    } finally {
      _isThrowFireInProgress = false;
      notifyListeners();
    }
  }

  // 선택 유저 초기화 메소드
  void initSelectedUser() {
    selectedIndex = null;
    selectedUserName = '모임원 프로필을 클릭해보세요';
    notifyListeners();
  }

  // 선택 적용
  void setSelectedIndex(int index) {
    if (userList != null && userList!.isNotEmpty && index < userList!.length) {
      selectedIndex = index;
      if (userList![selectedIndex!].fireStatus == "False") {
        selectedUserName = '불 던지기는 1시간에 1번 가능해요';
      } else {
        selectedUserName = '${userList![selectedIndex!].nickname}님에게 불을 던져\n 푸시알림을 보내요';
      }
    } else {
      selectedUserName = '유효한 사용자가 없습니다.';
      selectedIndex = null;
    }
    notifyListeners();
  }

  // 불 던지기 버튼 클릭
  void firePressed() async {
    if (_isThrowFireInProgress || selectedIndex == null || userList == null || userList!.isEmpty) {
      return;
    }

    if (userList![selectedIndex!].fireStatus == "True") {
      await throwFire();
    }
  }

  void completeThrowFireModal() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        Future.delayed(const Duration(seconds: 2), () {
          if (ModalRoute.of(dialogContext)?.isCurrent ?? false) {
            Navigator.of(dialogContext).pop();
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent, // 다이얼로그의 배경색을 투명하게 설정
          child: ClipRRect(
            // ClipRRect를 사용하여 borderRadius를 적용
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: double.infinity,
              height: 277,
              decoration: BoxDecoration(
                color: grayScaleGrey600,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 42),
                  const Text(
                    '발등에 불 떨어트리는 중..',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: grayScaleGrey100,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SvgPicture.asset(
                    'asset/icons/icon_fire_graphic.svg',
                    width: 160,
                    height: 160,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) {
      if (value == true) {
        log('Dialog closed');
      }
    });
  }
}
