import 'dart:developer';

import 'package:flutter/material.dart';

class MissionCreateState extends ChangeNotifier {
  final BuildContext context;

  MissionCreateState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "MissionCreateState" has been created');
  }
}
