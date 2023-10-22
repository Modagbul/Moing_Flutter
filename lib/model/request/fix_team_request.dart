class FixTeam {
  final String name;
  final String introduction;
  final String profileImgUrl;

  FixTeam({required this.name, required this.introduction, required this.profileImgUrl});

  Map<String, dynamic> toJson() => {
    'name': name,
    'introduction': introduction,
    'profileImgUrl': profileImgUrl,
  };
}