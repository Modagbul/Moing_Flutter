import 'dart:developer';

import 'package:flutter/material.dart';

class PostMainState extends ChangeNotifier {
  final BuildContext context;

  PostMainState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "PostMainState" has been created');
  }

  @override
  void dispose() {
    log('Instance "PostMainState" has been removed');
    super.dispose();
  }
}
