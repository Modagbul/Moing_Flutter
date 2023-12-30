class BlockedMemberInfo {
  final int targetId;
  final String nickName;
  final String? introduce;
  final String? profileImg;

  BlockedMemberInfo({
    required this.targetId,
    required this.nickName,
    required this.introduce,
    required this.profileImg,
  });

  factory BlockedMemberInfo.fromJson(dynamic json) {
    return BlockedMemberInfo(
      targetId: json['targetId'] as int,
      nickName: json['nickName'] as String,
      introduce: json['introduce'] as String?,
      profileImg: json['profileImg'] as String?,
    );
  }
}
