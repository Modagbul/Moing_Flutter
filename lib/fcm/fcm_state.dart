import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

class FCMState extends ChangeNotifier {
  // 네비게이션 이력 및 네비게이션 키 등의 상태 관리
  NavigationHistoryObserver navigationHistory;
  GlobalKey<NavigatorState> navigatorKey;

  // Firebase Messaging 및 로컬 푸시 알림 플러그인 초기화
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

  // 로컬 알림 수신 및 알림 선택 스트림 관리
  final StreamController<ReceivedNotification>
      didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();
  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  String? selectedNotificationPayload;
  StreamSubscription<String>? _tokenSubscription;

  // Android 로컬 푸시 채널 알림 설정 값
  final androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    '중요도 높은 알림',
    importance: Importance.max,
  );

  /// FCMState 인스턴스 생성 및 초기화
  FCMState({
    required this.navigationHistory,
    required this.navigatorKey,
  }) {
    log('Instance "FCMState" has been created');
    // Local Notification
    _initializeLocalNotification();
    // Listen Messages
    _initializeListenMessage();
  }

  @override
  void dispose() {
    log('Instance "FCMState" has been removed');
    _tokenSubscription?.cancel();
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    super.dispose();
  }

  /// 푸시 알림 권한 요청 메소드
  requestPermission() async {
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('Notification Permission Granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('Notification Permission Provisional');
    } else {
      log('User declined or has not accepted permission');
    }
  }

  /// 토큰 업데이트 메소드
  Future<String?> updateToken() async {
    String? token = await messaging.getToken();
    if (token == null) return null;
    return token;
  }

  /// 로컬 푸시 알림 초기화
  void _initializeLocalNotification() async {
    // Android 초시 세팅
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    // IOS 알림 카테고리
    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    // iOS foreground notification 권한
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // IOS background 권한 체킹 , 요청
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // IOS 초기 세팅
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
      notificationCategories: darwinNotificationCategories,
    );

    // 알림 초기화
    await localNotification.initialize(
      InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      ),
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
    );

    // Android Notification Channel 생성
    await localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
    // _configureSelectNotificationSubject();
  }

  /// FCM 알림 수신 이벤트 초기화: 성공 -> onMessage
  void _initializeListenMessage() async {
    // Foreground
    FirebaseMessaging.onMessage
        .listen((RemoteMessage message) => _onMessage(message, false));
    // Background, Terminated -> Foreground
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _onMessage(m, true));

    final message = await messaging.getInitialMessage();
    if (message != null) _onMessage(message, true);
  }

  /// FCM 알림 메세지 처리 메소드
  void _onMessage(RemoteMessage message, bool openedApp) async {
    log('On Remote Message - Notification: ${message.notification}');
    log('On Remote Message - Data: ${message.data}');
    log('On Remote Message - OpenedApp: $openedApp');

    log('${message.notification?.title ?? 'titleNull'} ${message.notification?.body ?? 'bodyNull'}');

    final data = message.data;
    if (data['title'] == null && data['body'] == null) return;

    final title = data['title'];
    final body = data['body'];

    // 랜딩 데이터 및 앱이 열려 있음
    if (message.data.containsKey('landing') && openedApp == false) {
      log('1');
      final landing = message.data['landing'] as String;

      final topRouteName = navigationHistory.top?.settings.name;
      final topRouteArguments = navigationHistory.top?.settings.arguments;

      // 랜딩 데이터 확인
      // if (landing.startsWith('/chat-rooms')) {
      //   final receiveChatRoomId = landing.replaceAll('/chat-rooms/', '');
      //   if (topRouteName == '/chats/room' && topRouteArguments is ChatsRoomArgument) {
      //     final originalChatRoomId = topRouteArguments.chatsRoomWithInfo.chatsRoom.id;
      //
      //     if (receiveChatRoomId == originalChatRoomId) return;
      //   }
      // } else if (landing.startsWith('/counselors')) {
      //   final receiveCounselorId = landing.replaceAll('/counselors/', '');
      //
      //   if (topRouteName == '/counselor/detail' && topRouteArguments is CounselorDetailArgument) {
      //     final originalCounselorId = topRouteArguments.counselorId;
      //
      //     if (receiveCounselorId == originalCounselorId) return;
      //   }
      // }

      await _showNotification(
        id: message.hashCode,
        title: title,
        body: body,
        smallIcon: message.notification?.android?.smallIcon,
        payload: data['landing'],
      );
    }
    // 앱이 열려 있음
    else if (openedApp == false) {
      log('2');
      await _showNotification(
        id: message.hashCode,
        title: title,
        body: body,
        smallIcon: message.notification?.android?.smallIcon,
        payload: data['landing'],
      );
    }
    // 앱이 닫혀 있음
    else if (openedApp == true) {
      log('3');
      // 랜딩 처리
      final landing = message.data['landing'] as String;

      final topRouteName = navigationHistory.top?.settings.name;
      final topRouteArguments = navigationHistory.top?.settings.arguments;

      log('landing 값 : ${landing.toString()}');

      // // 랜딩 데이터 확인
      // if (landing.startsWith('/chat-rooms')) {
      //   final receiveChatRoomId = landing.replaceAll('/chat-rooms/', '');
      //   final isSameChatRoom = topRouteName == '/chats/room' && topRouteArguments is ChatsRoomArgument && topRouteArguments.chatsRoomWithInfo.chatsRoom.id == receiveChatRoomId;
      //
      //   // Push Chat Room
      //   // if (isSameChatRoom == false) {
      //   //   _openChatRoom(receiveChatRoomId);
      //   // }
      // } else if (landing.startsWith('/counselors')) {
      //   final receiveCounselorId = landing.replaceAll('/counselors/', '');
      //   final isSameCounselor = topRouteName == '/counselor/detail' && topRouteArguments is CounselorDetailArgument && topRouteArguments.counselorId == receiveCounselorId;
      //
      //   // Push Chat Room
      //   // if (isSameCounselor == false) {
      //   //   _openCounselorDetail(receiveCounselorId);
      //   // }
      // }
    }
  }

  // _openChatRoom(String id) async {
  //   try {
  //     EasyLoading.show();
  //
  //     final ChatsRealtimeRepository chatsRealtimeRepository = ChatsRealtimeRepository();
  //     final UserRepository userRepository = UserRepository();
  //     final ChatsRoom chatsRoom = await chatsRealtimeRepository.getChatsRoom(chatsRoomId: id);
  //     final User user = await userRepository.getUserInfo(userId: chatsRoom.userId) ?? userRepository.getUnknownUser(userId: chatsRoom.userId);
  //     final User counselor = await userRepository.getUserInfo(userId: chatsRoom.counselorId) ?? userRepository.getUnknownCounselor(counselorId: chatsRoom.counselorId);
  //
  //     navigatorKey.currentState?.pushNamedAndRemoveUntil(
  //       ChatsRoomPage.routeName,
  //       ModalRoute.withName(MainPage.routeName),
  //       arguments: ChatsRoomArgument(
  //         chatsRoomWithInfo: ChatsRoomWithInfo(
  //               (e) => e
  //             ..chatsRoom = chatsRoom.toBuilder()
  //             ..user = user.toBuilder()
  //             ..counselor = counselor.toBuilder(),
  //         ),
  //       ),
  //     );
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }

  // _openCounselorDetail(String id) async {
  //   try {
  //     EasyLoading.show();
  //
  //     navigatorKey.currentState?.pushNamedAndRemoveUntil(
  //       CounselorDetailPage.routeName,
  //       ModalRoute.withName(MainPage.routeName),
  //       arguments: CounselorDetailArgument(counselorId: id),
  //     );
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }

  /// 메세지를 보여줌
  _showNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
    String? smallIcon,
  }) async {
    log('11');
    await localNotification.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannel.id,
          androidChannel.name,
          icon: smallIcon,
        ),
      ),
      payload: payload,
    );
  }

  // void _configureSelectNotificationSubject() {
  //   selectNotificationStream.stream.listen((String? payload) async {
  //     if (payload != null && payload.startsWith('/chat-rooms/')) {
  //       final chatRoomId = payload.replaceAll('/chat-rooms/', '');
  //       await _openChatRoom(chatRoomId);
  //     }
  //     if (payload != null && payload.startsWith('/counselors/')) {
  //       final counselorId = payload.replaceAll('/counselors/', '');
  //       await _openCounselorDetail(counselorId);
  //     }
  //   });
  // }
}
