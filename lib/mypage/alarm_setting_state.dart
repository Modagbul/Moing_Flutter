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
  bool? isCommentPushOn;

  AlarmSettingsResponse? getAlarmSettings;
  AlarmSettingsEditor? updateAlarmSettings;

  bool _isDisposed = false;

  bool isLoading = true;

  AlarmSettingState({required this.context}) {
    initState();
  }

  void initState() async {
    log('Instance "AlarmSettingState" has been created');
    await fetchAlarmSettings().then((_) {
      isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// 알람 설정 조회
  Future<void> fetchAlarmSettings() async {
    if (_isDisposed) return;

    var response = await apiCode.getAlarmSettings();
    if (response != null && !_isDisposed) {

      isNewUploadPushOn = response.newUploadPush;
      isRemindPushOn = response.remindPush;
      isFirePushOn = response.firePush;
      isCommentPushOn = response.commentPush;
      isTotalAlarmOn = isNewUploadPushOn! && isRemindPushOn! && isFirePushOn! && isCommentPushOn!;

      notifyListeners();
    }
  }

  /// 저장 버튼 클릭 시
  Future<void> saveAlarmSettings() async {
    try {
      print('TotalPush : $isTotalAlarmOn');
      print('isNewUploadPushOn : $isNewUploadPushOn');
      print('isRemindPushOn : $isRemindPushOn');
      print('isFirePushOn : $isFirePushOn');
      print('isCommentPushOn : $isCommentPushOn');

      await apiCode.updateAlarmSettings('isNewUploadPush', isNewUploadPushOn!);
      await apiCode.updateAlarmSettings('isRemindPush', isRemindPushOn!);
      await apiCode.updateAlarmSettings('isFirePush', isFirePushOn!);
      await apiCode.updateAlarmSettings('isCommentPush', isCommentPushOn!);

      print('알람 설정이 성공적으로 업데이트되었습니다.');
      await fetchAlarmSettings();
    } catch (e) {
      log('Error updating alarm settings: $e');
    }
  }

  /// 전체 불 변화
  void changeAllAlarms(bool isTotalOn) {
    isNewUploadPushOn = isRemindPushOn = isFirePushOn = isCommentPushOn = isTotalOn;
    print('isNewUploadPushOn : $isNewUploadPushOn');
    print('isRemindPushOn : $isRemindPushOn');
    print('isFirePushOn : $isFirePushOn');
    print('isCommentPushOn : $isCommentPushOn');
    checkAllAlarms();
  }

  /// 전체 ON/OFF 확인
  void checkAllAlarms() {
    if(isNewUploadPushOn! && isRemindPushOn! && isFirePushOn! && isCommentPushOn!) {
      isTotalAlarmOn = true;
    } else {
      isTotalAlarmOn = false;
    }
    print('isTotalAlarmOn : $isTotalAlarmOn');
    notifyListeners();
  }

  /// 각 알림 ON/OFF에 따라 함수 작동
  void alarmSettings({required String title, required bool isFixed}) {
    switch(title) {
      case '전체 알림':
        changeAllAlarms(isFixed);
        break;
      case '신규 업로드 알림':
        changeNewAlarm(isFixed);
        break;
      case '미션 리마인드 알림':
        changeRemindAlarm(isFixed);
        break;
      case '불 던지기 알림':
        changeFireAlarm(isFixed);
        break;
      case '댓글 알림':
        changeCommentAlarm(isFixed);
        break;
    }
  }

  void changeNewAlarm(bool isChecked) {
    isNewUploadPushOn = isChecked;
    print('신규 공지 알림 : $isNewUploadPushOn');
    checkAllAlarms();
    notifyListeners();
  }

  void changeRemindAlarm(bool isChecked) {
    isRemindPushOn = isChecked;
    print('미션 리마인드 알림 : $isNewUploadPushOn');
    checkAllAlarms();
    notifyListeners();
  }

  void changeFireAlarm(bool isChecked) {
    isFirePushOn = isChecked;
    print('불던지기 알림 : $isNewUploadPushOn');
    checkAllAlarms();
    notifyListeners();
  }
  void changeCommentAlarm(bool isChecked) {
    isCommentPushOn = isChecked;
    print('댓글 알림 : $isNewUploadPushOn');
    checkAllAlarms();
    notifyListeners();
  }
}
