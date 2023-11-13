import 'dart:developer';

class ApiResponse<T> {
  bool isSuccess;
  String message;
  String? errorCode;
  T? data;

  ApiResponse(
      {required this.isSuccess,
      required this.message,
      this.errorCode,
      this.data});

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic)? fromJson, // nullable 함수로 변경
      ) {
    log(json.toString());
    return ApiResponse(
      isSuccess: json['isSuccess'] ?? false, // null 일 경우 기본값 false
      message: json['message'] ?? '', // null 일 경우 기본값 빈 문자열
      errorCode: json['errorCode'],
      data: json['data'] != null && fromJson != null ? fromJson(json['data']) : null,
    );
  }
}
