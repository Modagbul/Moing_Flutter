import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moing_flutter/board/board_main_page.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/request/fix_team_request.dart';
import 'package:moing_flutter/utils/alert_dialog/alert_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class FixGroupState extends ChangeNotifier {
  final BuildContext context;
  final int teamId;
  final ViewUtil viewUtil = ViewUtil();
  final APICall call = APICall();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController introduceController = TextEditingController();

  String nameGroupText = '';
  String introduceTextCount='(0/300)';

  /// 클릭 제어
  bool onLoading = false;
  bool isNameChanged = false;
  bool isIntroduceChanged = false;
  bool isImageChanged = false;
  bool isSuccess = true;

  String name='';
  String introduce = '';

  /// 사진 업로드
  XFile? avatarFile;
  String? getProfileImageUrl;
  String putProfileImageUrl = '';
  String presignedUrl = '';
  String extension = '';

  FixGroupState({required this.context, required this.teamId}) {
    print('Instance "GroupFinishExitState" has been created');
    loadFixData(teamId);
    // nameController에 리스너 추가
    nameController.addListener(_onNameTextChanged);
  }

  void loadFixData(int teamId) async {
    print('teamId : $teamId');
    final String apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if(apiResponse.isSuccess == true) {
        name = nameController.text = apiResponse.data?['name'];
        introduce = introduceController.text = apiResponse.data?['introduction'];
        getProfileImageUrl = apiResponse.data?['profileImgUrl'];
        checkSave();
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
    // nameController.text를 사용하여 필요한 작업 수행
    nameGroupText = nameController.text;
    notifyListeners();
  }

  @override
  void dispose() {
    // 리스너 제거
    nameController.removeListener(_onNameTextChanged);

    nameController.dispose();
    introduceController.dispose();
    log('Instance "GroupFinishExitState" has been removed');
    super.dispose();
  }


  // 이름 텍스트 필드 초기화 메소드
  void clearNameTextField() {
    nameController.clear();
    checkSave();
    notifyListeners();
  }

  // 소개글 텍스트 필드 초기화 메소드
  void clearIntroduceTextField() {
    introduceController.clear();
    checkSave();
    notifyListeners();
  }

  // 텍스트 필드 변경 감지 메소드
  void updateTextField() {
    isNameChanged = nameController.value.text != name ? true : false;
    isIntroduceChanged= introduceController.value.text != introduce ? true : false;
    checkSave();
    notifyListeners();
  }

  /// 프로필 사진
  Future<void> imageUpload(BuildContext context) async {
    if (onLoading) return;
    try {
      onLoading = true;
      await Permission.photos.request();
      final XFile? assetFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      avatarFile = assetFile;
      isImageChanged = true;
      checkSave();
    } catch (e) {
      print(e.toString());
      viewUtil.showAlertDialog(context: context, message: e.toString());
      isImageChanged = false;
    } finally {
      onLoading = false;
      notifyListeners();
    }
  }

  /// 저장 버튼 클릭
  void savePressed() async {
    print('저장 버튼 클릭');
    if(onLoading) return ;
    onLoading = true;

    if(isSuccess) {
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
          await fixTeamAPI();
        }
      }
      else {
        await fixTeamAPI();
      }
    }
    onLoading = false;
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

  // 소모임 수정 API 연동
  Future<void> fixTeamAPI() async {
    final String apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId';
    try {
      FixTeam data = FixTeam(
          name: isNameChanged ? nameController.text : null,
          introduction: isIntroduceChanged ? introduceController.text : null,
          profileImgUrl: isImageChanged ? putProfileImageUrl : null);

      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'PUT',
        body: data.toJson(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.isSuccess == true) {
        // 목표보드 화면으로 이동
        int fixTeamId = apiResponse.data?['teamId'];
        Navigator.pushReplacementNamed(
          context,
          BoardMainPage.routeName,
          arguments: {'teamId': fixTeamId, 'isSuccess': true},
        );
      } else {
        print('에러 발생..');
      }
    } catch (e) {
      print('소모임 수정 실패: $e');
    }
  }

  /// 저장 버튼 누를 수 있는지 확인
  void checkSave() {
    isSuccess = (isNameChanged || isIntroduceChanged || isImageChanged)
    ? true : false;
    notifyListeners();
  }
}