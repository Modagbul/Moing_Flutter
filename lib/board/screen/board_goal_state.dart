import 'dart:developer';

import 'package:flutter/material.dart';

class BoardGoalState extends ChangeNotifier {
  final BuildContext context;

  BoardGoalState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "BoardGoalState" has been created');
  }

  @override
  void dispose() {
    log('Instance "BoardGoalState" has been removed');
    super.dispose();
  }
}
