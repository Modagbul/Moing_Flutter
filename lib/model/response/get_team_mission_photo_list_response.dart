class TeamMissionPhotoData {
  final int teamId;
  final List<String> photo;

  TeamMissionPhotoData({required this.teamId, required this.photo});

  factory TeamMissionPhotoData.fromJson(Map<String, dynamic> json) {
    List<String> photoList = List<String>.from(json['photo']);

    return TeamMissionPhotoData(
        teamId: json['teamId'] as int, photo: photoList);
  }
}
