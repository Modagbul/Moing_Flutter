import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class MissionFireState extends ChangeNotifier {
  final BuildContext context;
  String selectedUserName = '모임원 프로필을 클릭해보세요';
  int? selectedIndex;

  List<String> userNameList = [
    '뮹뮹',
    '일이삼사오육칠팔구십',
    '채채채리',
    '현석쿤',
    '여비',
    '으냥',
    '모닥부리부리',
    '열정열정',
    '근육맨',
  ];

  MissionFireState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "MissionFireState" has been created');
  }

  // 선택 적용
  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  // 불 던지기 버튼 클릭
  void firePressed() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(); // 2초 후에 다이얼로그를 닫습니다.
        });

        return Dialog(
          backgroundColor: Colors.transparent, // 다이얼로그의 배경색을 투명하게 설정
          child: ClipRRect(
            // ClipRRect를 사용하여 borderRadius를 적용
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: double.infinity,
              height: 277,
              decoration: BoxDecoration(
                color: grayScaleGrey600,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 42),
                  Text(
                    '발등에 불 떨어트리는 중..',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: grayScaleGrey100,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'asset/image/icon_fire_notification.png',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
