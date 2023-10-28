import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/request/profile_request.dart';

class ProfileSettingState extends ChangeNotifier {
  final BuildContext context;
  final ApiCode apiCode = ApiCode();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController resolutionController = TextEditingController();

  ProfileData profileData;

  ProfileSettingState({
    required this.context,
    required this.profileData,
  }) {
    initState();
  }

  void initState() {
    log('Instance "ProfileSettingState" has been created');
    nameController.text = profileData.nickName;
    resolutionController.text = profileData.introduction;
  }

  @override
  void dispose() {
    log('Instance "ProfileSettingState" has been removed');
    nameController.dispose();
    resolutionController.dispose();
    super.dispose();
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

  void pressSubmitButton(){
    apiCode.putMyPageProfileData(profileData: profileData);
  }
}
