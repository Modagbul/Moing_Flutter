class ProfileData {
  String? profileImg;
  String nickName;
  String? introduction;

  ProfileData({
    required this.profileImg,
    required this.nickName,
    required this.introduction,
  });

  Map<String, dynamic> toJson() => {
        'profileImg': profileImg,
        'nickName': nickName,
        'introduction': introduction,
      };

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      profileImg: json['profileImg'],
      nickName: json['nickName'],
      introduction: json['introduction'],
    );
  }
}
