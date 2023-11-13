import 'dart:developer';

import 'package:moing_flutter/model/response/single_board_team_info.dart';

class SingleBoardData {
  final int? boardNum;
  final TeamInfo teamInfo;

  SingleBoardData({required this.boardNum, required this.teamInfo});

  factory SingleBoardData.fromJson(Map<String, dynamic> json) {
    return SingleBoardData(
      boardNum: (json['boardNum'] ?? 0) as int,
      teamInfo: TeamInfo.fromJson(json['teamInfo']),
    );
  }
}