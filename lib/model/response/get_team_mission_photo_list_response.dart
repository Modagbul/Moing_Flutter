class TeamMissionPhotoData {
  final int teamId;
  final List<String> photo;

  TeamMissionPhotoData({required this.teamId, required this.photo});

  factory TeamMissionPhotoData.fromJson(Map<String, dynamic> json) {
    List<String> photoList = List<String>.from(json['photo']);

    return TeamMissionPhotoData(
        teamId: json['teamId'] as int, photo: photoList);
  }

  @override
  String toString() {
    String returnString = 'TeamMissionPhotoData(teamId: $teamId, photo: ${photo.toString()}';
    return returnString;
  }
}
