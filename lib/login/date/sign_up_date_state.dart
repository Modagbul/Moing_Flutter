import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/config/amplitude_config.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/request/sign_up_request.dart';
import 'package:moing_flutter/utils/api/refresh_token.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';

class SignUpDateState extends ChangeNotifier {
  final BuildContext context;
  final SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
  final TokenManagement tokenManagement = TokenManagement();
  final APICall call = APICall();
  DateTime selectedDate = DateTime.now();

  String nickname = '';
  String? gender = '';

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
    bool? result = await signUp(formattedDate);
    if (result == true) {

      navigateToHomePage();
  addAmplitudeSignUpEvent(formattedDate);
    }
  }

  void skipPressed() async {
    bool? result = await signUp(null);
    if (result == true) {
      addAmplitudeSignUpEvent(null);
      navigateToWelcomePage();
    }
  }

  void addAmplitudeSignUpEvent(String? formattedDate) {
    AmplitudeConfig.analytics.logEvent("signup_complete", eventProperties: {
      "nickname": nickname,
      "gender": gender,
      "date": formattedDate ?? 'unknown',
    });
  }

  void navigateToWelcomePage() {
      navigateToHomePage();
  }

  void navigateToHomePage() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      MainPage.routeName,
          (route) => false,
      arguments: 'fromSignUp',
    );
  }

  Future<bool?> signUp(String? birthDate) async {
    final String apiUrl = '${dotenv.env['MOING_API']}/api/auth/signUp';

    if (gender != null) {
      convertGenderText();
    }

    SignUpData data = SignUpData(
      nickName: nickname,
      gender: gender,
      birthDate: birthDate,
    );

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'PUT',
        body: data.toJson(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess == true) {
        tokenManagement.saveToken(apiResponse.data?['accessToken'],
            apiResponse.data?['refreshToken']);
        log('${apiResponse.data?['refreshToken']}');
        return apiResponse.data?['registrationStatus'] == true ? true : false;
      } else {
        log('signUp is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('소모임 생성 실패: $e');
    }
  }

  void convertGenderText() {
    switch (gender) {
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
  }
}
