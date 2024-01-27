import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/make_group/group_create_photo_page.dart';

import '../const/color/colors.dart';

class GroupCreateInfoState extends ChangeNotifier {
  final BuildContext context;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController introduceController = TextEditingController();
  final TextEditingController resolutionController = TextEditingController();

  String category = '';

  GroupCreateInfoState({
    required this.context,
    required this.category,
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

  // 텍스트 필드 변경 감지 메소드
  void updateTextField() {
    notifyListeners();
  }

  // 모든 필드가 유효한지 확인
  bool get isAllFieldsValid {
    return nameController.text.isNotEmpty &&
        introduceController.text.isNotEmpty;
  }

  // 사진 업로드 화면으로 이동
  void nextPressed() {
    if (isAllFieldsValid) {
      Navigator.pushNamed(context, GroupCreatePhotoPage.routeName, arguments: {
        'category': category,
        'name': nameController.text,
        'introduce': introduceController.text,
        'promise': resolutionController.text,
      });
    } else {
      // 필드가 유효하지 않을 때의 처리 (옵션)
      // 예: 사용자에게 경고 메시지 표시
    }
  }
}
