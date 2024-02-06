class MissionProveArgument {
  final bool isRepeated;
  final int teamId;
  final int missionId;
  final String status;
  final bool isEnded;
  final bool isRead;

  MissionProveArgument({
    required this.isRepeated,
    required this.teamId,
    required this.missionId,
    required this.status,
    required this.isEnded,
    required this.isRead,
  });
}