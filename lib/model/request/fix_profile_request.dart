class FixProfile {
  final String? nickName;
  final String? introduction;
  final String? profileImage;

  FixProfile({this.nickName, this.introduction, this.profileImage});

  Map<String, dynamic> toJson() => {
    'nickName': nickName,
    'introduction': introduction,
    'profileImage': profileImage,
  };
}