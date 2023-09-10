import 'dart:developer';

import 'package:flutter/material.dart';

class MeetingCreateInfoState extends ChangeNotifier {
  final BuildContext context;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController introduceController = TextEditingController();
  final TextEditingController resolutionController = TextEditingController();

  MeetingCreateInfoState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "MeetingCreateInfoState" has been created');
  }

  @override
  void dispose() {
    nameController.dispose();
    log('Instance "MeetingCreateInfoState" has been removed');
    super.dispose();
  }

  // 텍스트 필드 초기화 메소드
  void clearNameTextField() {
    nameController.clear();
    notifyListeners();
  }

  // 텍스트 필드 초기화 메소드
  void clearIntroduceTextField() {
    introduceController.clear();
    notifyListeners();
  }

  // 텍스트 필드 초기화 메소드
  void clearResolutionTextField() {
    resolutionController.clear();
    notifyListeners();
  }

  // 텍스트 필드 변경 감지 메소드
  void updateTextField() {
    notifyListeners();
  }

}
