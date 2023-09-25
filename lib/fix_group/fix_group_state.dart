import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moing_flutter/utils/alert_dialog/alert_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class FixGroupState extends ChangeNotifier {
  final BuildContext context;
  final ViewUtil viewUtil = ViewUtil();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController introduceController = TextEditingController();
  String introduceTextCount='(0/300)';
  /// 클릭 제어
  bool onLoading = false;
  /// 사진 업로드
  XFile? avatarFile;

  FixGroupState({required this.context}) {
    print('Instance "GroupFinishExitState" has been created');
  }

  @override
  void dispose() {
    nameController.dispose();
    introduceController.dispose();
    log('Instance "GroupFinishExitState" has been removed');
    super.dispose();
  }

  // 텍스트 필드 초기화 메소드
  void clearNameTextField() {
    nameController.clear();
    notifyListeners();
  }

  // 텍스트 필드 변경 감지 메소드
  void updateTextField() {
    notifyListeners();
  }

  void updateTextCountField() {
    int textCount = introduceController.text.length;
    introduceTextCount = '($textCount/300)';
    notifyListeners();
  }

  /// 프로필 사진
  Future<void> imageUpload(BuildContext context) async {
    if (onLoading) return;
    try {
      onLoading = true;
      notifyListeners();
      await Permission.photos.request();
      final XFile? assetFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      avatarFile = assetFile;
    } catch (e) {
      print(e.toString());
      viewUtil.showAlertDialog(context: context, message: e.toString());
    } finally {
      onLoading = false;
      notifyListeners();
    }
  }
}