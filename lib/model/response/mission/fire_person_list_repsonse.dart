class FireReceiverData {
  final int receiveMemberId;
  final String nickname;
  final String fireStatus;
  String? profileImg;

  FireReceiverData({
    required this.receiveMemberId,
    required this.nickname,
    required this.fireStatus,
    required this.profileImg,
  });

  factory FireReceiverData.fromJson(Map<String, dynamic> json) {
    return FireReceiverData(
      receiveMemberId: json['receiveMemberId'] as int,
      nickname: json['nickname'] as String,
      fireStatus: json['fireStatus'] as String,
      profileImg: json['profileImg'] as String?
    );
  }

  @override
  String toString() {
    return 'FireReceiverData(receiveMemberId: $receiveMemberId, '
        'nickname: $nickname, profileImg: $profileImg, fireStatus: $fireStatus,)';
  }
}