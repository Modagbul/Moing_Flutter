import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moing_flutter/login/sign_in/login_page.dart';
import 'package:moing_flutter/utils/api/refresh_token.dart';

class ApiException implements Exception {
  TokenManagement tokenManagement = TokenManagement();
  Future<void> throwErrorMessage(String errorCode) async {
    String msg='';

    print('에러코드 : $errorCode');

    if (errorCode == 'J0008') {
      print('리프레시 토큰이 만료되어 로그인 페이지로 이동합니다..');
      GetIt.I.get<GlobalKey<NavigatorState>>().currentState!.pushNamed(LoginPage.routeName);
      return ;
    }

    // 만료된 토큰 -> 토큰 재발급
    if (errorCode == 'J0003') {
      // 토큰 재발급 받기
      return await tokenManagement.getNewToken();
    }

    switch (errorCode) {
      case '400':
        msg = '요청 형식 자체가 틀리거나 권한이 없습니다.';
        break;
      case '403':
        msg = '접근 권한이 존재하지 않습니다. 로그인을 먼저 진행해주세요.';
        break;
      case '405':
        msg = 'HTTP 메서드가 리소스에서 허용되지 않습니다.';
        break;
      case '500':
        msg = '서버 오류 발생';
        break;
      case 'J0001':
        msg = '예상치 못한 오류가 발생했습니다.';
        break;
      case 'J0002':
        msg = '잘못된 JWT 서명입니다.';
        break;
      case 'J0004':
        msg = '지원되지 않는 토큰입니다.';
        break;
      case 'J0005':
        msg = '접근이 거부되었습니다';
        break;
      case 'J0006':
        msg = '토큰이 잘못되었습니다.';
        break;
      case 'J0007':
        msg = '추가 정보 입력(닉네임)이 필요합니다';
        break;
      case 'J0008':
        msg = '유효하지 않은 refreshToken입니다.';
        break;
      case 'U0001':
        msg = '해당 유저는 존재하지 않습니다.';
        break;
      case 'AU0001':
        msg = '이미 다른 소셜 플랫폼으로 가입하셨습니다.';
        break;
      case 'AU0002':
        msg = '입력 토큰이 유효하지 않습니다.';
        break;
      case 'AU0003':
        msg = '애플 아이디가 유효하지 않습니다.';
        break;
      case 'AU0004':
        msg = '닉네임이 중복됩니다.';
        break;
    }

    throw Exception(errorCode + ' : ' + msg);
  }
}