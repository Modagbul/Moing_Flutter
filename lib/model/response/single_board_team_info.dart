import 'package:moing_flutter/model/response/single_board_team_member_info.dart';

class TeamInfo {
  final bool isDeleted;
  final String? deletionTime;
  final String teamName;
  final int numOfMember;
  final String category;
  final String introduction;
  final int currentUserId;
  final List<TeamMemberInfo> teamMemberInfoList;

  TeamInfo({
    required this.isDeleted,
    required this.deletionTime,
    required this.teamName,
    required this.numOfMember,
    required this.category,
    required this.introduction,
    required this.currentUserId,
    required this.teamMemberInfoList,
  });

  factory TeamInfo.fromJson(Map<String, dynamic> json) {
    return TeamInfo(
      isDeleted: json['isDeleted'] as bool,
      deletionTime: json['deletionTime'] as String?,
      teamName: json['teamName'] as String,
      numOfMember: json['numOfMember'] as int,
      category: json['category'] as String,
      introduction: json['introduction'] as String,
      currentUserId: json['currentUserId'] as int,
      teamMemberInfoList: (json['teamMemberInfoList'] as List)
          .map((i) => TeamMemberInfo.fromJson(i))
          .toList(),
    );
  }
}
