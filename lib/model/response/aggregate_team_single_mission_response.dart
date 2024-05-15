class AggregateTeamSingleMissionResponse {
  bool isSuccess;
  String message;
  List<AggregateTeamMission> data;

  AggregateTeamSingleMissionResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory AggregateTeamSingleMissionResponse.fromJson(Map<String, dynamic> json) {
    return AggregateTeamSingleMissionResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: (json['data'] as List<dynamic>)
          .map((item) => AggregateTeamMission.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

}

class AggregateTeamMission {
  int missionId;
  int teamId;
  String dueTo;
  String teamName;
  String missionTitle;
  String status;
  String done;
  String total;

  AggregateTeamMission({
    required this.missionId,
    required this.teamId,
    required this.dueTo,
    required this.teamName,
    required this.missionTitle,
    required this.status,
    required this.done,
    required this.total,
  });

  factory AggregateTeamMission.fromJson(Map<String, dynamic> json) {
    return AggregateTeamMission(
      missionId: json['missionId'],
      teamId: json['teamId'],
      dueTo: json['dueTo'],
      teamName: json['teamName'],
      missionTitle: json['missionTitle'],
      status: json['status'],
      done: json['done'],
      total: json['total'],
    );
  }
}
