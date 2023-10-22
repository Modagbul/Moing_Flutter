import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/home/home_screen.dart';
import 'package:moing_flutter/login/sign_in/login_page.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/make_group/group_create_category_page.dart';
//import 'package:moing_flutter/login/category/group_create_category_page.dart';

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
