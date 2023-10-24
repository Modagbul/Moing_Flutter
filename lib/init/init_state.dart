import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moing_flutter/fix_group/fix_group_page.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_first.dart';
import 'package:moing_flutter/login/sign_in/login_page.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/missions/create/missions_create_page.dart';
import 'package:moing_flutter/utils/api/refresh_token.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';

class InitState extends ChangeNotifier {
  BuildContext context;
  final SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
  final TokenManagement tokenManagement = TokenManagement();

  InitState({required this.context}) {
    print('Instance "InitState" has been created');
    initStart();
    // asyncInitState();
  }

  @override
  void dispose() {
    print('Instance "InitState" has been removed');
    super.dispose();
  }

  /// 테스트 용도로 처음에는 무조건 로그인 페이지로 이동하도록 함
  void initStart() async {
    await Future.delayed(
      const Duration(
        seconds: 1,
        milliseconds: 0,
      ),
    );

    // Navigator.pushNamedAndRemoveUntil(context, MissionsCreatePage.routeName, (route) => false);

    String? oldUser = await sharedPreferencesInfo.loadPreferencesData('old');

    //이전에 가입한 적 있는 유저
    // if (oldUser == 'true') {
    //   String? accessToken = await tokenManagement.loadAccessToken();
    //   if (accessToken != null) {
    //     Navigator.pushNamedAndRemoveUntil(
    //         context, MainPage.routeName, (route) => false);
    //   } else {
    //     Navigator.pushNamedAndRemoveUntil(
    //         context, LoginPage.routeName, (route) => false);
    //   }
    // } else {
    //   Navigator.pushNamedAndRemoveUntil(
    //       context, OnBoardingFirstPage.routeName, (route) => false);
    // }

    oldUser == 'true'
    ? Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, (route) => false)
    : Navigator.pushNamedAndRemoveUntil(context, OnBoardingFirstPage.routeName, (route) => false);
  }

  /// 유저의 메인 화면으로 갈 수 있는지 여부 등 확인
  asyncInitState() async {
    // _authStateStream = FirebaseAuth.instance.userChanges().listen((user) {
    //   _handleUserChange(user);
    // });
  }

// _handleUserChange(User? user) async {
//   try {
//     EasyLoading.show();
//
//     await Future.delayed(Duration(seconds: 1, milliseconds: 500));
//
//     await _checkUpdate();
//     String? userId = user?.uid;
//
//     if (userId == null) {
//       userId = FirebaseAuth.instance.currentUser?.uid;
//     }
//
//     if (isUpdated || kDebugMode) {
//       await _goNextPage(userId);
//       return;
//     }
//
//     // 앱이 최신 버전이 아니면 업데이트 안내를 함.
//     // 안드로이드 사용자는 플레이 스토어 링크 연결
//     // IOS 사용자는 앱스토어 링크 연결
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('업데이트 알림'),
//             content: Text(alertText),
//             actions: [
//               TextButton(
//                 onPressed: () async {
//                   if (Platform.isAndroid) {
//                     final url = 'https://play.google.com/store/apps/details?id=kr.co.soultalk.app';
//                     if (await canLaunch(url))
//                       await launch(
//                         url,
//                         statusBarBrightness: Brightness.light,
//                       );
//                   }
//                   if (Platform.isIOS) {
//                     final url = 'https://apps.apple.com/kr/app/%EC%86%8C%EC%9A%B8%ED%86%A1-1-1-%EC%B1%84%ED%8C%85-%ED%86%B5%ED%99%94-%ED%83%80%EB%A1%9C-%EC%83%81%EB%8B%B4/id6444065022';
//                     if (await canLaunch(url))
//                       await launch(
//                         url,
//                         statusBarBrightness: Brightness.light,
//                       );
//                   }
//                 },
//                 child: Text('업데이트'),
//               ),
//               if (!isNecessary)
//                 TextButton(
//                   onPressed: () async {
//                     await _goNextPage(userId);
//                   },
//                   child: Text('건너뛰기'),
//                 )
//             ],
//           );
//         }
//     );
//   } catch (e) {
//     print("Error: Init Page - _handleUserChange: " + e.toString());
//     /// 변경 적용
//     Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => false);
//   }
//   finally {
//     EasyLoading.dismiss();
//   }
// }

// Future<void> _checkUpdate() async {
//   // 업데이트 필요한 버전인지 앱 버전 체크
//   PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   int appVersion = 0;
//   final settingDocuments = await FirebaseFirestore.instance
//       .collection('settings')
//       .where('name', isEqualTo: 'appVersion')
//       .get();
//   final settingDocument = settingDocuments.docs[0];
//   final settingData = settingDocument.data();
//   if (settingDocument.exists) {
//     appVersion = settingData["value"] ?? 0;
//     isNecessary = settingData["isNecessary"] ?? false;
//     alertText = settingData["text"] ?? "앗, 소울톡 최신 버전이 아니에요! 1:1 상담을 원하신다면 앱을 업데이트해 주세요!";
//   }
//
//   isUpdated = appVersion <= int.parse(Platform.isAndroid ? packageInfo.buildNumber.substring(1) : packageInfo.buildNumber);
// }
}
