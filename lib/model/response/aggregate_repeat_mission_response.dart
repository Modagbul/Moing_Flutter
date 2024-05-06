class AggregateRepeatMissionStatusResponse {
  bool isSuccess;
  String message;
  List<AggregateRepeatMission> data;

  AggregateRepeatMissionStatusResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory AggregateRepeatMissionStatusResponse.fromJson(Map<String, dynamic> json) {
    return AggregateRepeatMissionStatusResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: json['data'] == null
          ? []
          : (json['data'] as List)
          .map((item) => AggregateRepeatMission.fromJson(item))
          .toList(),
    );
  }
}

class AggregateRepeatMission {
  int missionId;
  int teamId;
  String teamName;
  String missionTitle;
  String doneNum;
  String totalNum;
  String donePeople;
  String totalPeople;
  String status;

  AggregateRepeatMission({
    required this.missionId,
    required this.teamId,
    required this.teamName,
    required this.missionTitle,
    required this.doneNum,
    required this.totalNum,
    required this.donePeople,
    required this.totalPeople,
    required this.status,
  });

  factory AggregateRepeatMission.fromJson(Map<String, dynamic> json) {
    return AggregateRepeatMission(
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
