class RepeatMissionStatusResponse {
  bool isSuccess;
  String message;
  List<RepeatMission> data;

  RepeatMissionStatusResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory RepeatMissionStatusResponse.fromJson(Map<String, dynamic> json) {
    return RepeatMissionStatusResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => RepeatMission.fromJson(item))
          .toList(),
    );
  }
}

class RepeatMission {
  int missionId;
  String title;
  String dueTo;
  int done;
  int number;

  RepeatMission({
    required this.missionId,
    required this.title,
    required this.dueTo,
    required this.done,
    required this.number,
  });

  factory RepeatMission.fromJson(Map<String, dynamic> json) {
    return RepeatMission(
      missionId: json['missionId'],
      title: json['title'],
      dueTo: json['dueTo'],
      done: json['done'],
      number: json['number'],
    );
  }
}
