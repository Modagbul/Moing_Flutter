import 'dart:io';

import 'package:moing_flutter/utils/api/refresh_token.dart';

class ApiException implements Exception {
  TokenManagement tokenManagement = TokenManagement();

  void throwErrorMessage(String errorCode) async {
    String msg='';

    // 만료된 토큰 -> 토큰 재발급
    if (errorCode == 'J0003') {
      // Refresh 토큰 값 가져오기
      String refreshToken = await tokenManagement.loadRefreshToken();
      // 토큰 재발급 받기
      await tokenManagement.getNewToken(refreshToken);
      return ;
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
    }

    throw HttpException(errorCode + ' : ' + msg);
  }
}