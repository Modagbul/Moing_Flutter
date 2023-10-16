import 'dart:developer';

import 'package:flutter/material.dart';

class PostDetailState extends ChangeNotifier {
  final BuildContext context;

  PostDetailState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "PostDetailState" has been created');
  }

  @override
  void dispose() {
    log('Instance "PostDetailState" has been removed');
    super.dispose();
  }
}
