import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/board/screen/team_member_list_page.dart';
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
  final bool isSuccess;

  SingleBoardData? singleBoardData;
  TeamFireLevelData? teamFireLevelData;
  TeamInfo? teamInfo;

  BoardMainState( {
    required this.context,
    required this.teamId,
    required this.isSuccess,
  }) {
    initState();
  }

  void initState() {
    log('Instance "BoardMainState" has been created');
    print('teamID : $teamId');
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

  void navigateTeamMemberListPage() {
    Navigator.pushNamed(
      context,
      TeamMemberListPage.routeName,
      arguments: teamInfo?.teamMemberInfoList,
    );
  }

  String convertCategoryName({required String category}) {
    String convertedCategory = '';

    switch (category) {
      case 'SPORTS':
        convertedCategory = '스포츠/운동';
        break;
      case 'HABIT':
        convertedCategory = '생활습관 개선';
        break;
      case 'TEST':
        convertedCategory = '시험/취업준비';
        break;
      case 'STUDY':
        convertedCategory = '스터디/공부';
        break;
      case 'READING':
        convertedCategory = '독서';
        break;
      case 'ETC':
        convertedCategory = '그외 자기계발';
        break;
    }

    return convertedCategory;
  }
}
