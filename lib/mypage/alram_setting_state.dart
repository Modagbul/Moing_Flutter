import 'dart:developer';

import 'package:flutter/material.dart';

class AlramSettingState extends ChangeNotifier {
  final BuildContext context;

  AlramSettingState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "AlramSettingState" has been created');
  }

  @override
  void dispose() {
    log('Instance "AlramSettingState" has been removed');
    super.dispose();
  }

}
