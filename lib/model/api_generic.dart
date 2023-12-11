import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moing_flutter/login/sign_in/login_page.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:moing_flutter/utils/api/refresh_token.dart';

class APICall {
  final TokenManagement tokenManagement = TokenManagement();

  Future<ApiResponse<T>> makeRequest<T>({
    required String url,
    required String method,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
    required T Function(dynamic) fromJson,
  }) async {
    String? accessToken = await tokenManagement.loadAccessToken();
    final defaultHeaders = {
      "Content-Type": "application/json;charset=UTF-8",
      if (accessToken != null) "Authorization": "Bearer $accessToken"
    };

    Uri uri = Uri.parse(url);
    http.Response response;

    try {
      if (method == 'GET') {
        response = await http.get(uri, headers: defaultHeaders);
      } else if (method == 'POST') {
        response = body != null
            ? await http.post(uri,
            headers: defaultHeaders, body: json.encode(body))
            : await http.post(uri, headers: defaultHeaders);
      } else if (method == 'DELETE') {
        response = body != null
            ? await http.delete(uri,
            headers: defaultHeaders, body: json.encode(body))
            : await http.delete(uri, headers: defaultHeaders);
      } else if (method == 'PUT') {
        response = body != null
            ? await http.put(uri,
            headers: defaultHeaders, body: json.encode(body))
            : await http.put(uri, headers: defaultHeaders);
      } else {
        throw Exception('HTTP 통신 중 지원하지 않는 method 입니다 : $method');
      }

      Map<String, dynamic> responseBody =
      jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(responseBody, fromJson);
      } else {
        String errorCode = responseBody['errorCode'];
        if (errorCode == 'J0003') {
          print('API Generic 에서 토큰 재발급 받기를 시행합니다. : $errorCode');
          // 토큰 재발급 받기
          bool renewalTokenSuccess = await tokenManagement.getNewToken();
          if (!renewalTokenSuccess) {
            print('리프레시 토큰이 만료되어 로그인 페이지로 이동합니다..');
            Navigator.of(GetIt.I.get<GlobalKey<NavigatorState>>().currentContext!)
                .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
            throw Exception('로그인 만료 : $errorCode');
          }

          print('액세스 토큰 재발급 받기에 성공하였습니다.');
          return makeRequest(
            url: url,
            method: method,
            fromJson: fromJson,
          );
        } else if (errorCode == 'J0008') {
          print('J0008 JWT 토큰 만료, 리프레시 토큰이 만료되어 로그인 페이지로 이동합니다.');
          Navigator.of(GetIt.I.get<GlobalKey<NavigatorState>>().currentContext!)
              .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
          throw Exception('리프레시 토큰이 만료되어 로그인 이동 : $errorCode');
        } else {
          String msg = '';
          switch (errorCode) {
          // ... 다른 예외 처리 ...
          }
          throw Exception(msg);
        }
      }
    } catch (e) {
      throw Exception('API Generic에서 예외 발생!! : ${e.toString()}');
    }
  }
}
