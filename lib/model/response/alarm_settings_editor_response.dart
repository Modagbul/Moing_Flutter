class AlarmSettingsEditor {
  final bool newUploadPush;
  final bool firePush;
  final bool remindPush;

  AlarmSettingsEditor({
    required this.newUploadPush,
    required this.firePush,
    required this.remindPush,
  });

  factory AlarmSettingsEditor.fromJson(Map<String, dynamic> json) {
    return AlarmSettingsEditor(
      newUploadPush: json['newUploadPush'],
      firePush: json['firePush'],
      remindPush: json['remindPush'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newUploadPush': newUploadPush,
      'firePush': firePush,
      'remindPush': remindPush,
    };
  }
//   bool isSuccess;
//   String message;
//   AlarmSettingsEditor data;
//
//   AlarmSettingsEditorResponse({
//     required this.isSuccess,
//     required this.message,
//     required this.data,
//   });
//
//   factory AlarmSettingsEditorResponse.fromJson(Map<String, dynamic> json) {
//     return AlarmSettingsEditorResponse(
//       isSuccess: json['isSuccess'],
//       message: json['message'],
//       data: AlarmSettingsEditor.fromJson(json['data']),
//     );
//   }
// }
//
// class AlarmSettingsEditor {
//   bool newUploadPush;
//   bool firePush;
//   bool remindPush;
//
//   AlarmSettingsEditor({
//     required this.newUploadPush,
//     required this.firePush,
//     required this.remindPush,
//   });
//
//   factory AlarmSettingsEditor.fromJson(Map<String, dynamic> json) {
//     return AlarmSettingsEditor(
//       newUploadPush: json['newUploadPush'],
//       firePush: json['firePush'],
//       remindPush: json['remindPush'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'newUploadPush': newUploadPush,
//       'firePush': firePush,
//       'remindPush': remindPush,
//     };
//   }
}
