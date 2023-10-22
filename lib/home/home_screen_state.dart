import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
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
  String nickname = '';

  TeamData? futureData;
  /// Test API
  final ApiCode apiCode = ApiCode();

  String apiUrl = '';
  // 알림 여부
  bool isNotification = false;

  HomeScreenState({required this.context}) {
    log('Instance "HomeScreenState" has been created');
    loadTeamData();
  }

  /// API 데이터 로딩
  void loadTeamData() async {
    futureData = await fetchApiData();
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
          fetchApiData();
        }
      }
      return null;
    } catch(e) {
      print('홈 화면 받아 오는 중 에러 발생 : ${e.toString()}');
      return null;
    }
  }
  // Future<ApiResponse<TeamData>> fetchApiData(String url, String accessToken) async {
  //   print('액세스 토큰 : Bearer ${accessToken}');
  //   final response = await http.get(
  //     Uri.parse(apiUrl),
  //     headers: {
  //       "Content-Type": "application/json;charset=UTF-8",
  //       "Authorization": "Bearer $accessToken",
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('홈 화면 연동 성공!');
  //
  //     ApiResponse<TeamData> apiResponse = ApiResponse.fromJson(
  //       jsonDecode(utf8.decode(response.bodyBytes)),
  //         (data) => TeamData.fromJson(data),
  //     );
  //     print('${apiResponse.data?.memberNickName}');
  //     print('${apiResponse.data?.numOfTeam}');
  //     return ApiResponse<TeamData>.fromJson(
  //         jsonDecode(utf8.decode(response.bodyBytes)),
  //             (dynamic data) => TeamData.fromJson(data as Map<String, dynamic>));
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  void alarmPressed() {
    Navigator.of(context).pushNamed(
      AlarmPage.routeName,
    );
  }

  void makeGroupPressed() {
    Navigator.of(context).pushNamed(
      GroupCreateStartPage.routeName,
    );
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
