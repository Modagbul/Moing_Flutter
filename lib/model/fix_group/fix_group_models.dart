class FixGroup {
   String name;
   String introduce;
   String? getProfileImageUrl;

  FixGroup({
    required this.name,
    required this.introduce,
    this.getProfileImageUrl,
  });

  factory FixGroup.fromJson(Map<String, dynamic> json) {
    return FixGroup(
      name: json['name'],
      introduce: json['introduction'],
      getProfileImageUrl: json['profileImgUrl'],
    );
  }
}