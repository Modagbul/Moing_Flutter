import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MeetingPhotoState extends ChangeNotifier {
  final BuildContext context;
  /// 클릭 제어
  bool onLoading = false;
  /// 사진 업로드
  XFile? avatarFile;

  MeetingPhotoState({
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
      showAlertDialog(message: e.toString());
    } finally {
      onLoading = false;
      notifyListeners();
    }
  }

  // 오류 메세지 출력
  void showAlertDialog({required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          message,
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}