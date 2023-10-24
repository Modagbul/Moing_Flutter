import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:moing_flutter/board/board_main_page.dart';
import 'package:moing_flutter/main/alarm/alarm.dart';
import 'package:moing_flutter/make_group/group_create_start_page.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/response/group_team_response.dart';
import 'package:moing_flutter/utils/api/refresh_token.dart';

class HomeScreenState extends ChangeNotifier {
  final BuildContext context;
  final TokenManagement tokenManagement = TokenManagement();
  final APICall call = APICall();
  String? newCreated;
  String nickname = '';

  TeamData? futureData;
  List<TeamBlock> teamList = [];
  /// Test API
  final ApiCode apiCode = ApiCode();

  String apiUrl = '';
  // 알림 여부
  bool isNotification = false;

  HomeScreenState({required this.context, this.newCreated}) {
    log('Instance "HomeScreenState" has been created');
    loadTeamData();
  }

  /// API 데이터 로딩
  void loadTeamData() async {
    futureData = await fetchApiData();
    if(futureData != null) {
      teamList = futureData!.teamBlocks;
    }
    notifyListeners();
  }

  Future<TeamData?> fetchApiData() async {
    try {
      apiUrl = '${dotenv.env['MOING_API']}/api/team';
      ApiResponse<TeamData> apiResponse = await call.makeRequest<TeamData>(
        url: apiUrl,
        method: 'GET',
        fromJson: (json) => TeamData.fromJson(json),
      );

      if(apiResponse.isSuccess == true) {
        nickname = apiResponse.data!.memberNickName;
        return apiResponse.data!;
      }
      else {
        if(apiResponse.errorCode == 'J0003') {
          print('재실행합니다.');
          return await fetchApiData();
        }
      }
      return null;
    } catch(e) {
      print('홈 화면 받아 오는 중 에러 발생 : ${e.toString()}');
      return null;
    }
  }

  // 알람 클릭
  void alarmPressed() {
    Navigator.of(context).pushNamed(
      AlarmPage.routeName,
    );
  }

  // 모임 만들기 클릭
  void makeGroupPressed() {
    Navigator.of(context).pushNamed(
      GroupCreateStartPage.routeName,
    );
  }

  // 가입한 모임 클릭
  void teamPressed(int teamId) {
    /// 목표보드 페이지로 이동
    Navigator.pushNamed(context, BoardMainPage.routeName, arguments: teamId);
  }

  void apiTest() {
    /// Team 소모임 개설
    // apiCode.makeTeamAPI();
    /// Team 소모임 가입
    // apiCode.joinTeamAPI();
    /// Team 목표보드_소모임 단건 조회
    // apiCode.getSingleBoard();
    /// Team 소모임 수정
    // apiCode.fixTeam();

    /// Mission 생성
    // apiCode.makeMissionAPI();
    /// Mission 조회
    // apiCode.getSingleMission();
    /// Mission 수정
    // apiCode.fixSingleMission();
    /// Mission 삭제
    // apiCode.removeMission();
    /// Mission 인증
    // apiCode.certifyMission();
  }
}
