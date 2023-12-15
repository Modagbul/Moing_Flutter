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
    switch(selectedCategory) {
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
      case '그외 자기계발':
        selectedCategoryEnglish = 'ETC';
        break;
    }
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

    isSelected = false;

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
  void moveInfoPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => GroupCreateInfoPage.route(context),
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
  }


}
