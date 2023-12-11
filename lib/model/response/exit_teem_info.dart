class ExitTeamInfo {
  final int teamId;
  final String teamName;
  final int numOfMember;
  final int duration;
  final int levelOfFire;
  final int numOfMission;
  final bool isLeader;
  final String memberName;

  ExitTeamInfo({
    required this.teamId,
    required this.teamName,
    required this.numOfMember,
    required this.duration,
    required this.levelOfFire,
    required this.numOfMission,
    required this.isLeader,
    required this.memberName,
  });

  factory ExitTeamInfo.fromJson(Map<String, dynamic> json) {
    return ExitTeamInfo(
      teamId: json['teamId'] as int,
      teamName: json['teamName'] as String,
      numOfMember: json['numOfMember'] as int,
      duration: json['duration'] as int,
      levelOfFire: json['levelOfFire'] as int,
      numOfMission: json['numOfMission'] as int,
      isLeader: json['isLeader'] as bool,
      memberName: json['memberName'] as String,
    );
  }
}