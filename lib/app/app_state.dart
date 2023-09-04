import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _mainIndex = 0;

  int get mainIndex => _mainIndex;

  set mainIndex(int index) {
    this._mainIndex = index;
    notifyListeners();
  }

  moveToHomeScreen() => this.mainIndex = 0;

  moveToMissionsScreen() => this.mainIndex = 1;

  moveToMyPageScreen() => this.mainIndex = 2;
}