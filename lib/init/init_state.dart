import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/login/gender/sign_up_gender_page.dart';
import 'package:moing_flutter/login/invitate_link/welcome_team_page.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_first.dart';
import 'package:moing_flutter/login/sign_in/login_page.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/utils/api/refresh_token.dart';
import 'package:moing_flutter/utils/dynamic_link/dynamic_link.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';

class InitState extends ChangeNotifier {
  BuildContext context;
  final SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
  final TokenManagement tokenManagement = TokenManagement();
  final DynamicLinkService dynamicLinkService;
  final APICall call = APICall();
  String apiUrl = '';
  String? teamId;
  String? teamName;
  String? teamLeaderName;
  String errorCode = '';
  int? numOfTeam;

  InitState({
    required this.context,
    required this.dynamicLinkService,
    required this.teamId,
  }) {
    print('Instance "InitState" has been created');
    print('teamId : $teamId');
    initStart();
  }

  @override
  void dispose() {
    print('Instance "InitState" has been removed');
    super.dispose();
  }

  void initStart() async {
    await Future.delayed(
      const Duration(
        seconds: 2,
        milliseconds: 500,
      ),
    );

    String? oldUser = await sharedPreferencesInfo.loadPreferencesData('old');
    /// 한 번이라도 앱에 접속한 사람
    if (oldUser == 'true') {
      SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
      String? accessToken = await sharedPreferencesInfo.loadPreferencesData('ACCESS_TOKEN');
      if (accessToken == null) {
        // 액세스 토큰이 유효하지 않은 경우 로그인 페이지로 이동
        Navigator.pushNamedAndRemoveUntil(
            context, LoginPage.routeName, (route) => false);
      }

      else {
        /// 다이나믹 링크로 접속한 사람
        if(teamId != null) {
          bool? isUser = await checkUser();
          if(isUser != null && isUser) {
            await getTeamNameAndNumber();
            if(numOfTeam != null && numOfTeam! < 3) {
              bool? isRegistered = await registerTeam();
              if(isRegistered != null && isRegistered) {
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    InvitationWelcomePage.routeName,
                        (route) => false,
                arguments: {'teamName': teamName, 'teamLeaderName': teamLeaderName,});
              }
              else {
                /// TODO : 메인 페이지로 이동하면서 추가 조건 넣어줘야 함.
                print('다이나믹 링크로 접속했지만 이미 가입된 유저라 가입하지 못했을 때~ 추가 전달 메세지 필요!');
                if(errorCode == 'T0004') {
                  /// 이미 가입된 유저라 가입하지 못했을 때
                  Navigator.pushNamedAndRemoveUntil(
                      context, MainPage.routeName, (route) => false);
                }
                else {
                  print('다이나믹 링크로 진입했지만 에러났을 때 : $errorCode');
                  Navigator.pushNamedAndRemoveUntil(
                      context, MainPage.routeName, (route) => false);
                }
              }
            }
            else {
              /// Team 개수가 3개 초과했을 때
              Navigator.pushNamedAndRemoveUntil(
                /// TODO : 추가 초건 넣어줘야 함
                  context, MainPage.routeName, (route) => false);
            }
          }
        }

        /// 일반적으로 접속한 사람
        else {
          bool? isUser = await checkUser();
          if(isUser != null && isUser) {
            Navigator.pushNamedAndRemoveUntil(
                context, MainPage.routeName, (route) => false);
          }
        }
      }
    } else {
      // 이전에 로그인 한 적 없는 경우 온보딩 페이지로 이동
      Navigator.pushNamedAndRemoveUntil(
          context, OnBoardingFirstPage.routeName, (route) => false);
    }
  }

  /// 다이나믹 링크로 들어온 사람이 기존 유저인지 확인
  Future<bool?> checkUser() async {
    apiUrl = '${dotenv.env['MOING_API']}/api/mypage/test';
    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      // 회원가입 여부 확인
      if (apiResponse.isSuccess) {
        return true;
      } else {
        print('errorCode : ${apiResponse?.errorCode}');
        // 토큰 갱신 여부 확인
        if(apiResponse?.errorCode == 'J0003') {
          checkUser();
          return true;
        } else if (apiResponse?.errorCode == 'J0007' || apiResponse?.errorCode == 'J0008') {
          /// 회원가입 안한 사람의 경우
          Navigator.pushNamedAndRemoveUntil(
              context, LoginPage.routeName, (route) => false);
        }
        else {
          throw Exception('링크 클릭한 사람 에러 발생 : ${apiResponse?.errorCode}');
        }
      }
    } catch (e) {
      print('initState - checkUser 중 에러 발생 : ${e.toString()}');
      return false;
    }
  }

  /// 가입하려는 팀 이름과, 현재 가입되어 있는 소모임 개수 확인
   getTeamNameAndNumber() async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/count';
    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      print('가입 상태 확인 : ${apiResponse?.errorCode}');
      print('가입 상태 확인2 : ${apiResponse.data.toString()}');
      if (apiResponse.isSuccess) {
        print('가입하려는 팀 이름과 소모임 개수는 다음과 같습니다.');

        teamName = apiResponse.data?['teamName'];
        numOfTeam = apiResponse.data?['numOfTeam'] as int;
        teamLeaderName = apiResponse.data?['leaderName'];
      } else {
        if(apiResponse?.errorCode == 'J0003') {
          getTeamNameAndNumber();
        }
        else {
          throw Exception('다이나믹 링크 후 팀 조회 실패 : ${apiResponse?.errorCode}');
        }
      }
    } catch (e) {
      print('다이나믹 링크 후 팀 조회 에러 발생 : ${e.toString()}');
    }
  }

  /// 소모임 가입 API
  Future<bool?> registerTeam() async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId';
    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess) {
        print('$teamId에 가입이 완료되었습니다.');
        return true;
      } else {
        if(apiResponse?.errorCode == 'J0003') {
          registerTeam();
        }
        else {
          throw Exception('소모임 가입 실패1 : ${apiResponse?.errorCode}');
        }
      }
    } catch (e) {
      print('소모임 가입 실패2 : ${e.toString()}');
      List<String> list = e.toString().split(": ");
      errorCode = list[3];
      return false;
    }
  }
}
