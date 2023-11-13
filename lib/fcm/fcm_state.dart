import 'dart:async';

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
  NavigationHistoryObserver navigationHistory;
  GlobalKey<NavigatorState> navigatorKey;

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin localNotification = FlutterLocalNotificationsPlugin();
  final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
  StreamController<ReceivedNotification>.broadcast();

  final StreamController<String?> selectNotificationStream =
  StreamController<String?>.broadcast();

  String? selectedNotificationPayload;

  StreamSubscription<String>? _tokenSubscription;

  // Local Push Android Channel
  final androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    '중요도 높은 알림',
    importance: Importance.max,
  );

  FCMState({
    required this.navigationHistory,
    required this.navigatorKey,
  }) {
    print('Instance "FCMState" has been created');
    // Local Notification
    this._initializeLocalNotification();

    // Listen Messages
    this._initializeListenMessage();
  }

  requestPermission() async {
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notification Permission Granted');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('Notification Permission Provisional');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<String?> updateToken() async {
    String? token = await messaging.getToken();
    if(token == null) return null;
    return token;
  }

  @override
  void dispose() {
    print('Instance "FCMState" has been removed');
    _tokenSubscription?.cancel();
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();

    super.dispose();
  }

  void _initializeLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

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

    final DarwinInitializationSettings initializationSettingsDarwin =DarwinInitializationSettings(
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

    // Initialize
    await localNotification.initialize(
      InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      ),

      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
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
    await localNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidChannel);
    // _configureSelectNotificationSubject();
  }

  void _initializeListenMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) => _onMessage(message, false));
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _onMessage(m, true));

    final message = await this.messaging.getInitialMessage();
    if (message != null) _onMessage(message, true);
  }

  void _onMessage(RemoteMessage message, bool openedApp) async {

    print('On Remote Message - Notification: ' + message.notification.toString());
    print('On Remote Message - Data: ' + message.data.toString());
    print('On Remote Message - OpenedApp: ' + openedApp.toString());

    final data = message.data;
    if (data['title'] == null && data['body'] == null) return;

    final title = data['title'];
    final body = data['body'];

    if (message.data.containsKey('landing') && openedApp == false) {
      print(1);
      // 랜딩 데이터 및 앱이 열려 있음
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
    } else if (openedApp == false) {
      print(2);
      // 앱이 열려있음
      await _showNotification(
        id: message.hashCode,
        title: title,
        body: body,
        smallIcon: message.notification?.android?.smallIcon,
        payload: data['landing'],
      );
    } else if (openedApp == true) {
      print(3);
      // 랜딩 처리
      final landing = message.data['landing'] as String;

      final topRouteName = navigationHistory.top?.settings.name;
      final topRouteArguments = navigationHistory.top?.settings.arguments;

      print('landing 값 : ${landing.toString()}');

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
    print(4);
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

  _showNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
    String? smallIcon,
  }) async {
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

