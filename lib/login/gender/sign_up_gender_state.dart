import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/login/date/sign_up_date_page.dart';

class SignUpGenderState extends ChangeNotifier {
  final BuildContext context;
  String? selectedGender;
  bool isSelected = false;
  String nickname = '';

  SignUpGenderState({
    required this.context,
    required this.nickname,
  }) {
    log('Instance "SignUpGenderState" has been created');
  }

  void setGender(String gender) {
    selectedGender = gender;
    isSelected = true;
    notifyListeners();
  }

  void nextPressed() {
    if (isSelected) {
      Navigator.pushNamed(context, SignUpDatePage.routeName, arguments: {
        'nickname': nickname,
        'gender': selectedGender,
      });
      notifyListeners();
    }
  }

  void skipPressed() {
    Navigator.pushNamed(context, SignUpDatePage.routeName, arguments: {
      'nickname': nickname,
    });
  }
}
