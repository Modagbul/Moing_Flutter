import 'package:flutter/material.dart';

class MainState extends ChangeNotifier {
  final BuildContext context;

  MainState({required this.context}) {
    print('Instance "MainState" has been created');
  }
}
