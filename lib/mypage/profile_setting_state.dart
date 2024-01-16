import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/profile/profile_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/utils/alert_dialog/alert_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../const/color/colors.dart';
import '../const/style/text.dart';
import '../model/request/fix_profile_request.dart';
import '../model/response/get_my_page_data_response.dart';

class ProfileSettingState extends ChangeNotifier {
  final BuildContext context;
  final ViewUtil viewUtil = ViewUtil();
  final APICall call = APICall();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController introduceController = TextEditingController();

  MyPageData? myPageData;
  String introduceTextCount = '(0/300)';

  bool isNameChanged = false;
  bool isIntroduceChanged = false;
  bool isAvatarChanged = false;
  bool isNickNameOverlapped = false;
  bool isSubmit = false;

  /// 클릭 제어
  bool onLoading = false;
  bool _isGetPresignedUrlInProgress = false;
  bool _isFixProfileInProgress = false;

  /// 사진 업로드
  XFile? avatarFile;
  String? getProfileImageUrl;
  String putProfileImageUrl = '';
  String presignedUrl = '';
  String extension = '';

  ProfileData? profileData;

  final ApiCode apiCode = ApiCode();

  final FToast fToast = FToast();

  ProfileSettingState({
    required this.context,
  }) {
    initState();
  }

  void initState() async {
    await getProfileData();
    nameController.addListener(_onNameTextChanged);
    introduceController.addListener(_onIntroduceTextChanged);
  }

  Future<void> getProfileData() async {
    profileData = await apiCode.getProfileData();
    nameController.text = profileData?.nickName ?? '';
    introduceController.text = profileData?.introduction ?? '';
    notifyListeners();
  }

  // nameController 텍스트 변경 감지
  void _onNameTextChanged() {
    isNameChanged = profileData?.nickName != nameController.text;
    isNickNameOverlapped = false;
    checkSubmit();
    notifyListeners();
  }

  void _onIntroduceTextChanged() {
    isIntroduceChanged = profileData?.introduction != introduceController.text;
    checkSubmit();
    notifyListeners();
  }

  // 텍스트 필드 초기화 메소드
  void clearResolutionTextField() {
    introduceController.clear();
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
    checkSubmit();
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
    checkSubmit();
    notifyListeners();
  }

  void pressCloseButton() {
    Navigator.pop(context);
  }

  /// 프로필 사진
  Future<void> imageUpload(BuildContext context) async {
    if (onLoading) return;
    try {
      onLoading = true;
      await Permission.photos.request();
      final XFile? assetFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (assetFile != null) {
        avatarFile = assetFile;
        isAvatarChanged = true;
        checkSubmit();
      } else {
        isAvatarChanged = false;
      }
    } catch (e) {
      print('프로필 사진 업로드 실패 : ${e.toString()}');

      if(e.toString().contains('photo access')) {
        bool? isImagePermissioned = await viewUtil.showWarningDialog(
            context: context,
            title: '갤러리 접근 권한이 필요해요',
            content: '사진을 업로드하기 위해 갤러리 접근 권한이 필요해요.\n설정에서 갤러리 접근 권한을 허용해주세요',
            leftText: '취소하기',
            rightText: '허용하러 가기');

        if(isImagePermissioned != null && isImagePermissioned) {
          openAppSettings();
        }
      }
      isAvatarChanged = false;
    } finally {
      onLoading = false;
      notifyListeners();
    }
  }

  void checkSubmit() {
    if (isNameChanged || isIntroduceChanged || isAvatarChanged) {
      if (nameController.value.text.length > 0 ||
          introduceController.value.text.length > 0) {
        isSubmit = true;
      } else {
        isSubmit = false;
      }
    } else {
      isSubmit = false;
    }
    notifyListeners();
  }

  /// 저장 버튼 클릭
  void savePressed() async {
    try {
      if (onLoading) return;
      if (_isFixProfileInProgress) return;
      if (_isGetPresignedUrlInProgress) return;
      if(nameController.value.text.isEmpty || introduceController.value.text.isEmpty) return;
      if (!isAvatarChanged && !isNameChanged && !isIntroduceChanged) return;

      print('savePressed called');
      onLoading = true;
      // 이름, 소개글 또는 사진 변경이 있는지 확인
      if (isNameChanged ||
          isIntroduceChanged ||
          (isAvatarChanged && avatarFile != null)) {
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
    } catch (e) {
      print('수정 실패 : ${e.toString()}');
    } finally {
      onLoading = false;
    }
  }

  /// presignedURL 발급받기
  Future<bool> getPresignedUrl(String fileExtension) async {
    _isGetPresignedUrlInProgress = true;
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
        presignedUrl = apiResponse.data?['presignedUrl'];
        putProfileImageUrl = apiResponse.data?['imgUrl'];

        await uploadImageToS3(presignedUrl, avatarFile!);
        return true;
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getPresignedUrl(fileExtension);
        }
        return false;
      }
    } catch (e) {
      print('presigned url 발급 실패: $e');
      return false;
    } finally {
      _isGetPresignedUrlInProgress = false;
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
    _isFixProfileInProgress = true;

    final String apiUrl = '${dotenv.env['MOING_API']}/api/mypage/profile';
    try {
      FixProfile data = FixProfile(
          nickName: isNameChanged ? nameController.text : null,
          introduction: isIntroduceChanged ? introduceController.text : null,
          profileImage: isAvatarChanged ? putProfileImageUrl : null);

      print('프로필 수정 data : ${data.toString()}');
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'PUT',
        body: data.toJson(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess == true) {
        print('프로필 수정이 완료되었습니다.');
        Navigator.of(context).pop(true);

        String warningText = '프로필 수정이 완료되었어요.';

        if (warningText.isNotEmpty) {
          fToast.showToast(
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 51,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            warningText,
                            style: bodyTextStyle.copyWith(
                              color: grayScaleGrey700,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              toastDuration: const Duration(milliseconds: 3000),
              positionedToastBuilder: (context, child) {
                return Positioned(
                  top: 114.0,
                  left: 0.0,
                  right: 0,
                  child: child,
                );
              });
        }
      } else {
        String? errorCode = apiResponse.errorCode;
        if(errorCode != null && errorCode == 'AU0004') {
        print('닉네임 중복 발생!');
        isNickNameOverlapped = true;
        notifyListeners();
        }
      }
    } catch (e) {
      print('프로필 수정 실패: $e');
    } finally {
      _isFixProfileInProgress = false;
    }
  }
}
