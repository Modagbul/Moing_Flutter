import 'dart:developer';
import 'package:flutter/material.dart';

import '../model/api_code/api_code.dart';
import '../model/response/alarm_settings_editor_response.dart';
import '../model/response/alarm_settings_response.dart';

class AlramSettingState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;

  bool isTotalAlarmOn = true;
  bool isNewUploadPushOn = true;
  bool isRemindPushOn = true;
  bool isFirePushOn = true;

  AlarmSettingsResponse? getAlarmSettings;
  AlarmSettingsEditorResponse? updateAlarmSettings;

  AlramSettingState({required this.context}) {
    initState();
  }

  void initState() {
    log('Instance "AlramSettingState" has been created');
    fetchAlarmSettings(); // 초기화 시 알람 설정 조회
  }

  /// 알람 설정 조회
  Future<void> fetchAlarmSettings() async {
    await apiCode.getAlarmSettings();
    notifyListeners();
  }

  void setAlarmSettings(bool newUploadPush, bool remindPush, bool firePush) {
    isNewUploadPushOn = newUploadPush;
    isRemindPushOn = remindPush;
    isFirePushOn = firePush;
    notifyListeners();
  }

  Future<void> saveAlarmSettings() async {
    try {
      AlarmSettingsEditor settingsToUpdate = AlarmSettingsEditor(
        newUploadPush: isNewUploadPushOn,
        firePush: isFirePushOn,
        remindPush: isRemindPushOn,
      );

      // 백엔드 API 호출
      var response = await apiCode.updateAlarmSettings(settingsToUpdate);

      // 결과에 따른 처리
      if (response?.isSuccess == true) {
        // 성공 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('알람 설정이 성공적으로 업데이트되었습니다.'))
        );
      } else {
        // 실패 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('알람 설정 업데이트에 실패했습니다.'))
        );
      }
    } catch (e) {
      log('Error updating alarm settings: $e');
      // 오류 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('알람 설정 업데이트 중 오류가 발생했습니다.'))
      );
    }
  }

  /// 알람 설정 수정
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
