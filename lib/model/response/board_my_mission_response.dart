class MyMissionStatusResponse {
  bool isSuccess;
  String message;
  List<MissionArchive> data;

  MyMissionStatusResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory MyMissionStatusResponse.fromJson(Map<String, dynamic> json) {
    return MyMissionStatusResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => MissionArchive.fromJson(item))
          .toList(),
    );
  }
}

class MissionArchive {
  int archiveId;
  String archive;
  String createdDate;
  String status;
  int count;
  bool heartStatus;
  int hearts;

  MissionArchive({
    required this.archiveId,
    required this.archive,
    required this.createdDate,
    required this.status,
    required this.count,
    required this.heartStatus,
    required this.hearts,
  });

  factory MissionArchive.fromJson(Map<String, dynamic> json) {
    return MissionArchive(
      archiveId: json['archiveId'],
      archive: json['archive'],
      createdDate: json['createdDate'],
      status: json['status'],
      count: json['count'],
      heartStatus: json['heartStatus'].toString().toLowerCase() == 'true',
      hearts: json['hearts'],
    );
  }
}
