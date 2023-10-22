class TeamMemberInfo {
  final int memberId;
  final String nickName;
  final String profileImage;
  final String introduction;
  final bool isLeader;

  TeamMemberInfo({
    required this.memberId,
    required this.nickName,
    required this.profileImage,
    required this.introduction,
    required this.isLeader,
  });

  factory TeamMemberInfo.fromJson(Map<String, dynamic> json) {
    return TeamMemberInfo(
      memberId: json['memberId'],
      nickName: json['nickName'],
      profileImage: json['profileImage'],
      introduction: json['introduction'],
      isLeader: json['isLeader'],
    );
  }
}
