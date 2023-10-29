import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/profile/profile_model.dart';

class ProfileSettingState extends ChangeNotifier {
  final BuildContext context;
  final ApiCode apiCode = ApiCode();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController resolutionController = TextEditingController();

  ProfileData? profileData;

  ProfileSettingState({
    required this.context,
  }) {
    initState();
    getProfileData();
  }

  void initState() {
    log('Instance "ProfileSettingState" has been created');
  }

  @override
  void dispose() {
    log('Instance "ProfileSettingState" has been removed');
    nameController.dispose();
    resolutionController.dispose();
    super.dispose();
  }

  void getProfileData() async {
    profileData = await apiCode.getProfileData();
    nameController.text = profileData?.nickName ?? '';
    resolutionController.text = profileData?.introduction ?? '';
    notifyListeners();
  }

  // 텍스트 필드 초기화 메소드
  void clearNameTextField() {
    nameController.clear();
    notifyListeners();
  }

  // 텍스트 필드 초기화 메소드
  void clearResolutionTextField() {
    resolutionController.clear();
    notifyListeners();
  }

  // 텍스트 필드 변경 감지 메소드
  void updateTextField() {
    notifyListeners();
  }

  void pressCloseButton() {
    Navigator.pop(context);
  }

  void pressSubmitButton() {
    if(profileData != null){
      apiCode.putProfileData(profileData: profileData!);
    }
  }
}
