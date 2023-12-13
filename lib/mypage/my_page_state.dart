import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/response/get_my_page_data_response.dart';
import 'package:moing_flutter/mypage/profile_setting_page.dart';

class MyPageState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;
  MyPageData? myPageData;

  MyPageState({
    required this.context,
  }) {
    initState();
  }

  void initState() async {
    log('Instance "MyPageState" has been created');
    await getMyPageData();
  }

  @override
  void dispose() {
    log('Instance "MyPageState" has been removed');
    super.dispose();
  }

  void profilePressed() async {
    var result = await Navigator.of(context).pushNamed(
      ProfileSettingPage.routeName,
    );

    if (result != null && result == true) {
      await getMyPageData();
    }
  }

  Future<void> getMyPageData() async {
    myPageData = await apiCode.getMyPageData();
    notifyListeners();
  }


  String convertCategoryName({required String category}) {
    String convertedCategory = '';

    switch (category) {
      case 'SPORTS':
        convertedCategory = '스포츠/운동';
        break;
      case 'HABIT':
        convertedCategory = '생활습관 개선';
        break;
      case 'TEST':
        convertedCategory = '시험/취업준비';
        break;
      case 'STUDY':
        convertedCategory = '스터디/공부';
        break;
      case 'READING':
        convertedCategory = '독서';
        break;
      case 'ETC':
        convertedCategory = '그외 자기계발';
        break;
    }

    return convertedCategory;
  }
}
