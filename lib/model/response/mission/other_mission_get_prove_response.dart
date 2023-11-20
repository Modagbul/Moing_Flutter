class EveryMissionProveData {
  final int archiveId;
  final String nickname;
  String? profileImg;
  final String archive;
  final String createdDate;
  final String way;
  String heartStatus;
  int hearts;
  final String status;
  final int count;

  EveryMissionProveData({required this.archiveId, required this.nickname, required this.profileImg,
    required this.archive, required this.createdDate, required this.way, required this.heartStatus,
    required this.hearts, required this.status, required this.count});

  set setheartStatus(String newHeartStatus) {
    heartStatus = newHeartStatus;
  }

  set setHearts(int newHearts) {
    hearts = newHearts;
  }

  factory EveryMissionProveData.fromJson(Map<String, dynamic> json) {
    return EveryMissionProveData(
      archiveId: json['archiveId'] as int,
      nickname: json['nickname'] as String,
      profileImg: json['profileImg'] as String?,
      archive: json['archive'] as String,
      createdDate: json['createdDate'] as String,
      way: json['way'] as String,
      heartStatus: json['heartStatus'] as String,
      hearts: json['hearts'] as int,
      status: json['status'] as String,
      count: json['count'] as int,
    );
  }

  @override
  String toString() {
    return 'EveryMissionProveData(archiveId: $archiveId, nickname: $nickname, profileImg: $profileImg, archive: $archive, createdDate: $createdDate, way: $way, heartStatus: $heartStatus, hearts: $hearts, status: $status, count: $count)';
  }
}