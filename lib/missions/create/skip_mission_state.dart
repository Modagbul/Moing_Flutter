import 'dart:developer';

import 'package:flutter/material.dart';

import '../../const/color/colors.dart';

class SkipMissionState extends ChangeNotifier {
  final BuildContext context;
  final int teamId;
  final int missionId;

  String? selectedCategory;
  bool isSelected = false;

  final TextEditingController textController = TextEditingController();

  SkipMissionState({
    required this.context,
    required this.teamId,
    required this.missionId,
  }) {
    initState();
  }

  void initState() {
    log('Instance "SkipMissionState" has been created');
  }

  @override
  void dispose() {
    textController.dispose();
    log('Instance "SkipMissionState" has been removed');
    super.dispose();
  }

  // 텍스트 필드 초기화 메소드
  void clearTextField() {
    textController.clear();
    notifyListeners();
  }

  // 텍스트 필드 변경 감지 메소드
  void updateTextField() {
    isSelected = textController.text.isNotEmpty; // 텍스트 필드의 내용이 있으면 isSelected를 true로 설정
    notifyListeners();
  }

  bool isCategorySelected() {
    return isSelected; // selectedCategory의 값과 상관없이 isSelected가 true이면 true 반환
  }

  Color getNextButtonColor() {
    return isCategorySelected() ? grayScaleWhite : grayScaleGrey700;
  }

  Color getNextButtonTextColor() {
    return isCategorySelected() ? grayScaleGrey700 : grayScaleGrey500;
  }

// 사진 업로드 화면으로 이동
// void nextPressed() {
//   Navigator.pushNamed(context, GroupCreatePhotoPage.routeName, arguments: {
//     'category': category,
//     'name': nameController.text,
//     'introduce': introduceController.text,
//     'promise': resolutionController.text,
//   });
// }
}
