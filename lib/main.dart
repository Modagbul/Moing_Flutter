import 'dart:developer';
import 'dart:io';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:moing_flutter/app/app.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:moing_flutter/config/amplitude_config.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDefault();
  /// 화면 세로로 고정
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  HttpOverrides.global = MyHttpOverrides();
  /// Amplitude 세팅
  AmplitudeConfig().init();
  /// Amplitude 세션 자동 추적
  Amplitude.getInstance().trackingSessionEvents(true);
  runApp(const MoingApp());
}

Future<void> initializeDefault() async {
  await Future.delayed(Duration(milliseconds: 500));
  /// env 파일 업로드
  await dotenv.load(fileName: 'asset/config/.env');
  /// kakao init
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']);

  /// FCM 알람 설정 초기화
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Global Keys
  GetIt.I.registerSingleton(NavigationHistoryObserver());
  GetIt.I.registerSingleton(GlobalKey<NavigatorState>());

  /// 기존 언어를 한국어로 설정
  timeago.setLocaleMessages('ko', timeago.KoMessages());
  timeago.setDefaultLocale('ko');

  /// fcm device token값 출력
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  log('fcmToken : $fcmToken');
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  log("Handling a background message: ${message.messageId}");
  log('백그라운드 메세지 : ${message.notification!.body}');

  if (message.data['title'] == null && message.data['body'] == null) return;

  final FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();
  const androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    '중요도 높은 알림',
    importance: Importance.max,
  );

  await localNotification.show(
    message.hashCode,
    message.data['title'],
    message.data['body'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        androidChannel.id,
        androidChannel.name,
        icon: message.notification?.android?.smallIcon,
      ),
    ),
    payload: message.data['landing'],
  );
}


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..userAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36';
  }
}