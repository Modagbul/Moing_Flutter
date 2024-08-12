import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moing_flutter/config/amplitude_config.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/mission_prove/component/mission_prove_argument.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
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
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  // API 통신
  final APICall apiCall = APICall();
  final ApiCode apiCode = ApiCode();
  final FToast fToast = FToast();
  String apiUrl = '';

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
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
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

  void navigatePostDetailPage({required Map<String, dynamic> data}) {
    final idInfo = _decodeIdInfo(data['idInfo']);
    if (idInfo == null) return;

    _pushNamedWithArguments(data['path'], idInfo);
  }

  void validateNewUploadPost({required Map<String, dynamic> data}) async {
    final idInfo = _decodeIdInfo(data['idInfo']);
    if (idInfo == null) return;

    final result = await apiCode.getDetailPostData(
        teamId: idInfo['teamId'], boardId: idInfo['boardId']);

    if (result == null) {
      showWarningToast(warningText: '존재하지 않는 게시글이에요');
      return;
    }

    navigatePostDetailPage(data: data);
  }

  void navigateMissionsProvePage({required Map<String, dynamic> data}) async {
    final idInfo = _decodeIdInfo(data['idInfo']);
    if (idInfo == null) return;

    bool? isEnded;
    String? status;

    if (idInfo['teamId'] != null && idInfo['missionId'] != null) {
      final missionEndStatus = await getMissionEndStatus(
          teamId: idInfo['teamId'], missionId: idInfo['missionId']);
      if (missionEndStatus != null) {
        isEnded = missionEndStatus['end'];
        status = missionEndStatus['status'];
      }
    }

    MissionProveArgument missionProveArgument = MissionProveArgument(
      isRepeated: idInfo['isRepeated'] ?? false,
      teamId: idInfo['teamId'] ?? 0,
      missionId: idInfo['missionId'] ?? 0,
      status: status ?? idInfo['status'] ?? '',
      isEnded: isEnded ?? false,
      isRead: true,
    );

    navigatorKey.currentState
        ?.pushNamed(data['path'], arguments: missionProveArgument);
  }

  void navigateMissionsScreen({required Map<String, dynamic> data}) {
    navigatorKey.currentState?.pushNamed(data['path'],
        arguments: {'result': true, 'screenIndex': 1});
  }

  void navigateHomeScreen({required Map<String, dynamic> data}) {
    navigatorKey.currentState?.pushNamed(data['path'],
        arguments: {'result': true, 'screenIndex': 0});
  }

  /// teamId, missionId 통해 해당 미션의 종료 여부, status 값 받기
  Future<Map<String, dynamic>?> getMissionEndStatus(
      {required int teamId, required int missionId}) async {
    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive/mission-status';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await apiCall.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (json) => {
          'end': json['end'] as bool,
          'status': json['status'] as String,
        },
      );

      if (apiResponse.isSuccess == true) {
        log('미션 상태 조회 성공');
        return apiResponse.data;
      } else {
        log('getMissionEndStatus is Null, error code : ${apiResponse.errorCode}');
        if (apiResponse.errorCode == 'T0001') {
          showWarningToast(warningText: '존재하지 않는 소모임이에요');
        } else {
          showWarningToast(warningText: '존재하지 않는 미션이에요');
        }
      }
    } catch (e) {
      log('미션 상태 조회 실패: $e');
    }
    return null;
  }

  void showWarningToast({required String warningText}) {
    fToast.showToast(
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'asset/icons/toast_danger.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    Text(
                      warningText,
                      style: const TextStyle(
                        color: grayScaleGrey700,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )),
        ),
        toastDuration: const Duration(milliseconds: 3000),
        positionedToastBuilder: (context, child) {
          return Positioned(
            top: 100.0,
            left: 0.0,
            right: 0,
            child: child,
          );
        });
  }

  Map<String, dynamic>? _decodeIdInfo(String? idInfoString) {
    if (idInfoString == null) return null;

    try {
      return json.decode(idInfoString);
    } catch (e) {
      log('Error decoding idInfoString: $e');
      return null;
    }
  }

  void _pushNamedWithArguments(String? path, Map<String, dynamic>? arguments) {
    if (path == null || arguments == null) return;
    navigatorKey.currentState?.pushNamed(path, arguments: arguments);
  }

  /// FCM 알림 메세지 처리 메소드
  void _onMessage(RemoteMessage message, bool openedApp) async {
    log('On Remote Message - Notification: ${message.notification}');
    log('On Remote Message - Data: ${message.data}');
    log('On Remote Message - OpenedApp: $openedApp');

    log('${message.notification?.title ?? 'titleNull'} ${message.notification?.body ?? 'bodyNull'}');

    final data = message.data;

    if (data['path'] == null) return;

    final idInfo = _decodeIdInfo(data['idInfo']);
    String? typeValue = idInfo?['type'];
    if (typeValue == null) return;


    if (openedApp == true) {
      switch (data['path']) {
        case '/post/detail':
          if (typeValue == 'COMMENT_BOARD') {
            AmplitudeConfig.analytics.logEvent("push_click_posting_comment");
          } else if (typeValue == 'NEW_UPLOAD_BOARD') {
            AmplitudeConfig.analytics.logEvent("push_click_announcement");
          }
          navigatePostDetailPage(data: data);
          break;
        case '/missions/prove':
          if (typeValue == 'NEW_UPLOAD_MISSION') {
            AmplitudeConfig.analytics.logEvent("push_click_mission_make");
          } else if (typeValue == 'FIRE_MESSAGE_EXIST') {
            AmplitudeConfig.analytics.logEvent("push_click_dropfire_message");
          } else if (typeValue == 'FIRE_MESSAGE_NULL') {
            AmplitudeConfig.analytics.logEvent("push_click_dropfire_nomessage");
          } else if (typeValue == 'COMMENT_MISSION') {
            AmplitudeConfig.analytics.logEvent("push_click_misson_comment");
          } else if (typeValue == 'COMPLETE_MISSION') {
            AmplitudeConfig.analytics
                .logEvent("push_click_misson_new_complete");
          }
          navigateMissionsProvePage(data: data);
          break;
        case '/missions': // (한번/반복) 미션 리마인드 알림
          navigateMissionsScreen(data: data);
          break;
        case '/home': // 소모임 생성 (승인/반려) 알림
          navigateHomeScreen(data: data);
          break;
        default:
          throw ArgumentError('Invalid path: ${data['path']}');
      }
    }
  }
}
