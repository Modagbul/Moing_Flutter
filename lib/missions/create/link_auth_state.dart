import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/make_group/component/warning_dialog.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';

import '../../const/color/colors.dart';

class LinkAuthState extends ChangeNotifier {
  final BuildContext context;
  final int teamId;
  final int missionId;
  String? selectedCategory;
  bool isSelected = false;
  bool onLoading = false;

  final TextEditingController textController = TextEditingController();

  LinkAuthState({
    required this.context,
    required this.teamId,
    required this.missionId,
  }) {
    initState();
  }

  void initState() {
    log('Instance "LinkAuthState" has been created');
  }

  @override
  void dispose() {
    textController.dispose();
    log('Instance "LinkAuthState" has been removed');
    super.dispose();
  }

  // 텍스트 필드 초기화 메소드
  void clearTextField() {
    textController.clear();
    notifyListeners();
  }

  void updateTextField() {
    isSelected = textController.text.isNotEmpty; // 텍스트 필드의 내용이 있으면 isSelected를 true로 설정
    notifyListeners();
  }

  bool isCategorySelected() {
    return isSelected; // selectedCategory의 값과 상관없이 isSelected가 true이면 true 반환
  }

  Color getNextButtonColor() {
    return isCategorySelected() ? grayScaleWhite : grayScaleGrey700;
  }

  Color getNextButtonTextColor() {
    return isCategorySelected() ? grayScaleGrey700 : grayScaleGrey500;
  }

  Future<void> submit() async {
    if(onLoading) return;
    onLoading = true;

    print(textController.text);

    final String apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive';
    final APICall call = APICall();
    Map<String, dynamic> data = {"status": 'COMPLETE', "archive": textController.text};

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        body: data,
        fromJson: (dataJson) => dataJson as Map<String, dynamic>,
      );

      notifyListeners();
      if(apiResponse.data != null) {
        Navigator.of(context).pop(true);
      }
      else {
        print('submit is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('링크 인증 실패: $e');
    }
    onLoading = false;
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
}
