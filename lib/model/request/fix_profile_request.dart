class FixProfile {
  final String nickName;
  final String introduction;
  final String profileImage;

  FixProfile({required this.nickName, required this.introduction, required this.profileImage});

  Map<String, dynamic> toJson() => {
    'nickName': nickName,
    'introduction': introduction,
    'profileImage': profileImage,
  };
}