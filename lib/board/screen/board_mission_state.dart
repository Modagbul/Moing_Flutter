import 'dart:developer';
import 'package:flutter/material.dart';

class BoardMissionState extends ChangeNotifier {

  final BuildContext context;
  TabController? tabController;

  void initTabController({required TabController tabController}) {
    this.tabController = tabController;
    notifyListeners();
  }

  BoardMissionState({required this.context}) {
    log('Instance "BoardMissionState" has been created');
    initState();
  }

  @override
  void dispose() {
    log('Instance "BoardMissionState" has been removed');
    super.dispose();
  }

  void initState() {
  }

}