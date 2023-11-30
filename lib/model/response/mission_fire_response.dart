class MissionFireData {
  final int receiveMemberId;
  final String nickname;
  final String fireStatus;

  MissionFireData({
    required this.receiveMemberId,
    required this.nickname,
    required this.fireStatus,
  });

  factory MissionFireData.fromJson(Map<String, dynamic> json) {
    return MissionFireData(
      receiveMemberId: json['receiveMemberId'] as int,
      nickname: json['nickname'] as String,
      fireStatus: json['fireStatus'] as String,
    );
  }
}
