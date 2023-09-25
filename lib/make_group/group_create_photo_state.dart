import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moing_flutter/make_group/group_create_success_page.dart';
import 'package:moing_flutter/utils/alert_dialog/alert_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class GroupCreatePhotoState extends ChangeNotifier {
  final BuildContext context;
  final ViewUtil viewUtil = ViewUtil();
  /// 클릭 제어
  bool onLoading = false;
  /// 사진 업로드
  XFile? avatarFile;

  GroupCreatePhotoState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "MeetingPhotoState" has been created');
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

  // 만들기 버튼 클릭
  void makePressed() {
    Navigator.of(context).pushNamed(
      GroupCreateSuccessPage.routeName,
    );
  }
}