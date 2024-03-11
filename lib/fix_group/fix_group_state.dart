import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moing_flutter/board/board_main_page.dart';
import 'package:moing_flutter/model/fix_group/fix_group_models.dart';
import 'package:moing_flutter/model/s3/presigned_url_models.dart';
import 'package:moing_flutter/repository/group_repository.dart';
import 'package:moing_flutter/repository/s3_repository.dart';
import 'package:moing_flutter/utils/alert_dialog/alert_dialog.dart';

class FixGroupState extends ChangeNotifier {
  final BuildContext context;
  final int teamId;
  final ViewUtil viewUtil = ViewUtil();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController introduceController = TextEditingController();

  String nameGroupText = '';
  String introduceTextCount = '(0/300)';

  /// 클릭 제어
  bool onLoading = false;
  bool isNameChanged = false;
  bool isIntroduceChanged = false;
  bool isImageChanged = false;
  bool isSuccess = true;
  bool _isGetPresignedUrlInProgress = false;
  bool _isFixTeamInProgress = false;

  // 수정 전 데이터 조회
  FixGroup group = FixGroup(name: '', introduce: '');

  /// 사진 업로드
  XFile? avatarFile;
  String? getProfileImageUrl;
  String extension = '';

  late final GroupRepository groupRepository;
  late final S3Repository s3repository;

  FixGroupState({required this.context, required this.teamId}) {
    initState();
  }

  void initState() async {
    groupRepository = GroupRepository();
    s3repository = S3Repository();
    await loadFixData(teamId);
    // nameController에 리스너 추가
    nameController.addListener(_onNameTextChanged);
  }

  Future<void> loadFixData(int teamId) async {
    FixGroup? group = await groupRepository.loadFixData(teamId);
    if(group != null) {
      this.group.name = group.name;
      this.group.introduce = group.introduce;
      this.group.getProfileImageUrl = group.getProfileImageUrl;
    }
    checkSave();
  }

  // nameController 텍스트 변경 감지
  void _onNameTextChanged() {
    // nameController.text를 사용하여 필요한 작업 수행
    nameGroupText = nameController.text;
  }

  @override
  void dispose() {
    log('Instance "GroupFinishExitState" has been removed');
    // 리스너 제거
    nameController.removeListener(_onNameTextChanged);

    nameController.dispose();
    introduceController.dispose();
    super.dispose();
  }

  // 이름 텍스트 필드 초기화 메소드
  void clearNameTextField() {
    nameController.clear();
    checkSave();
  }

  // 소개글 텍스트 필드 초기화 메소드
  void clearIntroduceTextField() {
    introduceController.clear();
    checkSave();
  }

  // 텍스트 필드 변경 감지 메소드
  void updateTextField() {
    isNameChanged = nameController.value.text != group.name ? true : false;
    isIntroduceChanged = introduceController.value.text != group.introduce ? true : false;
    checkSave();
  }

  /// 프로필 사진
  Future<void> imageUpload(BuildContext context) async {
    if (onLoading) return;
    onLoading = true;
    avatarFile = await groupRepository.imageUpload(context: context, viewUtil: viewUtil);

    if(avatarFile != null) {
      isImageChanged = true;
      checkSave();
    } else {
      isImageChanged = false;
    }

    onLoading = false;
    notifyListeners();
  }

  /// 저장 버튼 클릭
  void savePressed() async {
    print('저장 버튼 클릭');
    if (onLoading || _isFixTeamInProgress || _isGetPresignedUrlInProgress) return;
    onLoading = true;

    if (isSuccess) {
      if (avatarFile != null) {
        // 파일 확장자 얻기
        extension = avatarFile!.path.split(".").last;
        String fileExtension = '';
        switch(extension) {
          case 'jpg':
            fileExtension = 'JPG';
            break;
          case 'jpeg':
            fileExtension = 'JPEG';
            break;
          case 'png':
            fileExtension = 'PNG';
            break;
        }

        // presigned url 발급 성공 시
        String? imgUrl = await getPresignedUrl(fileExtension);
        if(imgUrl != null) {
          await fixTeamAPI(imgUrl);
        }
      } else {
        await fixTeamAPI(null);
      }
    }
    onLoading = false;
  }

  /// presignedURL 발급받기
  Future<String?> getPresignedUrl(String fileExtension) async {
    _isGetPresignedUrlInProgress = true;
    bool isSuccess = false;

    PreSignedUrl? url = await s3repository.getPreSignedUrl(fileExtension);
    isSuccess = url != null && url.presignedUrl != null && await uploadImageToS3(url.presignedUrl!, avatarFile!)
        ? true
        : false;

    _isGetPresignedUrlInProgress = false;
    return url?.imgUrl;
  }

  // S3에 이미지 업로드
  Future<bool> uploadImageToS3(String preSignedUrl, XFile file) async {
    bool isSuccess = await s3repository.uploadImageToS3(preSignedUrl, file, extension);
    return isSuccess;
  }

  // 소모임 수정 API 연동
  Future<void> fixTeamAPI(String? putProfileImageUrl) async {
    _isFixTeamInProgress = true;
    try {
      int? fixTeamId = await groupRepository.fixTeamAPI(
          teamId: teamId, isNameChanged: isNameChanged,
          isIntroduceChanged: isIntroduceChanged,
          isImageChanged: isImageChanged,
          fixName: isNameChanged ? nameController.text : null,
          fixIntroduce: isIntroduceChanged ? introduceController.text : null,
          fixProfileImgUrl: isImageChanged ? putProfileImageUrl : null
      );

      if(fixTeamId != null) {
        Navigator.pushReplacementNamed(
          context,
          BoardMainPage.routeName,
          arguments: {'teamId': fixTeamId, 'isSuccess': true},
        );
      }
    } finally {
      _isFixTeamInProgress = false;
    }
  }

  /// 저장 버튼 누를 수 있는지 확인
  void checkSave() {
    isSuccess = (isNameChanged || isIntroduceChanged || isImageChanged) ? true : false;
    notifyListeners();
  }
}
