import 'dart:developer';

import 'package:moing_flutter/dataSource/sign_up_data_source.dart';

class SignUpRepository {
  final SignUpDataSource _dataSource;

  SignUpRepository({required String nickname, String? gender})
      : _dataSource = SignUpDataSource(nickname: nickname, gender: gender);

  Future<bool?> signUp(String? birthDate) {
    log('signUp in SignUpRepository called with birthDate: $birthDate');

    return _dataSource.signUp(birthDate);
  }
}