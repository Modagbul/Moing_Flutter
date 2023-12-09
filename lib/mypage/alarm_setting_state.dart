import 'dart:developer';
import 'package:flutter/material.dart';

import '../model/api_code/api_code.dart';
import '../model/response/alarm_settings_editor_response.dart';
import '../model/response/alarm_settings_response.dart';

class AlarmSettingState extends ChangeNotifier {
  final ApiCode apiCode = ApiCode();
  final BuildContext context;

  bool? isTotalAlarmOn;
  bool? isNewUploadPushOn;
  bool? isRemindPushOn;
  bool? isFirePushOn;

  AlarmSettingsResponse? getAlarmSettings;
  AlarmSettingsEditor? updateAlarmSettings;

  bool _isDisposed = false;

  bool isLoading = true;

  void initState() {
    log('Instance "AlarmSettingState" has been created');
    fetchAlarmSettings().then((_) {
      isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  AlarmSettingState({required this.context}) {
    fetchAlarmSettings();
    initState();
  }

  /// 알람 설정 조회
  Future<void> fetchAlarmSettings() async {
    if (_isDisposed) return;

    var response = await apiCode.getAlarmSettings();
    if (response != null && !_isDisposed) {

      isNewUploadPushOn = response.newUploadPush;
      isRemindPushOn = response.remindPush;
      isFirePushOn = response.firePush;
      isTotalAlarmOn = isNewUploadPushOn! && isRemindPushOn! && isFirePushOn!;

      notifyListeners();
    }
  }

  Future<void> saveAlarmSettings() async {
    try {
      await updateSingleAlarmSetting('isNewUploadPush', isNewUploadPushOn!);
      await updateSingleAlarmSetting('isRemindPush', isRemindPushOn!);
      await updateSingleAlarmSetting('isFirePush', isFirePushOn!);

      log('알람 설정이 성공적으로 업데이트되었습니다.');
      fetchAlarmSettings();
    } catch (e) {
      log('Error updating alarm settings: $e');
    }
  }

  Future<void> updateSingleAlarmSetting(String type, bool status) async {
    await apiCode.updateAlarmSettings(type, status);
  }

  // void changeAlarmSettings(bool newUploadPush, bool remindPush, bool firePush) {
  //   isNewUploadPushOn = newUploadPush;
  //   isRemindPushOn = remindPush;
  //   isFirePushOn = firePush;
  //
  //   isTotalAlarmOn = newUploadPush || remindPush || firePush;
  //   notifyListeners();
  // }

  void changeTotalAlarm(bool isTotalOn) {
    isTotalAlarmOn = isTotalOn;
    if (isTotalOn) {
      isNewUploadPushOn = true;
      isRemindPushOn = true;
      isFirePushOn = true;
    } else {
      isNewUploadPushOn = false;
      isRemindPushOn = false;
      isFirePushOn = false;
    }
    saveAlarmSettings();
    notifyListeners();
  }

  void changeAlarmSettings(bool newUploadPush, bool remindPush, bool firePush) {
    isNewUploadPushOn = newUploadPush;
    isRemindPushOn = remindPush;
    isFirePushOn = firePush;

    isTotalAlarmOn = newUploadPush && remindPush && firePush;
    saveAlarmSettings();
    notifyListeners();
  }

  void changeAllAlarms(bool isTotalOn) {
    isNewUploadPushOn = isRemindPushOn = isFirePushOn = isTotalOn;
    print('isNewUploadPushOn : $isNewUploadPushOn');
    print('isRemindPushOn : $isRemindPushOn');
    print('isFirePushOn : $isFirePushOn');

    notifyListeners();
  }

  bool changeNewAlarm(bool isChecked) {
    isNewUploadPushOn = isChecked;
    notifyListeners();
    return isNewUploadPushOn!;
  }

  bool changeRemindAlarm(bool isChecked) {
    isRemindPushOn = isChecked;
    notifyListeners();
    return isRemindPushOn!;
  }

  bool changeFireAlarm(bool isChecked) {
    isFirePushOn = isChecked;
    notifyListeners();
    return isFirePushOn!;
  }
}
