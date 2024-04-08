import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/utils/global/api_generic.dart';

import '../model/request/sign_up_request.dart';
import '../utils/api/refresh_token.dart';
import '../utils/global/api_response.dart';

class SignUpDataSource {
  String nickname;
  String? gender;
  APICall call = APICall();
  final TokenManagement tokenManagement = TokenManagement();

  SignUpDataSource({required this.nickname, this.gender});

  Future<bool?> signUp(String? birthDate) async {
    log('signUp in SignUpRepository called with birthDate: $birthDate');

    final String apiUrl = '${dotenv.env['MOING_API']}/api/auth/signUp';

    if (gender != null) {
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

    SignUpData data = SignUpData(
      nickName: nickname,
      gender: gender,
      birthDate: birthDate,
    );

    log('SignUpData: ${jsonEncode(data.toJson())}');

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
}