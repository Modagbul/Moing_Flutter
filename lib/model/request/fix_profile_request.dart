class FixProfile {
  final String? nickName;
  final String? introduction;
  final String? profileImage;

  FixProfile({this.nickName, this.introduction, this.profileImage});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (nickName != null) {
      json['nickName'] = nickName;
    }
    if (introduction != null) {
      json['introduction'] = introduction;
    }
    if (profileImage != null) {
      json['profileImage'] = profileImage;
    }
    return json;
  }

  @override
  String toString() {
    String str = 'FixProfileData(';

    if (nickName != null) {
      str += 'nickName: $nickName, ';
    }
    if (introduction != null) {
      str += 'introduction: $introduction, ';
    }
    if (profileImage != null) {
      str += 'profileImage: $profileImage, ';
    }
    if (str.endsWith(', ')) {
      str = str.substring(0, str.length - 2);
    }
    str += ')';
    return str;
  }
}