import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/make_group/group_create_success_page.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/request/make_team_request.dart';
import 'package:moing_flutter/utils/alert_dialog/alert_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class GroupCreatePhotoState extends ChangeNotifier {
  final BuildContext context;
  final ViewUtil viewUtil = ViewUtil();
  final APICall call = APICall();

  final String category;
  final String name;
  final String introduction;
  final String promise;

  /// 클릭 제어
  bool onLoading = false;
  bool _isGetPresignedUrlInProgress = false;
  bool _isMakeTeamInProgress = false;

  /// 사진 업로드
  XFile? avatarFile;
  String extension = '';
  String presignedUrl = '';
  String imgUrl = '';

  final String defaultImageUrl = 'asset/icons/group_basic_image.svg';

  GroupCreatePhotoState({
    required this.context,
    required this.category,
    required this.name,
    required this.introduction,
    required this.promise,
  }) {
    initState();
  }

  void initState() {
    log('Instance "MeetingPhotoState" has been created');
  }

  /// 프로필 사진
  Future<void> imageUpload(BuildContext context) async {
    print('소모임 대표 사진 업로드하기');
    if (onLoading) return;
    try {
      onLoading = true;
      notifyListeners();
      await Permission.photos.request();
      final XFile? assetFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      avatarFile = assetFile;
    } catch (e) {
      print('소모임 대표 사진 업로드 실패 : ${e.toString()}');
      if(e.toString().contains('photo access')) {
        bool? isImagePermissioned = await viewUtil.showWarningDialog(
            context: context,
            title: '갤러리 접근 권한이 필요해요',
            content: '사진을 업로드하기 위해 갤러리 접근 권한이 필요해요.\n설정에서 갤러리 접근 권한을 허용해주세요',
            leftText: '취소하기',
            rightText: '허용하러 가기');

        if (isImagePermissioned != null && isImagePermissioned) {
          openAppSettings();
        }
      }
    } finally {
      onLoading = false;
      notifyListeners();
    }
  }

  // 만들기 버튼 클릭
  void makePressed() async {
    if (_isMakeTeamInProgress) return;
    if (_isGetPresignedUrlInProgress) return;

    String defaultPromise = "모임장 각오 제거";

    if (avatarFile == null) {
      imgUrl = defaultImageUrl;
      await makeTeam(defaultPromise); // 기본 이미지와 함께 그룹 생성
    }
    if (avatarFile != null) {
      // 파일 확장자 얻기
      extension = avatarFile!.path.split(".").last;
      String fileExtension = '';
      if (extension == 'jpg') {
        fileExtension = 'JPG';
      } else if (extension == 'jpeg') {
        fileExtension = 'JPEG';
      } else if (extension == 'png') {
        fileExtension = 'PNG';
      }

      // presigned url 발급 성공 시
      if (await getPresignedUrl(fileExtension)) {
        await makeTeam(defaultPromise);
      }
    }
  }

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
        print(apiResponse.data?.toString());
        presignedUrl = apiResponse.data?['presignedUrl'];
        imgUrl = apiResponse.data?['imgUrl'];

        await uploadImageToS3(presignedUrl, avatarFile!);
        return true;
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getPresignedUrl(fileExtension);
        } else {
          throw Exception(
              'getPresignedUrl is Null, error code : ${apiResponse.errorCode}');
        }
        return false;
      }
    } catch (e) {
      print('소모임 생성 실패: $e');
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

  // API 연동
  Future<void> makeTeam(String defaultPromise) async {
    _isMakeTeamInProgress = true;
    final String apiUrl = '${dotenv.env['MOING_API']}/api/team';

    String defaultPromise = "모임장 각오 제거";
    String finalPromise = promise.isEmpty ? defaultPromise : promise;

    MakeTeamData data = MakeTeamData(
      category: category,
      name: name,
      introduction: introduction,
      promise: finalPromise,
      profileImgUrl: imgUrl.isEmpty ? defaultImageUrl : imgUrl, // 에셋 이미지나 기본 이미지 사용
    );

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        body: data.toJson(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.data?['teamId'] != null) {
        print('소모임 생성 완료! : ${apiResponse.data?['teamId']}');
        // Navigator.of(context).pushNamed(
        //   GroupCreateSuccessPage.routeName,
        // );
        Navigator.pushNamedAndRemoveUntil(
          context,
          MainPage.routeName,
              (route) => false,
          arguments: 'new',
        );
      } else {
        if (apiResponse.errorCode == 'J0003') {
          makeTeam(defaultPromise);
        } else {
          throw Exception(
              'makeTeam is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      print('소모임 생성 실패: $e');
    } finally {
      _isMakeTeamInProgress = false;
    }
  }
}
