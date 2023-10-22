import 'package:flutter/material.dart';

class TeamData {
  String memberNickName;
  int numOfTeam;
  List<TeamBlock> teamBlocks;

  TeamData({
    required this.memberNickName,
    required this.numOfTeam,
    required this.teamBlocks});

  factory TeamData.fromJson(Map<String, dynamic> json) {
    return TeamData(
      memberNickName: json['memberNickName'],
      numOfTeam: json['numOfTeam'],
      teamBlocks: (json['teamBlocks'] as List)
          .map((item) => TeamBlock.fromJson(item))
          .toList(),
    );
  }
}

class TeamBlock {
  int teamId;
  int duration;
  int levelOfFire;
  String teamName;
  int numOfMember;
  String category;
  String startDate;

  TeamBlock({
    required this.teamId,
    required this.duration,
    required this.levelOfFire,
    required this.teamName,
    required this.numOfMember,
    required this.category,
    required this.startDate,
  });

  factory TeamBlock.fromJson(Map<String, dynamic> json) {
    return TeamBlock(
      teamId: json['teamId'],
      duration: json['duration'],
      levelOfFire: json['levelOfFire'],
      teamName: json['teamName'],
      numOfMember: json['numOfMember'],
      category: json['category'],
      startDate: json['startDate'],
    );
  }
}