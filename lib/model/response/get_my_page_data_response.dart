class MyPageData {
  final String? profileImage;
  final String nickName;
  final String? introduction;
  final List<String> categories;
  final List<TeamBlock> getMyPageTeamBlocks;

  MyPageData({
    required this.profileImage,
    required this.nickName,
    required this.introduction,
    required this.categories,
    required this.getMyPageTeamBlocks,
  });

  factory MyPageData.fromJson(Map<String, dynamic> json) {
    List<dynamic> teamBlocksJson = json['getMyPageTeamBlocks'];

    return MyPageData(
      profileImage: json['profileImage'],
      nickName: json['nickName'],
      introduction: json['introduction'],
      categories: List<String>.from(json['categories']),
      getMyPageTeamBlocks: List<TeamBlock>.from(teamBlocksJson
          .map((teamBlockJson) => TeamBlock.fromJson(teamBlockJson))),
    );
  }
}

class TeamBlock {
  final int teamId;
  final String teamName;
  final String category;
  final String profileImgUrl;

  TeamBlock({
    required this.teamId,
    required this.teamName,
    required this.category,
    required this.profileImgUrl,
  });

  factory TeamBlock.fromJson(Map<String, dynamic> json) {
    return TeamBlock(
      teamId: json['teamId'],
      teamName: json['teamName'],
      category: json['category'],
      profileImgUrl: json['profileImgUrl'],
    );
  }
}
