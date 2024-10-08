import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  String? memberName;
  String errorCode = '';
  int? numOfTeam;

  String authStatus = "Unknown";

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

  Future<bool?> showCustomTrackingDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dear User'),
        content: const Text(
          'We care about your privacy and data security. We keep this app free by showing ads. '
              'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
              'Our partners will collect data and use a unique identifier on your device to show you ads.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    final TrackingStatus status =
    await AppTrackingTransparency.trackingAuthorizationStatus;
    authStatus = '$status';
    print('authStatus1 = $status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // // Show a custom explainer dialog before the system dialog
      // var result = await showCustomTrackingDialog(context);
      // print('result: $result');
      // // Wait for dialog popping animation
      // await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
      await AppTrackingTransparency.requestTrackingAuthorization();
      authStatus = '$status';
      print('authStatus2 = $status');
      notifyListeners();
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  void initStart() async {
    await Future.delayed(
      const Duration(
        seconds: 2,
        milliseconds: 500,
      ),
    );

    await initPlugin();
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
            if(numOfTeam != null) {
              if(numOfTeam! < 3) {
                bool? isRegistered = await registerTeam();
                // 가입 완료되었을 때
                if(isRegistered != null && isRegistered) {
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      InvitationWelcomePage.routeName,
                          (route) => false,
                      arguments: {
                        'teamName': teamName,
                        'teamLeaderName': teamLeaderName,
                        'memberName': memberName});
                }
                else {
                  /// TODO : 메인 페이지로 이동하면서 추가 조건 넣어줘야 함.
                  print('다이나믹 링크로 접속했지만 이미 가입된 유저라 가입하지 못했을 때~ 추가 전달 메세지 필요!');
                  print('errorCode : $errorCode');
                  if(errorCode == 'T0004') {
                    /// 이미 가입된 유저라 가입하지 못했을 때
                    Navigator.pushNamedAndRemoveUntil(
                        context, MainPage.routeName, (route) => false, arguments: 'isRegistered');
                  }
                  else {
                    print('다이나믹 링크로 진입했지만 에러났을 때 : $errorCode');
                    Navigator.pushNamedAndRemoveUntil(
                        context, MainPage.routeName, (route) => false, arguments: errorCode);
                  }
                }
              } else {
                /// 팀 소모임 3개 초과했을 때
                Navigator.pushNamedAndRemoveUntil(
                    context, MainPage.routeName, (route) => false , arguments: 'full'
                );
              }
            } else {
              String code = errorCode.length > 0 ? errorCode : 'fail';
              Navigator.pushNamedAndRemoveUntil(
                  context, MainPage.routeName, (route) => false ,
                  arguments: code,
              );
            }
          }
        }
        /// 일반적으로 접속한 사람 (teamId = null)
        else {
          bool? isUser = await checkUser();
          if(isUser != null && isUser) {
            print('JWTTOKEN: $accessToken');
            Navigator.pushNamedAndRemoveUntil(
                context, MainPage.routeName, (route) => false);
          }
          else {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routeName, (route) => false);
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
        print('errorCode : ${apiResponse.errorCode}');
      }
    } catch (e) {
      print('initState - checkUser 중 에러 발생 : ${e.toString()}');
    }
    return false;
  }

  /// 가입하려는 팀 이름과, 현재 가입되어 있는 소모임 개수 확인
   Future<void> getTeamNameAndNumber() async {
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
        memberName = apiResponse.data?['memberName'];
      } else {
        print('다이나믹 링크 후 팀 조회 실패 : ${apiResponse?.errorCode}');
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
        print('소모임 가입 실패1 : ${apiResponse?.errorCode}');
        errorCode = apiResponse.errorCode!;
      }
    } catch (e) {
      print('소모임 가입 실패2 : ${e.toString()}');
      List<String> list = e.toString().split(": ");
      errorCode = list[3];
    }
    return false;
  }
}