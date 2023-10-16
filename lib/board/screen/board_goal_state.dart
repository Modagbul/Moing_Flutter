import 'dart:developer';

import 'package:flutter/material.dart';

class BoardGoalState extends ChangeNotifier {
  final BuildContext context;
  bool isExpanded = false;

  BoardGoalState({
    required this.context,
    required this.isExpanded,
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

  void toggleExpansion(){

  }

}
