import 'package:flutter/material.dart';
import 'package:moing_flutter/login/login_screen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';


void main() {
  KakaoSdk.init(nativeAppKey: '6671c3a9b377c8f302c17c14e2c940f2');
  runApp(const MaterialApp(
    home: LoginScreen(),
  ),
  );
}