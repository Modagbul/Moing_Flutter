import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/response/get_single_board.dart';
import 'package:moing_flutter/model/response/single_board_team_info.dart';
import 'package:moing_flutter/model/team/team_fire_level_models.dart';
import 'package:moing_flutter/post/post_main_page.dart';

class BoardMainState extends ChangeNotifier {
  final BuildContext context;
  late TabController tabController;
  final ApiCode apiCode = ApiCode();
  final int teamId;

  SingleBoardData? singleBoardData;
  TeamFireLevelData? teamFireLevelData;
  TeamInfo? teamInfo;

  BoardMainState({
    required this.context,
    required this.teamId,
  }) {
    initState();
  }

  void initState() {
    log('Instance "BoardMainState" has been created');
    getSingleBoard();
    getTeamFireLevel();
  }

  void initTabController({required TabController tabController}) {
    this.tabController = tabController;
  }

  @override
  void dispose() {
    tabController.dispose();
    log('Instance "BoardMainState" has been removed');
    super.dispose();
  }

  void getSingleBoard() async {
    singleBoardData = await apiCode.getSingleBoard(teamId: teamId);
    teamInfo = singleBoardData?.teamInfo;
    notifyListeners();
  }

  void navigatePostMainPage() {
    Navigator.pushNamed(context, PostMainPage.routeName, arguments: teamId);
  }

  void getTeamFireLevel() async {
    teamFireLevelData = await apiCode.getTeamFireLevel(teamId: teamId);
    notifyListeners();
  }
}
