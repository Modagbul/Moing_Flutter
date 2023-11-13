import 'dart:developer';
import 'package:flutter/material.dart';

import '../model/api_code/api_code.dart';
import '../model/response/alarm_settings_editor_response.dart';
import '../model/response/alarm_settings_response.dart';

class AlramSettingState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;

  AlarmSettingsResponse? getAlarmSettings;
  AlarmSettingsEditorResponse? updateAlarmSettings;

  AlramSettingState({required this.context}) {
    initState();
  }

  void initState() {
    log('Instance "AlramSettingState" has been created');
    fetchAlarmSettings(); // 초기화 시 알람 설정 조회
  }

  // 알람 설정 조회
  Future<void> fetchAlarmSettings() async {
    try {
      // API 호출 로직 구현 예시
      getAlarmSettings = await apiCode.getAlarmSettings();
      notifyListeners();
    } catch (e) {
      log('Error fetching alarm settings: $e');
    }
  }

  // 알람 설정 수정
  Future<void> changeAlarmSettings(bool newUploadPush, bool remindPush, bool firePush) async {
    try {
      // AlarmSettingsEditor 객체 생성
      AlarmSettingsEditor settingsToUpdate = AlarmSettingsEditor(
        newUploadPush: newUploadPush,
        firePush: firePush,
        remindPush: remindPush,
      );

      // API 호출 로직 구현 예시
      updateAlarmSettings = await apiCode.updateAlarmSettings(settingsToUpdate);
      fetchAlarmSettings(); // 변경 후 알람 설정 다시 조회
    } catch (e) {
      log('Error updating alarm settings: $e');
    }
  }


  @override
  void dispose() {
    log('Instance "AlramSettingState" has been removed');
    super.dispose();
  }
}
