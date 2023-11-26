import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/main/main_page.dart';

class GroupCreateSuccessState extends ChangeNotifier {
  final BuildContext context;

  GroupCreateSuccessState({required this.context}) {
    initState();
  }

  void initState() {
    log('Instance "GroupCreateSuccessState" has been created');
  }

  @override
  void dispose() {
    log('Instance "GroupCreateSuccessState" has been removed');
    super.dispose();
  }

  void submit() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      MainPage.routeName,
          (route) => false,
        arguments: 'new',
    );
  }
}
