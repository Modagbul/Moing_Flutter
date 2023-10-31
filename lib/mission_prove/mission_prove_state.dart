import 'dart:developer';

import 'package:flutter/material.dart';

class MissionProveState extends ChangeNotifier {
  final BuildContext context;
  late TabController tabController;


  MissionProveState({required this.context}) {
    initState();
  }

  void initState() {
    log('Instance "MissionProveState" has been created');
  }

  void initTabController({required TabController tabController}) {
    this.tabController = tabController;
  }

  void dispose() {
    tabController.dispose();
    log('Instance "MissionProveState" has been removed');
    super.dispose();
  }
}