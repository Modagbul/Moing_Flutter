class AggregateSingleMissionResponse {
  bool isSuccess;
  String message;
  List<AggregateMission> data;

  AggregateSingleMissionResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory AggregateSingleMissionResponse.fromJson(Map<String, dynamic> json) {
    return AggregateSingleMissionResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: (json['data'] as List<dynamic>)
          .map((item) => AggregateMission.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

}

class AggregateMission {
  int missionId;
  int teamId;
  String dueTo;
  String teamName;
  String missionTitle;
  String status;

  AggregateMission({
    required this.missionId,
    required this.teamId,
    required this.dueTo,
    required this.teamName,
    required this.missionTitle,
    required this.status,
  });

  factory AggregateMission.fromJson(Map<String, dynamic> json) {
    return AggregateMission(
      missionId: json['missionId'],
      teamId: json['teamId'],
      dueTo: json['dueTo'],
      teamName: json['teamName'],
      missionTitle: json['missionTitle'],
      status: json['status'],
    );
  }
}
