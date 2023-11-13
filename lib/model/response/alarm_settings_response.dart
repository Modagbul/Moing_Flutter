class AlarmSettingsResponse {
  bool isSuccess;
  String message;
  AlarmSettings data;

  AlarmSettingsResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory AlarmSettingsResponse.fromJson(Map<String, dynamic> json) {
    return AlarmSettingsResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: AlarmSettings.fromJson(json['data']),
    );
  }
}

class AlarmSettings {
  bool newUploadPush;
  bool firePush;
  bool remindPush;

  AlarmSettings({
    required this.newUploadPush,
    required this.firePush,
    required this.remindPush,
  });

  factory AlarmSettings.fromJson(Map<String, dynamic> json) {
    return AlarmSettings(
      newUploadPush: json['newUploadPush'],
      firePush: json['firePush'],
      remindPush: json['remindPush'],
    );
  }
}
