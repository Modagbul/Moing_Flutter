class AlarmData {
  final int alarmHistoryId;
  final String type;
  final String path;
  final String idInfo;
  final String title;
  final String body;
  final String name;
  final bool isRead;
  final String createdDate;

  AlarmData({
    required this.alarmHistoryId,
    required this.type,
    required this.path,
    required this.idInfo,
    required this.title,
    required this.body,
    required this.name,
    required this.isRead,
    required this.createdDate,
  });

  factory AlarmData.fromJson(Map<String, dynamic> json) {
    return AlarmData(
      alarmHistoryId: json['alarmHistoryId'] as int,
      type: json['type'] as String,
      path: json['path'] as String,
      idInfo: json['idInfo'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      name: json['name'] as String,
      isRead: json['isRead'] as bool,
      createdDate: json['createdDate'] as String,
    );
  }
}
