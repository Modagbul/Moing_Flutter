import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/response/single_board_team_member_info.dart';

class TeamMemeberListState extends ChangeNotifier {
  final BuildContext context;
  final List<TeamMemberInfo> teamMemberInfoList;

  TeamMemeberListState({
    required this.context,
    required this.teamMemberInfoList,
  }) {
    initState();
  }

  void initState() {
    log('Instance "TeamMemeberListState" has been created');
  }

  @override
  void dispose() {
    log('Instance "TeamMemeberListState" has been removed');
    super.dispose();
  }

  void pressCloseButton() {
    Navigator.pop(context);
  }
}
