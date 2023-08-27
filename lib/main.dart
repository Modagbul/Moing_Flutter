import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moing_flutter/app/app.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDefault();
  
  KakaoSdk.init(nativeAppKey: '6671c3a9b377c8f302c17c14e2c940f2');

  // Global Keys
  GetIt.I.registerSingleton(NavigationHistoryObserver());
  GetIt.I.registerSingleton(GlobalKey<NavigatorState>());

  /// 기존 언어를 한국어로 설정
  timeago.setLocaleMessages('ko', timeago.KoMessages());
  timeago.setDefaultLocale('ko');

  runApp(MoingApp());
}

Future<void> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp();
  print('Initialized default app $app');
}