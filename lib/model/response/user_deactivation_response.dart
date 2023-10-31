import 'dart:developer';

class UserDeactivationResponse {
  final bool isSuccess;
  final String message;

  UserDeactivationResponse({
    required this.isSuccess,
    required this.message,
  });

  factory UserDeactivationResponse.fromJson(dynamic json) {
    return UserDeactivationResponse(
      message: json['message'] as String,
      isSuccess: json['isSuccess'] as bool,
    );
  }
}
