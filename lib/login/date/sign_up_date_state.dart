import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/fcm/fcm_state.dart';
import 'package:moing_flutter/login/register_success/welcome_page.dart';
import 'package:http/http.dart' as http;
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/request/sign_up_request.dart';
import 'package:moing_flutter/model/response/sign_up_response.dart';
import 'package:moing_flutter/utils/api/api_error.dart';
import 'package:moing_flutter/utils/api/refresh_token.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class SignUpDateState extends ChangeNotifier {
  final BuildContext context;
  final SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
  final TokenManagement tokenManagement = TokenManagement();
  final ApiException apiException = ApiException();
  DateTime selectedDate = DateTime.now();

  String nickname = '';
  String gender = '';

  SignUpDateState({
    required this.context,
    required this.nickname,
    required this.gender,
  }) {
    log('Instance "SignUpDateState" has been created');
  }

  void changeDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void nextPressed() async {
    // 생년월일만 가져옴.
    String formattedDate = selectedDate.toLocal().toString().split(' ')[0];
    String? accessToken = await tokenManagement.loadAccessToken();

    bool? result = await signUp(formattedDate, accessToken);
    if(result == true) {
      Navigator.of(context).pushNamed(
        WelcomePage.routeName,
      );
    }
  }

  Future<bool?> signUp(String birthDate, String? accessToken) async {
    String? fcmToken;
    await Future.microtask(() async {
      final fcmState = context.read<FCMState>();

      await fcmState.requestPermission();
      fcmToken = await fcmState.updateToken();
    });

    if(fcmToken == null) {
      print('fcmToken값을 가져올 수 없습니다..');
      return null;
    }
    try {
      final String apiUrl = '${dotenv.env['MOING_API']}/api/auth/signUp';

      switch(gender) {
        case '남자':
          gender = 'MAN';
          break;
        case '여자':
          gender = 'WOMAN';
          break;
        case '기타':
          gender = 'NEUTRALITY';
          break;
      }

      SignUpData data = SignUpData(
        nickName: nickname,
        gender: gender,
        birthDate: birthDate,
        fcmToken: fcmToken!,
      );

      print('requestData : ${data.toString()}');
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json;charset=UTF-8",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        ApiResponse<SignUpResponseData> apiResponse = ApiResponse.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)),
              (data) => SignUpResponseData.fromJson(data),
        );
        tokenManagement.saveToken(apiResponse.data.accessToken, apiResponse.data.refreshToken);
        return apiResponse.data.registrationStatus == true ? true : false;
      } else {
        var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        apiException.throwErrorMessage(responseBody['errorCode']);
        // 토큰 재발급 처리 완료
        if (responseBody['errorCode'] == 'J0003') {
          print('토큰 재발급 처리 수행합니다.');
          String? refreshToken = await tokenManagement.loadRefreshToken();
          if(refreshToken == null) {
            print('refreshToken 존재하지 않습니다..');
            return null;
          }
          await signUp(birthDate, refreshToken);
        }
      }
    } catch (e) {
      print('SignUpDateState에서 회원가입 도중 에러가 발생했습니다 : ${e.toString()}');
    }
  }
}