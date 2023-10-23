import 'package:flutter/material.dart';

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
    T Function(dynamic) fromJson,
  ) {
    return ApiResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      errorCode: json['errorCode'],
      data: json['data'] != null ? fromJson(json['data']) : null,
    );
  }
}
