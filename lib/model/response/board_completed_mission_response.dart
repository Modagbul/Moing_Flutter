class BoardCompletedMissionResponse {
  bool isSuccess;
  String message;
  List<EndedMission> data;

  BoardCompletedMissionResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory BoardCompletedMissionResponse.fromJson(Map<String, dynamic> json) {
    return BoardCompletedMissionResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => EndedMission.fromJson(item))
          .toList(),
    );
  }
}

class EndedMission {
  int missionId;
  String dueTo;
  String title;
  String status;
  String missionType;

  EndedMission({
    required this.missionId,
    required this.dueTo,
    required this.title,
    required this.status,
    required this.missionType,
  });

  factory EndedMission.fromJson(Map<String, dynamic> json) {
    return EndedMission(
      missionId: json['missionId'],
      dueTo: json['dueTo'],
      title: json['title'],
      status: json['status'],
      missionType: json['missionType'],
    );
  }
}
