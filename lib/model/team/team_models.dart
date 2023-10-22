class TeamBlock {
  final int teamId;
  final int duration;
  final int levelOfFire;
  final String teamName;
  final int numOfMember;
  final String category;
  final String startDate;
  final String deletionTime;

  TeamBlock({
    required this.teamId,
    required this.duration,
    required this.levelOfFire,
    required this.teamName,
    required this.numOfMember,
    required this.category,
    required this.startDate,
    required this.deletionTime,
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
      deletionTime: json['deletionTime'],
    );
  }
}

class TeamData {
  final String memberNickName;
  final int numOfTeam;
  final List<TeamBlock> teamBlocks;

  TeamData({
    required this.memberNickName,
    required this.numOfTeam,
    required this.teamBlocks,
  });

  factory TeamData.fromJson(Map<String, dynamic> json) {
    return TeamData(
      memberNickName: json['memberNickName'],
      numOfTeam: json['numOfTeam'],
      teamBlocks: (json['teamBlocks'] as List)
          .map((e) => TeamBlock.fromJson(e))
          .toList(),
    );
  }
}