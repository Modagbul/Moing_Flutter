class AlarmSettingsResponse {
  final bool newUploadPush;
  final bool firePush;
  final bool remindPush;
  final bool commentPush;

  AlarmSettingsResponse({
    required this.newUploadPush,
    required this.firePush,
    required this.remindPush,
    required this.commentPush,
  });

  factory AlarmSettingsResponse.fromJson(Map<String, dynamic> json) {
    return AlarmSettingsResponse(
      newUploadPush: json['newUploadPush'] as bool,
      firePush: json['firePush'] as bool,
      remindPush: json['remindPush'] as bool,
      commentPush: json['commentPush'] as bool,
    );
  }
}
