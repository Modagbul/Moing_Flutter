import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/profile/profile_model.dart';

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moing_flutter/board/board_main_page.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/request/fix_team_request.dart';
import 'package:moing_flutter/mypage/my_page_screen.dart';
import 'package:moing_flutter/mypage/setting_page.dart';
import 'package:moing_flutter/utils/alert_dialog/alert_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../model/request/fix_profile_request.dart';
import '../model/response/get_my_page_data_response.dart';

class ProfileSettingState extends ChangeNotifier {
  final BuildContext context;
  final ViewUtil viewUtil = ViewUtil();
  final APICall call = APICall();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController introduceController = TextEditingController();
  final TextEditingController resolutionController = TextEditingController();

  MyPageData? myPageData;

  String nameGroupText = '';
  String introduceTextCount='(0/300)';

  bool isNameChanged = false;
  bool isIntroduceChanged = false;
  bool isAvatarChanged = false;

  /// 클릭 제어
  bool onLoading = false;
  /// 사진 업로드
  XFile? avatarFile;
  String? getProfileImageUrl;
  String putProfileImageUrl = '';
  String presignedUrl = '';
  String extension = '';

  ProfileData? profileData;

  final ApiCode apiCode = ApiCode();

  ProfileSettingState({
    required this.context,
  }) {
    getProfileData();
    nameController.addListener(_onNameTextChanged);
    introduceController.addListener(_onIntroduceTextChanged);
  }

  void getProfileData() async {
    profileData = await apiCode.getProfileData();
    nameController.text = profileData?.nickName ?? '';
    introduceController.text = profileData?.introduction ?? '';
    notifyListeners();
  }

  void loadFixData(int teamId) async {
    print('teamId : $teamId');
    final String apiUrl = '${dotenv.env['MOING_API']}/api/mypage/profile';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if(apiResponse.isSuccess == true) {
        nameController.text = apiResponse.data?['name'];
        introduceController.text = apiResponse.data?['introduction'];
        getProfileImageUrl = apiResponse.data?['profileImage'];
      }
      else {
        if(apiResponse.errorCode == 'J0003') {
          loadFixData(teamId);
        }
        else {
          throw Exception('loadFixData is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      print('소모임 생성 실패: $e');
    }
  }

  // nameController 텍스트 변경 감지
  void _onNameTextChanged() {
    nameGroupText = nameController.text;
    isNameChanged = profileData?.nickName != nameController.text;
    print('isNameChanged: $isNameChanged');
    notifyListeners();
  }

  void _onIntroduceTextChanged() {
    isIntroduceChanged = profileData?.introduction != introduceController.text;
    print('isIntroduceChanged: $isIntroduceChanged');
    notifyListeners();
  }

  // 텍스트 필드 초기화 메소드
  void clearResolutionTextField() {
    resolutionController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    introduceController.dispose();

    nameController.removeListener(_onNameTextChanged);
    introduceController.removeListener(_onIntroduceTextChanged);
    log('Instance "GroupFinishExitState" has been removed');
    super.dispose();
  }


  // 이름 텍스트 필드 초기화 메소드
  void clearNameTextField() {
    nameController.clear();
    notifyListeners();
  }

  // 소개글 텍스트 필드 초기화 메소드
  void clearIntroduceTextField() {
    isIntroduceChanged = profileData?.introduction != introduceController.text;
    introduceController.clear();
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

/// 프로필 사진
  Future<void> imageUpload(BuildContext context) async {
    if (onLoading) return;
    try {
      onLoading = true;
      notifyListeners();
      await Permission.photos.request();
      final XFile? assetFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (assetFile != null) {
        avatarFile = assetFile;
        isAvatarChanged = true; // 여기에 플래그를 설정합니다.
      }

    } catch (e) {
      print(e.toString());
      viewUtil.showAlertDialog(context: context, message: e.toString());
    } finally {
      onLoading = false;
      notifyListeners();
    }
  }

  /// 저장 버튼 클릭
  void savePressed() async {
    print('savePressed called');

    // 이름, 소개글 또는 사진 변경이 있는지 확인
    if (isNameChanged || isIntroduceChanged || (isAvatarChanged && avatarFile != null)) {
      // 파일 확장자 얻기 (사진이 변경된 경우에만)
      if (isAvatarChanged && avatarFile != null) {
        extension = avatarFile!.path.split('.').last;
        String fileExtension = '';
        if (extension == 'jpg') {
          fileExtension = 'JPG';
        } else if (extension == 'jpeg') {
          fileExtension = 'JPEG';
        } else if (extension == 'png') {
          fileExtension = 'PNG';
        }

        // presigned url 발급 및 프로필 수정 API 호출
        if (await getPresignedUrl(fileExtension)) {
          await fixProfileAPI();
        }
      } else {
        // 사진 변경이 없는 경우에도 프로필 수정 API 호출
        await fixProfileAPI();
      }
    } else {
      print('No changes to save');
    }
  }



  /// presignedURL 발급받기
  Future<bool> getPresignedUrl(String fileExtension) async {
    try {
      final String apiUrl = '${dotenv.env['MOING_API']}/api/image/presigned';
      Map<String, dynamic> data = {
        'imageFileExtension': fileExtension,
      };

      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        body: data,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess == true) {
        print(apiResponse.data?.toString());
        presignedUrl = apiResponse.data?['presignedUrl'];
        putProfileImageUrl = apiResponse.data?['imgUrl'];

        await uploadImageToS3(presignedUrl, avatarFile!);
        return true;
      } else {
        if(apiResponse.errorCode == 'J0003') {
          getPresignedUrl(fileExtension);
        }
        else {
          throw Exception('getPresignedUrl is Null, error code : ${apiResponse.errorCode}');
        }
        return false;
      }
    } catch (e) {
      print('소모임 생성 실패: $e');
      return false;
    }
  }

  // S3에 이미지 업로드
  Future<void> uploadImageToS3(String presignedUrl, XFile file) async {
    // 이미지 파일을 바이트로 읽기
    var imageBytes = await file.readAsBytes();

    // HTTP PUT 요청을 사용하여 S3에 업로드
    var response = await http.put(
      Uri.parse(presignedUrl),
      headers: {
        "Content-Type": "image/$extension",
      },
      body: imageBytes,
    );

    if (response.statusCode == 200) {
      print('S3에 업로드 성공!');
    } else {
      print('S3에 업로드 실패: ${response.statusCode}.');
      print('S3에 업로드 실패 사유 : ${response.reasonPhrase}');
    }
  }

  // 프로필 수정 API 연동
  Future<void> fixProfileAPI() async {
    final String apiUrl = '${dotenv.env['MOING_API']}/api/mypage/profile';
      try {
        FixProfile data = FixProfile(
            nickName: isNameChanged ? nameController.text : null,
            introduction: isIntroduceChanged ? introduceController.text : null,
            profileImage: isAvatarChanged ? putProfileImageUrl : null);

        ApiResponse<Map<String, dynamic>> apiResponse =
        await call.makeRequest<Map<String, dynamic>>(
          url: apiUrl,
          method: 'PUT',
          body: data.toJson(),
          fromJson: (json) => json as Map<String, dynamic>,
        );

        if(apiResponse.isSuccess == true) {
          Navigator.of(context).pop(true);
        }
        else {
          if(apiResponse.errorCode == 'J0003') {
            fixProfileAPI();
          }
          else {
            throw Exception('fixProfileAPI is Null, error code : ${apiResponse.errorCode}');
          }
        }
      } catch (e) {
        print('프로필 수정 실패: $e');
      }
  }
}

