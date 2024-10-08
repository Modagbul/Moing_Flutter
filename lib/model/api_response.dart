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
      T Function(dynamic)? fromJson,
      ) {
    log(json.toString());
    return ApiResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      errorCode: json['errorCode'],
      data: json['data'] != null && fromJson != null ? fromJson(json['data']) : null,
    );
  }
}
