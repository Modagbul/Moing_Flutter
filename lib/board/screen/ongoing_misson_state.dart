import 'dart:developer';
import 'package:flutter/material.dart';

import '../../make_group/group_create_start_page.dart';

class OngoingMissonState extends ChangeNotifier {

  final BuildContext context;

  OngoingMissonState({required this.context}) {
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

  // 아 왜 오류 ㅡㅡ
  // void makeGroupPressed() {
  //   Navigator.of(context).pushNamed(
  //     // 임시
  //     GroupCreateStartPage.routeName,
  //   );
  // }

}