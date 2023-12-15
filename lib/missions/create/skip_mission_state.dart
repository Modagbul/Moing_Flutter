import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/missions/component/skip_dialog.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';

import '../../const/color/colors.dart';

class SkipMissionState extends ChangeNotifier {
  final BuildContext context;
  final int teamId;
  final int missionId;

  String? selectedCategory;
  bool isSelected = false;
  bool onLoading = false;

  final TextEditingController textController = TextEditingController();

  SkipMissionState({
    required this.context,
    required this.teamId,
    required this.missionId,
  }) {
    initState();
  }

  void initState() {
    log('Instance "SkipMissionState" has been created');
  }

  @override
  void dispose() {
    textController.dispose();
    log('Instance "SkipMissionState" has been removed');
    super.dispose();
  }

  // 텍스트 필드 초기화 메소드
  void clearTextField() {
    textController.clear();
    notifyListeners();
  }

  // 텍스트 필드 변경 감지 메소드
  void updateTextField() {
    isSelected =
        textController.text.isNotEmpty; // 텍스트 필드의 내용이 있으면 isSelected를 true로 설정
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
    if (!isCategorySelected()) return;
    if(onLoading) return;
    onLoading = true;

    print(textController.text);
    final String apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive';
    final APICall call = APICall();
    Map<String, dynamic> data = {
      "status": 'SKIP',
      "archive": textController.text
    };

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        body: data,
        fromJson: (dataJson) => dataJson as Map<String, dynamic>,
      );

      if(apiResponse.data != null) {
        skipSuccess();
      }
      else {
        print('submit is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('텍스트 인증 실패: $e');
    }
    onLoading = false;
  }

  skipSuccess() async {
    showDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SkipDialog(
              title: '미션을 건너뛰었어요',
              content: '다음엔 꼭 모잉불을 키워주세요!',
              onConfirm: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    notifyListeners();
  }
}
