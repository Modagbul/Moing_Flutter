import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:moing_flutter/home/home_screen.dart';
import 'package:moing_flutter/main/main_page.dart';

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

  /// 가입 완료하기 버튼 클릭
  void completePressed() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      MainPage.routeName,
          (route) => false,
    );
  }
}