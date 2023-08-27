import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:moing_flutter/login/onboarding/on_boarding.dart';
import 'package:moing_flutter/login/sign_in/login_platform.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginState extends ChangeNotifier {
  /// Login Page에서 사용하는 context를 가져옴.
  final BuildContext context;

  /// LoginPage에서 사용할 State 관련 변수들 지정
  LoginPlatform _loginPlatform = LoginPlatform.none;

  /// Context를 사용하여 initState() 생성
  /// initState, dispose에서 controller 등 생성, 삭제 해주고,
  /// 우리가 어떤 페이지에 있는지 알기 위해 log를 찍어서 확인한다.
  LoginState({required this.context}) {
    log('Instance "LoginState" has been created');
    initState();
  }

  @override
  void dispose() {
    log('Instance "LoginState" has been removed');
    super.dispose();
  }

  @override
  void initState() {
    /// 회사 앱에서는 Hive에 사용자를 저장해서, 값이 있으면 가져오는 식으로 사용함
  }

  /// 어떤 SNS로 로그인 했는지 확인 및 로그아웃 창 생성 (임시)
  void checkSNS() {
    if (_loginPlatform != LoginPlatform.none) {

    }
  }

  /// 온보딩 페이지 이동 (테스트 코드)
  void moveOnBoard() {
    Navigator.of(context).pushNamed(
      OnBoardingPage.routeName,
    );
  }
  /// 카카오 로그인 함수
  void signInWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

      _loginPlatform = LoginPlatform.kakao;
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

  /// 로그아웃 함수
  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.facebook:
        break;
      case LoginPlatform.google:
        break;
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        break;
      case LoginPlatform.naver:
        break;
      case LoginPlatform.apple:
        break;
      case LoginPlatform.none:
        break;
    }

    _loginPlatform = LoginPlatform.none;
  }

  /// IOS 13 버전 앱 로그인
  Future<UserCredential> signInWithApple() async {
    /// IOS 13 버전 이상인지 확인
    bool isAvailable = await SignInWithApple.isAvailable();

    /// IOS 13 버전 이상인 경우
    if (isAvailable) {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'moing-team.moing.com',
          redirectUri: Uri.parse(
              'https://moing-ver2.firebaseapp.com/__/auth/handler'),
        ),
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // 최초 1회 사용자 정보 확인. 그 이후에는 null로 뜬다.
      print(appleCredential.givenName);
      print(appleCredential.familyName);
      print(appleCredential.email);

      print(getUserInfoFromJWT(appleCredential.identityToken));

      _loginPlatform = LoginPlatform.apple;
      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      /// 파이어베이스 인증
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    }

    /// IOS 13 버전이 아닌 경우
    else {
      throw PlatformException(
        code: 'APPLE_SIGN_IN_NOT_AVAILABLE',
        message: 'Sign in With Apple is not available on this device.',
      );
    }
  }

  /// 애플 사용자 이메일 가져오는 메서드
  String? getUserInfoFromJWT(String? jwtDecode) {
    List<String> jwtList = jwtDecode?.split('.') ?? [];
    String payLoad = jwtList[1];
    payLoad = base64.normalize(payLoad);

    final List<int> jsonData = base64.decode(payLoad);
    final userInfo = jsonDecode(utf8.decode(jsonData));
    print('userinfo: $userInfo');


    bool isVerified = userInfo['email_verified'] == "true";
    if (isVerified) {
      return userInfo['email'];
    }

    return null;
  }
}
