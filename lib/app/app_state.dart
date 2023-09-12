import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _mainIndex = 0;

  int get mainIndex => _mainIndex;

  set mainIndex(int index) {
    _mainIndex = index;
    notifyListeners();
  }

  moveToHomeScreen() => mainIndex = 0;

  moveToMissionsScreen() => mainIndex = 1;

  moveToMyPageScreen() => mainIndex = 2;
}