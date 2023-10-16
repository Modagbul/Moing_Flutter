import 'dart:developer';
import 'package:flutter/material.dart';

class CompletedMissionState extends ChangeNotifier {

  final BuildContext context;

  CompletedMissionState({required this.context}) {
    log('Instance "CompletedMissionState" has been created');
    initState();
  }

  @override
  void dispose() {
    log('Instance "CompletedMissionState" has been removed');
    super.dispose();
  }

  void initState() {
  }

}