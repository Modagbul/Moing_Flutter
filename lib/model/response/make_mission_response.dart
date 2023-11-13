class MakeMissionResponse {
  final int missionId;
  final String title;
  final String dueTo;
  final String rule;
  final String content;
  final int number;
  final String type;
  final String status;
  final String way;

  MakeMissionResponse({
    required this.missionId,
    required this.title,
    required this.dueTo,
    required this.rule,
    required this.content,
    required this.number,
    required this.type,
    required this.status,
    required this.way,
  });

  factory MakeMissionResponse.fromJson(Map<String, dynamic> json) {
    return MakeMissionResponse(
      missionId: json['missionId'],
      title: json['title'],
      dueTo: json['dueTo'],
      rule: json['rule'],
      content: json['content'],
      number: json['number'],
      type: json['type'],
      status: json['status'],
      way: json['way'],
    );
  }
}