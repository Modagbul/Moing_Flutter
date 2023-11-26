class AlarmSettingsResponse {
  final bool newUploadPush;
  final bool firePush;
  final bool remindPush;

  AlarmSettingsResponse({
    required this.newUploadPush,
    required this.firePush,
    required this.remindPush,
  });

  factory AlarmSettingsResponse.fromJson(Map<String, dynamic> json) {
    return AlarmSettingsResponse(
      newUploadPush: json['newUploadPush'] as bool,
      firePush: json['firePush'] as bool,
      remindPush: json['remindPush'] as bool,
    );
  }
}
