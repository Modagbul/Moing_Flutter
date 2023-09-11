import 'dart:developer';

import 'package:flutter/material.dart';

class BoardMainState extends ChangeNotifier {
  final BuildContext context;
  late TabController tabController;

  BoardMainState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "BoardMainState" has been created');
  }

  void initTabController({required TabController tabController}) {
    this.tabController = tabController;
  }

  @override
  void dispose() {
    tabController.dispose();
    log('Instance "BoardMainState" has been removed');
    super.dispose();
  }
}
