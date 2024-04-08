import 'package:flutter/material.dart';
import 'package:moing_flutter/login/register_success/welcome_page.dart';
import 'package:moing_flutter/utils/global/api_generic.dart';
import 'package:moing_flutter/utils/api/refresh_token.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';

import '../../repository/sign_up_repository.dart';

class SignUpDateState extends ChangeNotifier {
  late final SignUpRepository _signUpRepository;

  final BuildContext context;
  final SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
  final TokenManagement tokenManagement = TokenManagement();
  final APICall call = APICall();
  DateTime selectedDate = DateTime.now();

  String nickname = '';
  String? gender = '';

  SignUpDateState({
    required this.context,
    required this.nickname,
    required this.gender,
  }) {
    initState();
  }

  void initState() async {
    _signUpRepository = SignUpRepository(nickname: nickname, gender: gender);
  }

  void changeDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void nextPressed() async {
    // 생년월일만 가져옴.
    String formattedDate = selectedDate.toLocal().toString().split(' ')[0];
    bool? result = await _signUpRepository.signUp(formattedDate);
    if (result == true) {
      navigateToWelcomePage();
    }
  }

  void skipPressed() async {
    bool? result = await _signUpRepository.signUp(null);
    if (result == true) {
      navigateToWelcomePage();
    }
  }

  void navigateToWelcomePage() {
    Navigator.of(context).pushNamed(
      WelcomePage.routeName,
      arguments: nickname,
    );
  }

}
