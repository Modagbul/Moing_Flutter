class BoardSingleMissionResponse {
  bool isSuccess;
  String message;
  List<Mission> data;

  BoardSingleMissionResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory BoardSingleMissionResponse.fromJson(Map<String, dynamic> json) {
    return BoardSingleMissionResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: (json['data'] as List<dynamic>)
          .map((item) => Mission.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

}

class Mission {
  int missionId;
  String dueTo;
  String title;
  String status;
  String missionType;

  Mission({
    required this.missionId,
    required this.dueTo,
    required this.title,
    required this.status,
    required this.missionType,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      missionId: json['missionId'],
      dueTo: json['dueTo'],
      title: json['title'],
      status: json['status'],
      missionType: json['missionType'],
    );
  }
}
