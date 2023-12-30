import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;
import 'package:moing_flutter/fcm/fcm_state.dart';
import 'package:moing_flutter/login/sign_up/sign_up_page.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/utils/api/refresh_token.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState extends ChangeNotifier {
  /// Login Page에서 사용하는 context를 가져옴.
  final BuildContext context;

  bool? _isRegistered;
  TokenManagement tokenManagement = TokenManagement();
  SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();

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

      // print(token);
      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      // print(profileInfo.toString());

      // 카카오 로그인 후 백엔드에 토큰 전송
      await sendKakaoTokenToBackend(token.accessToken);

    } catch (error) {
      // showErrorDialog(error.toString());
      print('카카오톡으로 로그인 실패 $error');
    } finally {
      onLoading = false;
    }
  }

  void showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          error,
          style: TextStyle(fontSize: 14, color: Colors.indigo),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// 카카오 토큰을 백엔드에 전송하는 함수
  Future<void> sendKakaoTokenToBackend(String token) async {
    try {
      String? fcmToken = await getFCMToken();
      if(fcmToken == null) {
        return ;
      }

      String deviceType = (Platform.isAndroid ? 'ANDROID' : 'APPLE');

      final String apiUrl = '${dotenv.env['MOING_API']}/api/auth/signIn/kakao';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8', // 요청 헤더 설정
        },
        body: jsonEncode(<String, String>{
          'socialToken': token,
          'fcmToken': fcmToken,
          'deviceType': deviceType,
        }),
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if(responseBody['isSuccess'] == true) {
        final String accessToken = responseBody['data']['accessToken'];
        final String refreshToken = responseBody['data']['refreshToken'];

        // sharedPreferences를 이용하여 accessToken, refreshToken 저장
        await tokenManagement.saveToken(accessToken, refreshToken);
        print('카카오JWT : $accessToken');
        _isRegistered = responseBody['data']['registrationStatus'];
        sharedPreferencesInfo.savePreferencesData('sign', 'kakao');
        checkRegister(_isRegistered!);
      }
      /// 에러 처리
      else {
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

  Future<String?> getFCMToken() async {
    String? fcmToken;

    await Future.microtask(() async {
      final fcmState = context.read<FCMState>();

      await fcmState.requestPermission();
      fcmToken = await fcmState.updateToken();
      print('update fcm Token : $fcmToken');
    });

    return fcmToken;
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
        await appleLoginSendToken(appleCredential.identityToken!);
      } catch (e) {
        // showErrorDialog(e.toString());
        print('애플 로그인 실패 : ${e.toString()}');
      } finally {
        onLoading = false;
      }
    }

    /// IOS 13 버전이 아닌 경우
    else {
      // showErrorDialog('Sign in With Apple is not available on this device.');
      throw PlatformException(
        code: 'APPLE_SIGN_IN_NOT_AVAILABLE',
        message: 'Sign in With Apple is not available on this device.',
      );
    }
  }

  /// 애플 소셜 로그인 요청 API
  Future<void> appleLoginSendToken(String token) async {
    try {
      String? fcmToken = await getFCMToken();
      if(fcmToken == null) {
        return ;
      }

      final String apiUrl = '${dotenv.env['MOING_API']}/api/auth/signIn/apple';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8', // 요청 헤더 설정
        },
        body: jsonEncode(<String, String>{
          'socialToken': token,
          'fcmToken': fcmToken,
        }),
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if(responseBody['isSuccess'] == true) {
        final String accessToken = responseBody['data']['accessToken'];
        final String refreshToken = responseBody['data']['refreshToken'];
        print('애플JWT : $accessToken');
        // sharedPreferences를 이용하여 accessToken, refreshToken 저장
        await tokenManagement.saveToken(accessToken, refreshToken);

        _isRegistered = responseBody['data']['registrationStatus'];
        checkRegister(_isRegistered!);
        sharedPreferencesInfo.savePreferencesData('sign', 'apple');
      }
      /// 에러 처리
      else {
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

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      // Firebase 사용자 인증
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        ),
      );

      // print("Google ID Token: ${googleAuth?.idToken}");

      // 구글 토큰을 백엔드 서버로 전송
      if (googleAuth?.idToken != null) {
        await sendGoogleTokenToBackend(googleAuth!.idToken!);
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
      // 오류 처리
    }
  }

  Future<void> sendGoogleTokenToBackend(String token) async {
    try {
      String? fcmToken = await getFCMToken();
      if (fcmToken == null) {
        return;
      }

      final String apiUrl = '${dotenv.env['MOING_API']}/api/auth/signIn/google';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode({
          'socialToken': token,
          'fcmToken': fcmToken,
        }),
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if(responseBody['isSuccess'] == true) {
        final String accessToken = responseBody['data']['accessToken'];
        final String refreshToken = responseBody['data']['refreshToken'];

        // print('Access Token: $accessToken');
        // print('Refresh Token: $refreshToken');

        await tokenManagement.saveToken(accessToken, refreshToken);
        // print('구글 JWT : $accessToken');
        _isRegistered = responseBody['data']['registrationStatus'];
        sharedPreferencesInfo.savePreferencesData('sign', 'google');
        checkRegister(_isRegistered!);
      }
      /// 에러 처리
      else {
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
      print('Error sending Google token to backend : ${e.toString()}');
    }
  }


  /// 회원가입 여부 판단
  void checkRegister(bool isRegistered) {
    // 가입되어 있는 경우
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
