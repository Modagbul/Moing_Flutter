import 'package:moing_flutter/model/response/single_board_team_member_info.dart';

class TeamInfo {
  final bool isDeleted;
  final String deletionTime;
  final String teamName;
  final int numOfMember;
  final String category;
  final String introduction;
  final List<TeamMemberInfo> teamMemberInfoList;

  TeamInfo({
    required this.isDeleted,
    required this.deletionTime,
    required this.teamName,
    required this.numOfMember,
    required this.category,
    required this.introduction,
    required this.teamMemberInfoList,
  });

  factory TeamInfo.fromJson(Map<String, dynamic> json) {
    return TeamInfo(
      isDeleted: json['isDeleted'],
      deletionTime: json['deletionTime'],
      teamName: json['teamName'],
      numOfMember: json['numOfMember'],
      category: json['category'],
      introduction: json['introduction'],
      teamMemberInfoList: (json['teamMemberInfoList'] as List)
          .map((i) => TeamMemberInfo.fromJson(i))
          .toList(),
    );
  }
}
