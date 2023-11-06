class ExitTeamInfo {
  final int teamId;
  final String teamName;
  final int numOfMember;
  final int duration;
  final int levelOfFire;
  final int numOfMission;

  ExitTeamInfo({
    required this.teamId,
    required this.teamName,
    required this.numOfMember,
    required this.duration,
    required this.levelOfFire,
    required this.numOfMission,
  });

  factory ExitTeamInfo.fromJson(Map<String, dynamic> json) {
    return ExitTeamInfo(
      teamId: json['teamId'] as int,
      teamName: json['teamName'] as String,
      numOfMember: json['numOfMember'] as int,
      duration: json['duration'] as int,
      levelOfFire: json['levelOfFire'] as int,
      numOfMission: json['numOfMission'] as int,
    );
  }
}