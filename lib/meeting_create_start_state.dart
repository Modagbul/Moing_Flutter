import 'dart:developer';

import 'package:flutter/material.dart';

class MeetingCreateStartState extends ChangeNotifier {
  final BuildContext context;

  MeetingCreateStartState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "MeetingCreateStartState" has been created');
  }

  @override
  void dispose() {
    log('Instance "MeetingCreateStartState" has been removed');
    super.dispose();
  }
}