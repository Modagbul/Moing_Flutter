import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/login/date/sign_up_date_page.dart';

class SignUpGenderState extends ChangeNotifier {
  final BuildContext context;
  String? selectedGender;
  bool isSelected = false;

  SignUpGenderState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "SignUpGenderState" has been created');
  }

  void setGender(String gender) {
    selectedGender = gender;
    isSelected = true;
    notifyListeners();
  }

  void nextPressed() {
    if(isSelected) {
      Navigator.pushNamed(context, SignUpDatePage.routeName);
    }
  }

}