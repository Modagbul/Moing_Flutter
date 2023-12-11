class MissionFixData {
  final String missionTitle;
  final String missionContent;
  final String missionDueto;
  final String missionRule;
  final bool isRepeated;
  final int missionId;
  final int teamId;
  final int repeatCount;
  final String missionWay;

  MissionFixData({
    required this.missionTitle,
    required this.missionContent,
    required this.missionDueto,
    required this.missionRule,
    required this.isRepeated,
    required this.missionId,
    required this.teamId,
    required this.repeatCount,
    required this.missionWay,
  });
}