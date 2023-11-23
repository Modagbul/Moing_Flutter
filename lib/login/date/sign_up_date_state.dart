import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/fcm/fcm_state.dart';
import 'package:moing_flutter/login/register_success/welcome_page.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/request/sign_up_request.dart';
import 'package:moing_flutter/utils/api/api_error.dart';
import 'package:moing_flutter/utils/api/refresh_token.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class SignUpDateState extends ChangeNotifier {
  final BuildContext context;
  final SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
  final TokenManagement tokenManagement = TokenManagement();
  final ApiException apiException = ApiException();
  final APICall call = APICall();
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
    bool? result = await signUp(formattedDate);
    if (result == true) {
      Navigator.of(context).pushNamed(
        WelcomePage.routeName,
      );
    }
  }

  Future<bool?> signUp(String birthDate) async {
    final String apiUrl = '${dotenv.env['MOING_API']}/api/auth/signUp';

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

      if(apiResponse.isSuccess == true) {
        tokenManagement.saveToken(apiResponse.data?['accessToken'],
            apiResponse.data?['refreshToken']);
        print('${apiResponse.data?['refreshToken']}');
        return apiResponse.data?['registrationStatus'] == true ? true : false;
      }
      else {
        if(apiResponse.errorCode == 'J0003') {
          signUp(birthDate);
        }
        else {
          throw Exception('signUp is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      print('소모임 생성 실패: $e');
    }
  }
}
