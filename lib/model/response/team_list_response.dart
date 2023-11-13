class TeamListResponse {
  bool isSuccess;
  String message;
  List<TeamList> data;

  TeamListResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory TeamListResponse.fromJson(Map<String, dynamic> json) {
    return TeamListResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: json['data'] == null
          ? []
          : (json['data'] as List)
          .map((item) => TeamList.fromJson(item))
          .toList(),
    );
  }
}

class TeamList {
  int teamId;
  String teamName;

  TeamList({
    required this.teamId,
    required this.teamName,
  });

  factory TeamList.fromJson(Map<String, dynamic> json) {
    return TeamList(
      teamId: json['teamId'],
      teamName: json['teamName'],
    );
  }
}
