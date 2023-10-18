import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/login/register_success/welcome_page.dart';
import 'package:moing_flutter/model/sign_up_arguments.dart';

class SignUpDateState extends ChangeNotifier {
  final BuildContext context;
  DateTime selectedDate = DateTime.now();

  String nickname = '';
  String gender = '';

  SignUpDateState({
    required this.context,
    required this.nickname,
    required this.gender,
  }) {
    log('Instance "SignUpDateState" has been created');
  }

  void changeDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void nextPressed() {
    // 생년월일만 가져옴.
    String formattedDate = selectedDate.toLocal().toString().split(' ')[0];

    /// TODO : 회원가입 절차 진행
    print('$nickname+$gender+$formattedDate');
    Navigator.pushNamed(context, WelcomePage.routeName, arguments: SignUpData(
        nickName: nickname, gender: gender, birthDate: formattedDate));
  }
}