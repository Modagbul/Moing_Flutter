class TeamFireLevelData {
  final int score;
  final int level;

  TeamFireLevelData({required this.score, required this.level});

  factory TeamFireLevelData.fromJson(Map<String, dynamic> json) {
    return TeamFireLevelData(
      score: json['score'] as int,
      level: json['level'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'level': level,
    };
  }
}
