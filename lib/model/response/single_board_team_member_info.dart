import 'dart:developer';

class TeamMemberInfo {
  final int memberId;
  final String nickName;
  final String? profileImage;
  final String? introduction;
  final bool isLeader;

  TeamMemberInfo({
    required this.memberId,
    required this.nickName,
    required this.profileImage,
    required this.introduction,
    required this.isLeader,
  });

  factory TeamMemberInfo.fromJson(dynamic json) {
    return TeamMemberInfo(
      memberId: json['memberId'] as int,
      nickName: json['nickName'] as String,
      profileImage: json['profileImage'] as String?,
      introduction: json['introduction'] as String?,
      isLeader: json['isLeader'] as bool,
    );
  }
}
