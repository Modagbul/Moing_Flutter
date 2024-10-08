class AggregateTeamRepeatMissionStatusResponse {
  bool isSuccess;
  String message;
  List<AggregateTeamRepeatMission> data;

  AggregateTeamRepeatMissionStatusResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory AggregateTeamRepeatMissionStatusResponse.fromJson(Map<String, dynamic> json) {
    return AggregateTeamRepeatMissionStatusResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: json['data'] == null
          ? []
          : (json['data'] as List)
          .map((item) => AggregateTeamRepeatMission.fromJson(item))
          .toList(),
    );
  }
}

class AggregateTeamRepeatMission {
  int missionId;
  int teamId;
  String teamName;
  String missionTitle;
  String doneNum;
  String totalNum;
  String status;
  String donePeople;
  String totalPeople;

  AggregateTeamRepeatMission({
    required this.missionId,
    required this.teamId,
    required this.teamName,
    required this.missionTitle,
    required this.doneNum,
    required this.totalNum,
    required this.status,
    required this.donePeople,
    required this.totalPeople,
  });

  factory AggregateTeamRepeatMission.fromJson(Map<String, dynamic> json) {
    return AggregateTeamRepeatMission(
      missionId: json['missionId'],
      teamId: json['teamId'],
      teamName: json['teamName'],
      missionTitle: json['missionTitle'],
      doneNum: json['doneNum'],
      totalNum: json['totalNum'],
      status: json['status'],
      donePeople: json['donePeople'],
      totalPeople: json['totalPeople'],
    );
  }
}
