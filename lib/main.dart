import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:moing_flutter/app/app.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDefault();

  /// env 파일 업로드
  await dotenv.load(fileName: 'asset/config/.env');

  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']);

  // Global Keys
  GetIt.I.registerSingleton(NavigationHistoryObserver());
  GetIt.I.registerSingleton(GlobalKey<NavigatorState>());

  /// 기존 언어를 한국어로 설정
  timeago.setLocaleMessages('ko', timeago.KoMessages());
  timeago.setDefaultLocale('ko');


  // key 값 가져오기
  // 방법 1. String nativeAppKey = dotenv.get('KAKAO_NATIVE_APP_KEY');
  // 방법 2. String nativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'];

  runApp(MoingApp());
  // runApp(
  //   MaterialApp(
  //     home: TestScreen(),
  //   )
  // );
}

Future<void> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp();
  print('Initialized default app $app');
}