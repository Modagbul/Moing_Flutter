import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moing_flutter/make_group/component/warning_dialog.dart';

class PhotoAuthState extends ChangeNotifier {
  final BuildContext context;
  XFile avatarFile;
  final textController = TextEditingController();
  bool isShowBalloon = true;

  PhotoAuthState({required this.context, required this.avatarFile});

  // 텍스트 필드 변경 감지 메소드
  void updateTextField() {
    if(textController.value.text.isNotEmpty) isShowBalloon = false;
    notifyListeners();
  }

  void changePhoto() async {
    final XFile? assetFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(assetFile != null) avatarFile = assetFile;
    notifyListeners();
  }

  /// 반복미션 종료 바텀모달
  Future<void> showEndRepeatModal({required BuildContext context}) async {
    var result = await showDialog(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WarningDialog(
              title: '인증을 멈추시겠어요?',
              content: '나가시면 입력하신 내용을 잃게 됩니다',
              onConfirm: () {
                Navigator.of(ctx).pop(false);
              },
              onCanceled: () {
                Navigator.of(ctx).pop(true);
              },
              leftText: '나가기',
              rightText: '계속 진행하기',
            ),
          ],
        );
      },
    );
    if(result) Navigator.of(context).pop();
  }

  void submit() {
    Navigator.of(context).pop({'avatarFile': avatarFile, 'contents': textController.value.text});
  }
}