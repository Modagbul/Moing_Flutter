class FixTeam {
  String? name;
  String? introduction;
  String? profileImgUrl;

  FixTeam({this.name, this.introduction, this.profileImgUrl});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (name != null) {
      json['name'] = name;
    }
    if (introduction != null) {
      json['introduction'] = introduction;
    }
    if (profileImgUrl != null) {
      json['profileImgUrl'] = profileImgUrl;
    }
    return json;
  }
}