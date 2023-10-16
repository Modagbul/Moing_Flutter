import 'dart:developer';
import 'package:flutter/material.dart';

class BoardMissionState extends ChangeNotifier {

  final BuildContext context;

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