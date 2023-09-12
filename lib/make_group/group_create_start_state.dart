import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/make_group/group_create_category_page.dart';
//import 'package:moing_flutter/login/category/group_create_category_page.dart';

class GroupCreateStartState extends ChangeNotifier {
  final BuildContext context;

  GroupCreateStartState({
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

  void navigateCategory(){
    Navigator.pushNamed(context, GroupCreateCategoryPage.routeName);
  }
}