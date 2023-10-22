class MakeTeamData {
  final String category;
  final String name;
  final String introduction;
  final String promise;
  final String profileImgUrl;

  MakeTeamData({required this.category, required this.name, required this.introduction,
    required this.promise, required this.profileImgUrl,});

  Map<String, dynamic> toJson() => {
    'category': category,
    'name': name,
    'introduction': introduction,
    'promise': promise,
    'profileImgUrl': profileImgUrl,
  };
}