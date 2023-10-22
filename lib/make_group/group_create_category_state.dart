import 'dart:developer';

import 'package:flutter/material.dart';

import '../const/color/colors.dart';

class GroupCreateCategoryState extends ChangeNotifier {
  final BuildContext context;
  String? selectedCategory;
  Map<String, bool> categoryStatus = {};
  bool isSelected = false;

  GroupCreateCategoryState({
    required this.context,
  });

  void selectCategory(String category) {
    if (selectedCategory != null && selectedCategory != category) {
      // 이전에 선택된 카테고리의 상태를 false로 업데이트
      categoryStatus[selectedCategory!] = false;
    }

    // 새로운 카테고리를 선택하고 상태를 true로 업데이트
    selectedCategory = category;
    categoryStatus[category] = true;

    isSelected = true;  // 카테고리가 선택되었으므로 isSelected를 true로 설정

    notifyListeners();
  }

  void deselectCategory() {
    if (selectedCategory != null) {
      // 선택된 카테고리의 상태를 false로 업데이트
      categoryStatus[selectedCategory!] = false;
    }

    selectedCategory = null;

    isSelected = false;  // 카테고리 선택이 해제되었으므로 isSelected를 false로 설정

    notifyListeners();
  }


  bool isCategorySelected() {
    return isSelected && selectedCategory != null;
  }

  Color getNextButtonColor() {
    return isCategorySelected() ? grayScaleWhite : grayScaleGrey700;
  }

  Color getNextButtonTextColor() {
    return isCategorySelected() ? grayScaleBlack : grayScaleGrey500;
  }

  @override
  void dispose() {
    log('Instance "CategoryState" has been removed');
    super.dispose();
  }

  void initState() {}

  /// 모임 정보 작성 페이지 이동 (테스트 코드)
  void moveTempPage() {
    // Navigator.of(context).pushNamed(
    //   .routeName,
    // );
  }
}
