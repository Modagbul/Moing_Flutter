import 'dart:developer';

import 'package:flutter/material.dart';

class CategoryState extends ChangeNotifier{

  final BuildContext context;

  CategoryState({required this.context}) {
    log('Instance "LoginState" has been created');
    initState();
  }

  @override
  void dispose() {
    log('Instance "CategoryState" has been removed');
    super.dispose();
  }

  @override
  void initState() {
  }

  /// 모임 정보 작성 페이지 이동 (테스트 코드)
  void moveTempPage() {
    // Navigator.of(context).pushNamed(
    //   .routeName,
    // );
  }


}