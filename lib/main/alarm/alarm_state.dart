import 'package:flutter/material.dart';
import 'package:moing_flutter/main/alarm/alarm_list.dart';

class AlarmState extends ChangeNotifier {
  final BuildContext context;
  List<Alarm> alarmList = List.empty(growable: true);

  AlarmState({required this.context}) {
    print('Instance "AlarmState" has been created');
    initState();
  }

  void initState() {
    alarmList.add(Alarm(team: '모닥모닥불', title: '어라...왜 이렇게 발등이 뜨겁지?🤨', content: '으냥님이 챙굴님에게 불을 던졌어요!', imagePath: 'asset/image/fire_black.png', time: '06:39'));
    alarmList.add(Alarm(team: '북시즘', title: '[오늘마감] 데미안 읽기', content: '친구들이 으냥님의 인증을 기다려요!', imagePath: 'asset/image/notification_black.png', time: '06:39'));
    alarmList.add(Alarm(team: '북시즘', title: '으냥님, [북시즘] 미션을 잊으신 건 아니겠죠?', content: '마감 D-1! 서둘러 인증해봐요 💨', imagePath: 'asset/image/notification_black.png', time: '06:39'));
    alarmList.add(Alarm(team: '모닥모닥불', title: '모임의 새로운 공지 알려드려요!', content: '2023년 8월 정기 모임 장소 공지', imagePath: 'asset/image/notification_black.png', time: '06:39'));
    alarmList.add(Alarm(team: '북시즘', title: 'HOT 모임! 아 HOT HOT 모임!', content: '축하해요! [북시즘] 모임의 모잉불이 LV.8로 성장했어요.', imagePath: 'asset/image/notification_black.png', time: '06:39'));
    alarmList.add(Alarm(team: '북시즘', title: 'HOT 모임! 아 HOT HOT 모임!', content: '축하해요! [북시즘] 모임의 모잉불이 LV.8로 성장했어요.', imagePath: 'asset/image/notification_black.png', time: '06:39'));
    alarmList.add(Alarm(team: '북시즘', title: 'HOT 모임! 아 HOT HOT 모임!', content: '축하해요! [북시즘] 모임의 모잉불이 LV.8로 성장했어요.', imagePath: 'asset/image/notification_black.png', time: '06:39'));
  }
}