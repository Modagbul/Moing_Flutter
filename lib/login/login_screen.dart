import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:moing_flutter/login/login_platform.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginPlatform _loginPlatform = LoginPlatform.none;


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

      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

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

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '모잉 개발 드가자,,,',
              style: TextStyle(
                fontSize: 32.0,
              ),
            ),
            ElevatedButton(
                onPressed: signInWithApple,
                child: Text('애플 로그인하기'),
            ),
            SignInWithAppleButton(
                onPressed: signApple13,
            ),
          ],
          child: _loginPlatform != LoginPlatform.none
              ? _logoutButton()
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _loginButton(
                'kakao_logo',
                signInWithKakao,
              )
            ],
          )),
    );
  }

  Widget _loginButton(String path, VoidCallback onTap) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage('asset/image/kakao_login_logo.png'),
        width: 300,
        height: 45,
        child: InkWell(
          onTap: onTap,
        ),
      ),
    );
  }

  /// IOS 13 버전 앱 로그인
  Future<UserCredential> signInWithApple() async {
    /// IOS 13 버전 이상인지 확인
    bool isAvailable = await SignInWithApple.isAvailable();

    /// IOS 13 버전 이상인 경우
    if(isAvailable) {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
            clientId: 'moing-team.moing.com',
            redirectUri: Uri.parse('https://moing-ver2.firebaseapp.com/__/auth/handler'),
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

  // 이메일 가져오는 메서드
  String? getUserInfoFromJWT(String? jwtDecode) {
    List<String> jwtList = jwtDecode?.split('.') ?? [];
    String payLoad = jwtList[1];
    payLoad = base64.normalize(payLoad);

    final List<int> jsonData = base64.decode(payLoad);
    final userInfo = jsonDecode(utf8.decode(jsonData));
    print('userinfo: $userInfo');


    bool isVerified = userInfo['email_verified'] == "true";
    if(isVerified) {
      return userInfo['email'];
    }

    return null;
  }

  /// IOS 13버전 이상 로그인 테스트
  Future<void> signApple13() async {
    final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
    );
    print('credential: $credential');
    print(credential.email);
    print(credential.identityToken);
    print('${credential.givenName} ${credential.familyName}');
  }
}

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff0165E1),
        ),
      ),
      child: const Text('로그아웃'),
    );
  }
}

