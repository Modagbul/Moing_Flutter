import 'dart:developer';

import 'package:flutter/material.dart';

class ProfileSettingState extends ChangeNotifier {
  final BuildContext context;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController resolutionController = TextEditingController();

  ProfileSettingState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "ProfileSettingState" has been created');
  }

  @override
  void dispose() {
    log('Instance "ProfileSettingState" has been removed');
    super.dispose();
  }

  // 텍스트 필드 초기화 메소드
  void clearNameTextField() {
    nameController.clear();
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
