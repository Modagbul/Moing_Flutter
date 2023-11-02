import 'dart:convert';
import 'dart:developer';

import 'package:moing_flutter/model/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:moing_flutter/utils/api/api_error.dart';
import 'package:moing_flutter/utils/api/refresh_token.dart';

class APICall {
  final TokenManagement tokenManagement = TokenManagement();
  final ApiException exception = ApiException();

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

      Map<String, dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      if(response.statusCode == 200) {
        return ApiResponse.fromJson(responseBody, fromJson);
      } else {
        print('에러코드 : ${response.statusCode}');
        await exception.throwErrorMessage(responseBody['errorCode']);
        // errorCode가 담긴 body 그대로 반환
        return ApiResponse.fromJson(responseBody, fromJson);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
