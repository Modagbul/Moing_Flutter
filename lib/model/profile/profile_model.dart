class ProfileData {
  String? profileImage;
  String nickName;
  String? introduction;

  ProfileData({
    required this.profileImage,
    required this.nickName,
    required this.introduction,
  });

  Map<String, dynamic> toJson() => {
        'profileImage': profileImage,
        'nickName': nickName,
        'introduction': introduction,
      };

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      profileImage: json['profileImage'],
      nickName: json['nickName'],
      introduction: json['introduction'],
    );
  }
}
