import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moing_flutter/dataSource/fix_group_data_source.dart';
import 'package:moing_flutter/model/fix_group/fix_group_models.dart';
import 'package:moing_flutter/utils/alert_dialog/alert_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class GroupRepository {
  final FixGroupDataSource fixGroupDataSource = FixGroupDataSource();

  /// FixGroupPage - 수정 전 소모임 데이터 조회
  Future<FixGroup?> loadFixData(int teamId) {
    return fixGroupDataSource.loadFixData(teamId);
  }

  /// FixGroupPage - 사진 업로드
  Future<XFile?> imageUpload({required BuildContext context, required ViewUtil viewUtil}) async {
    try {
      await Permission.photos.request();
      final XFile? assetFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      return assetFile;
    } catch (e) {
      print('그룹 프로필 사진 설정 실퍠 : ${e.toString()}');
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
    }
  }

  /// FixGroupPage - 수정 요청
  Future<int?> fixTeamAPI({
    required int teamId,
    required bool isNameChanged,
    required bool isIntroduceChanged,
    required bool isImageChanged,
    String? fixName,
    String? fixIntroduce,
    String? fixProfileImgUrl,
  }) async {
    return FixGroupDataSource().fixTeamAPI(
        teamId: teamId,
        isNameChanged: isNameChanged,
        isIntroduceChanged: isIntroduceChanged,
        isImageChanged: isImageChanged,
        fixName: fixName,
        fixIntroduce: fixIntroduce,
        fixProfileImgUrl: fixProfileImgUrl);
  }
}