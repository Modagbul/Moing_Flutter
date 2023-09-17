import 'package:flutter/material.dart';

class ApiResponse<T> {
  bool isSuccess;
  String message;
  T data;

  ApiResponse({
    required this.isSuccess,
    required this.message,
    required this.data});

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ApiResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: fromJsonT(json['data']),
    );
  }
}