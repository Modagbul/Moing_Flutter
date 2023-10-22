import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;
import 'package:moing_flutter/login/sign_up/sign_up_page.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/utils/api/api_error.dart';
import 'package:moing_flutter/utils/api/refresh_token.dart';
import 'dart:io';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginState extends ChangeNotifier {
  /// Login Page에서 사용하는 context를 가져옴.
  final BuildContext context;
  bool? _isRegistered;
  TokenManagement tokenManagement = TokenManagement();
  ApiException apiException = ApiException();

  bool onLoading = false;

  /// Context를 사용하여 initState() 생성
  /// initState, dispose에서 controller 등 생성, 삭제 해주고,
  /// 우리가 어떤 페이지에 있는지 알기 위해 log를 찍어서 확인한다.
  LoginState({required this.context}) {
    log('Instance "LoginState" has been created');
  }

  @override
  void dispose() {
    log('Instance "LoginState" has been removed');
    super.dispose();
  }

  /// 닉네임 페이지 이동 (테스트 코드)
  void moveSignPage() {
    Navigator.of(context).pushNamed(
      SignUpPage.routeName,
    );
  }

  /// 카카오 로그인 함수
  void signInWithKakao() async {
    try {
      if(onLoading) return;
      onLoading = true;

      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      print(token);
      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

      // 카카오 로그인 후 백엔드에 토큰 전송
      await sendKakaoTokenToBackend(token.accessToken);

    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    } finally {
      onLoading = false;
    }
  }

  /// 카카오 토큰을 백엔드에 전송하는 함수
  Future<void> sendKakaoTokenToBackend(String token) async {
    try {
      final String apiUrl = '${dotenv.env['MOING_API']}/api/auth/signIn/kakao';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8', // 요청 헤더 설정
        },
        body: jsonEncode(<String, String>{
          'token': token, // POST 요청 본문에 들어갈 토큰
        }),
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if(responseBody['isSuccess'] == true) {
        final String accessToken = responseBody['data']['accessToken'];
        final String refreshToken = responseBody['data']['refreshToken'];

        // sharedPreferences를 이용하여 accessToken, refreshToken 저장
        await tokenManagement.saveToken(accessToken, refreshToken);

        _isRegistered = responseBody['data']['registrationStatus'];
        print('카카오 회원가입 여부 : $_isRegistered');
        checkRegister(_isRegistered!);
      }
      /// 에러 처리
      else {
        apiException.throwErrorMessage(responseBody['errorCode']);
        // 토큰 재발급 처리 완료
        if (responseBody['errorCode'] == 'J0003') {
          print('토큰 재발급 처리 수행합니다.');
          String? accessToken = await tokenManagement.loadAccessToken();
          if(accessToken == null) {
            print('accessToken이 존재하지 않습니다..');
            return null;
          }
          await sendKakaoTokenToBackend(accessToken);
        }
      }
    } catch (e) {
      print('카카오 - 백엔드 연동 간 에러 발생 : ${e.toString()}');
    }
  }

  /// IOS 13 버전 앱 로그인
  Future<void> signInWithApple() async {
    /// IOS 13 버전 이상인지 확인
    bool isAvailable = await SignInWithApple.isAvailable();

    /// IOS 13 버전 이상인 경우
    if (isAvailable) {
      try {
        if (onLoading) return ;
        onLoading = true;

        // Request credential for the currently signed in Apple account.
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        // decodeJWT(appleCredential!.identityToken!);
        print('애플 액세스 토큰 : ${appleCredential.identityToken}');
        await appleLoginSendToken(appleCredential.identityToken!);
      } catch (e) {
        print('애플 로그인 실패 : ${e.toString()}');
      } finally {
        onLoading = false;
      }
    }

    /// IOS 13 버전이 아닌 경우
    else {
      throw PlatformException(
        code: 'APPLE_SIGN_IN_NOT_AVAILABLE',
        message: 'Sign in With Apple is not available on this device.',
      );
    }
  }

  /// 애플 소셜 로그인 요청 API
  Future<void> appleLoginSendToken(String token) async {
    try {
      final String apiUrl = '${dotenv.env['MOING_API']}/api/auth/signIn/apple';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8', // 요청 헤더 설정
        },
        body: jsonEncode(<String, String>{
          'token': token, // POST 요청 본문에 들어갈 토큰
        }),
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if(responseBody['isSuccess'] == true) {
        final String accessToken = responseBody['data']['accessToken'];
        final String refreshToken = responseBody['data']['refreshToken'];

        // sharedPreferences를 이용하여 accessToken, refreshToken 저장
        await tokenManagement.saveToken(accessToken, refreshToken);

        _isRegistered = responseBody['data']['registrationStatus'];
        checkRegister(_isRegistered!);
      }
      /// 에러 처리
      else {
        apiException.throwErrorMessage(responseBody['errorCode']);
        // 토큰 재발급 처리 완료
        if (responseBody['errorCode'] == 'J0003') {
          print('토큰 재발급 처리 수행합니다.');
          String? accessToken = await tokenManagement.loadAccessToken();
          if(accessToken == null) {
            print('accessToken이 존재하지 않습니다..');
            return null;
          }
          await appleLoginSendToken(accessToken);
        }
      }
    } catch (e) {
      print('애플 - 백엔드 연동 간 에러 발생 : ${e.toString()}');
    }
  }

  /// 회원가입 여부 판단
  void checkRegister(bool isRegistered) {
    // 회원가입이 되어있는 경우
    if(isRegistered) {
      Navigator.of(context).pushNamed(
        MainPage.routeName,
      );
    }
    // 회원가입 되어있지 않은 경우
    else {
      // 회원가입 화면으로 이동
      Navigator.of(context).pushNamed(
        SignUpPage.routeName,
      );
    }
  }
}
