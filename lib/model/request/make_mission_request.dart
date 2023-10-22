class MakeMissionData {
  final String title;
  final String dueTo;
  final String rule;
  final String content;
  final int number;
  final String type;
  final String way;

  MakeMissionData({required this.title, required this.dueTo, required this.rule,
    required this.content, required this.number, required this.type, required this.way,});

  Map<String, dynamic> toJson() => {
    'title': title,
    'dueTo': dueTo,
    'rule': rule,
    'content': content,
    'number': number,
    'type': type,
    'way': way,
  };
}