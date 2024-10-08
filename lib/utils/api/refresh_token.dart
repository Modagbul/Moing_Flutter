import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TokenManagement {
  final SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
  int count = 0;
  /// 토큰 재발급
  Future<bool> getNewToken() async {
    String? refreshToken = await loadRefreshToken();
    if(refreshToken == null) {
      print('refreshToken 값이 존재하지 않습니다.');
      return false;
    }

    print('재발급받기 위한 refreshToken : $refreshToken');

    final String apiUrl = '${dotenv.env['MOING_API']}/api/auth/reissue';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8', // 요청 헤더 설정
        "RefreshToken": refreshToken,
      },
    );

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final String accessToken = responseBody['data']['accessToken'];
      final String refreshToken = responseBody['data']['refreshToken'];

      // sharedPreferences를 이용하여 accessToken, refreshToken 저장
      print('액세스 토큰, 리프레시 토큰이 갱신되었습니다!');
      await saveToken(accessToken, refreshToken);
      return true;
    }

    else {
      print('Token Management에서 액세스 토큰 갱신 실패 : ${responseBody['errorCode']}');
      return false;
    }
  }

  /// 토큰 저장 또는 수정
  Future<void> saveToken(String accessToken, String refreshToken) async {
    SaveAccessToken(accessToken);
    SaveRefreshToken(refreshToken);
  }

  /// 토큰 삭제
  Future<void> deleteToken() async {
    sharedPreferencesInfo.removePreferencesData('ACCESS_TOKEN');
    sharedPreferencesInfo.removePreferencesData('REFRESH_TOKEN');
  }

  /// Access Token 값 불러오기
  Future<String?> loadAccessToken() async {
    String? accessToken = await sharedPreferencesInfo.loadPreferencesData('ACCESS_TOKEN');
    return accessToken;
  }

  Future<void> SaveAccessToken(String accessToken) async {
    print('access Token이 저장되었습니다 : $accessToken');
    return await sharedPreferencesInfo.savePreferencesData('ACCESS_TOKEN', accessToken);
  }

  /// Refresh Token 값 불러오기
  Future<String?> loadRefreshToken() async {
    String? refreshToken = await sharedPreferencesInfo.loadPreferencesData('REFRESH_TOKEN');
    print('Refresh Token : $refreshToken');
    return refreshToken;
  }

  Future<void> SaveRefreshToken(String refreshToken) async {
    print('refresh Token이 저장되었습니다 : $refreshToken');
    return await sharedPreferencesInfo.savePreferencesData('REFRESH_TOKEN', refreshToken);
  }
}
