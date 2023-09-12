import 'dart:developer';

import 'package:flutter/material.dart';

class GroupCreateCategoryState extends ChangeNotifier{
  String? selectedCategory;

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void deselectCategory() {
    selectedCategory = null;
    notifyListeners();
  }

  bool isCategorySelected() => selectedCategory != null;

  final BuildContext context;

  GroupCreateCategoryState({required this.context}) {
    log('Instance "LoginState" has been created');
    initState();
  }

  @override
  void dispose() {
    log('Instance "CategoryState" has been removed');
    super.dispose();
  }

  void initState() {
  }

  /// 모임 정보 작성 페이지 이동 (테스트 코드)
  void moveTempPage() {
    // Navigator.of(context).pushNamed(
    //   .routeName,
    // );
  }


}