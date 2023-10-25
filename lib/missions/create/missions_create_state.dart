import 'dart:developer';

import 'package:flutter/material.dart';

class MissionCreateState extends ChangeNotifier {
  final BuildContext context;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  bool isTitleFocused = false;

  final List<String> textList = [
    '매일 물 2L 마시기',
    '매일 아침 이불정리하기',
    '오전 7시 기상 인증하기',
    '모닝페이지 작성하기',
    '하루 계획 세우기',
    '일어나자마자 양치하기',
    '휴대폰 6시간 이하 쓰기',
  ];

  String title = '';
  String content = '';

  MissionCreateState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "MissionCreateState" has been created');
    titleController.addListener(_onTitleTextChanged);
    titleFocusNode.addListener(onTitleFocusChanged);
  }

  @override
  void dispose() {
    log('Instance "MissionCreateState" has been removed');
    titleController.removeListener(_onTitleTextChanged);
    contentController.removeListener(_onContentTextChanged);
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _onTitleTextChanged() {
    title = titleController.text;
    notifyListeners();
  }

  void onTitleFocusChanged() {
    isTitleFocused = titleFocusNode.hasFocus;
    notifyListeners();
  }

  void _onContentTextChanged() {
    content = contentController.text;
    notifyListeners();
  }

  void updateTextField() {
    notifyListeners();
  }

  // 이름 텍스트 필드 초기화 메소드
  void clearTitleTextField() {
    titleController.clear();
    notifyListeners();
  }

  // 소개글 텍스트 필드 초기화 메소드
  void clearContentTextField() {
    contentController.clear();
    notifyListeners();
  }
}
