import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';

import '../../const/color/colors.dart';

class TextAuthState extends ChangeNotifier {
  final BuildContext context;
  final int teamId;
  final int missionId;
  String? selectedCategory;
  bool isSelected = false;
  bool onLoading = false;

  final TextEditingController textController = TextEditingController();

  TextAuthState({
    required this.context,
    required this.teamId,
    required this.missionId,
  }) {
    initState();
  }

  void initState() {
    log('Instance "TextAuthState" has been created');
    print('teamId : $teamId, missionId : $missionId');
  }

  @override
  void dispose() {
    textController.dispose();
    log('Instance "TextAuthState" has been removed');
    super.dispose();
  }

  // 텍스트 필드 초기화 메소드
  void clearTextField() {
    textController.clear();
    notifyListeners();
  }

  // 텍스트 필드 변경 감지 메소드
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

  void submit() async {
    if(onLoading) return;
    onLoading = true;

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
        if(apiResponse.errorCode == 'J0003') {
          submit();
        }
        else {
          throw Exception('Text submit is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('텍스트 인증 실패: $e');
    }

    onLoading = false;
  }
}
