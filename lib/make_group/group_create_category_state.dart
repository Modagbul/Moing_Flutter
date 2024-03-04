import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/make_group/group_create_info_page.dart';

import '../const/color/colors.dart';

class GroupCreateCategoryState extends ChangeNotifier {
  final BuildContext context;
  String? selectedCategory;
  String? selectedCategoryEnglish;
  Map<String, bool> categoryStatus = {};
  bool isSelected = false;

  String? customCategory;

  void setCustomCategory(String value) {
    if (value.isNotEmpty) {
      deselectAllCategories();
      customCategory = value;
      // ** 사용자 정의 카테고리 값을 selectedCategoryEnglish에도 설정
      selectedCategoryEnglish = value;
      isSelected = true;
    } else {
      customCategory = null;
      isSelected = false;
    }
    notifyListeners();
  }


  void deselectAllCategories() {
    categoryStatus.forEach((key, value) => categoryStatus[key] = false);
    selectedCategory = null;
    notifyListeners();
  }

  GroupCreateCategoryState({
    required this.context,
  });

  void selectCategory(String category) {
    categoryStatus.forEach((key, value) {
      categoryStatus[key] = false;
    });

    categoryStatus[category] = true;
    selectedCategory = category;

    switch (selectedCategory) {
      case '스포츠/운동':
        selectedCategoryEnglish = 'SPORTS';
        break;
      case '생활습관 개선':
        selectedCategoryEnglish = 'HABIT';
        break;
      case '시험/취업준비':
        selectedCategoryEnglish = 'TEST';
        break;
      case '스터디/공부':
        selectedCategoryEnglish = 'STUDY';
        break;
      case '독서':
        selectedCategoryEnglish = 'READING';
        break;
      default:
        selectedCategoryEnglish = category.toString(); // 사용자 정의 카테고리일 경우, 입력값 그대로 저장
        break;
    }

    isSelected = true;
    notifyListeners();
  }

  void deselectCategory() {
    if (selectedCategory != null) {
      // 선택된 카테고리의 상태를 false로 업데이트
      categoryStatus[selectedCategory!] = false;
    }

    selectedCategory = null;

    isSelected = false;

    notifyListeners();
  }

  bool isCategorySelected() {
    return selectedCategory != null || customCategory != null;
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
  void moveInfoPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            GroupCreateInfoPage.route(context),
        settings: RouteSettings(
          arguments: selectedCategoryEnglish,
        ),
        transitionsBuilder: (context, animation1, animation2, child) {
          return child;
        },
        transitionDuration: Duration(milliseconds: 0),
      ),
    ).then((_) {
      Navigator.of(context).removeRouteBelow(_);
    });
    print("Selected category: $selectedCategoryEnglish");

  }
}
