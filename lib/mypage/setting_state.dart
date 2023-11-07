import 'dart:developer';

import 'package:flutter/material.dart';

class SettingState extends ChangeNotifier {
  final BuildContext context;
  final int teamCount;

  SettingState({
    required this.context,
    required this.teamCount,
  }) {
    initState();
  }

  void initState() {
    log('Instance "SettingState" has been created');
  }

  @override
  void dispose() {
    log('Instance "SettingState" has been removed');
    super.dispose();
  }
}
