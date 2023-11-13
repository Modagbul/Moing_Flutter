import 'dart:convert';

class UserDeactivationRequest {
  final String reason;

  UserDeactivationRequest({required this.reason});

  // 클래스 객체를 JSON으로 변환하기 위한 메서드
  Map<String, dynamic> toJson() => {
    'reason': reason,
  };
}