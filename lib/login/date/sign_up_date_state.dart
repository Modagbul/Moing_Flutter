import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/login/register_success/welcome_page.dart';

class SignUpDateState extends ChangeNotifier {
  final BuildContext context;
  DateTime selectedDate = DateTime.now();

  SignUpDateState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "SignUpDateState" has been created');
  }

  void changeDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void nextPressed() {
    // 생년월일만 가져옴.
    String formattedDate = selectedDate.toLocal().toString().split(' ')[0];
    print('생년월일 : ${formattedDate}');
    Navigator.pushNamed(context, WelcomePage.routeName);
  }
}