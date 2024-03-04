class MyMissionProveAllData {
  final bool today;
  final List<MyMissionProveData> archives;

  MyMissionProveAllData({
    required this.today,
    required this.archives,
  });

  factory MyMissionProveAllData.fromJson(Map<String, dynamic> json) {
    return MyMissionProveAllData(
      today: json['today'].toString().toLowerCase() == 'true',
      archives: (json['archives'] as List)
          .map((archiveJson) => MyMissionProveData.fromJson(archiveJson))
          .toList(),
    );
  }
}

class MyMissionProveData {
  final int archiveId;
  final String archive;
  final String way;
  final String createdDate;
  final String status;
  final int count;
  final String heartStatus;
  final int hearts;
  final String? nickname;

  MyMissionProveData({required this.archiveId, required this.archive, required this.way, required this.createdDate,
  required this.status, required this.count, required this.heartStatus, required this.hearts, required this.nickname});

  factory MyMissionProveData.fromJson(Map<String, dynamic> json) {
    return MyMissionProveData(
      archiveId: json['archiveId'] as int,
      archive: json['archive'] as String,
      way: json['way'] as String,
      createdDate: json['createdDate'] as String,
      status: json['status'] as String,
      count: json['count'] as int,
      heartStatus: json['heartStatus'] as String,
      hearts: json['hearts'] as int,
      nickname: json['nickname'] as String?,
    );
  }

  @override
  String toString() {
    return 'MyMissionProveData(archiveId: $archiveId, archive: $archive, way: $way, createdDate: $createdDate, status: $status, count: $count, heartStatus: $heartStatus, hearts: $hearts)';
  }
}