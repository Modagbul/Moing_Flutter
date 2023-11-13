import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/make_group/group_create_start_page.dart';

class RegisterGuideState extends ChangeNotifier {
  final BuildContext context;

  RegisterGuideState({required this.context}) {
    log('Instance "RegisterGuideState" has been created');
  }

  @override
  void dispose() {
    log('Instance "RegisterGuideState" has been removed');
    super.dispose();
  }

  /// 나만의 소모임 버튼 클릭
  void makeTeam() {
    Navigator.pushNamed(context, GroupCreateStartPage.routeName);
  }

  /// 가입 완료하기 버튼 클릭
  void completePressed() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      MainPage.routeName,
          (route) => false,
    );
  }
}