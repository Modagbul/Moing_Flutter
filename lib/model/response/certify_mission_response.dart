class MissionArchive {
  final int archiveId;
  final String archive;
  final DateTime createdDate;
  final String status;  // Consider using an enum for "COMPLETE" and "SKIP"
  final int count;
  final bool heartStatus;  // Assuming it's a boolean based on "[True/False]"
  final int hearts;

  MissionArchive({
    required this.archiveId,
    required this.archive,
    required this.createdDate,
    required this.status,
    required this.count,
    required this.heartStatus,
    required this.hearts,
  });

  factory MissionArchive.fromJson(Map<String, dynamic> json) {
    return MissionArchive(
      archiveId: json['archiveId'],
      archive: json['archive'],
      createdDate: DateTime.parse(json['createdDate']),
      status: json['status'],
      count: json['count'],
      heartStatus: json['heartStatus'] == 'True',  // Convert string to bool
      hearts: json['hearts'],
    );
  }
}