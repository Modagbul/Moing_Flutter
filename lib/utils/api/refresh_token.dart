import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TokenManagement {
  /// 토큰 재발급
  Future<void> getNewToken(String refreshToken) async {
    String refreshToken = await loadRefreshToken();

    final String apiUrl = '${dotenv.env['MOING_API']}/api/auth/reissue';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8', // 요청 헤더 설정
      },
      body: jsonEncode(<String, String>{
        'token': refreshToken, // POST 요청 본문에 들어갈 토큰
      }),
    );

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final String accessToken = responseBody['data']['accessToken'];
      final String refreshToken = responseBody['data']['refreshToken'];

      // sharedPreferences를 이용하여 accessToken, refreshToken 저장
      await saveToken(accessToken, refreshToken);
    }

    return;
  }

  /// 토큰 저장 또는 수정
  Future<void> saveToken(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    // 저장 또는 수정
    prefs.setString('ACCESS_TOKEN', accessToken);
    prefs.setString('REFRESH_TOKEN', refreshToken);
  }

  /// 토큰 삭제
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('ACCESS_TOKEN');
    prefs.remove('REFRESH_TOKEN');
  }

  /// Access Token 값 불러오기
  Future<String> loadAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ACCESS_TOKEN')!;
  }

  /// Refresh Token 값 불러오기
  Future<String> loadRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('REFRESH_TOKEN')!;
  }
}
