import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/make_group/component/warning_dialog.dart';

class MyPageRevokeState extends ChangeNotifier {
  final BuildContext context;
  bool isSelected = false;
  String? selectedReason;
  final TextEditingController etcController = TextEditingController();
  final FocusNode etcFocus = FocusNode();

  MyPageRevokeState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "MyPageRevokeState" has been created');
    etcController.addListener(() {
      // 상태 업데이트
      notifyListeners();
    });
  }

  void dispose() {
    etcController.dispose();
  }

  void setReason(String reason) {
    selectedReason = reason;
    isSelected = true;
    notifyListeners();
  }

  void onClearButtonPressed() {
    etcController.clear();
    notifyListeners();
  }

  void revokePressed() {
    print('버튼 클릭');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // 맨 아래에 어떻게 붙이지
          backgroundColor: const Color(0xFF272727),
          insetPadding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 500,
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Image.asset(
                        'asset/image/danger_icon.png',// 이미지의 세로 크기를 100으로 설정
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Text(
                      '한번 더 확인해주세요!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12), // 텍스트와 버튼 사이 간격 조절
                    Container(
                      width: 216,
                      height: 72,
                      child: const Text(
                        'MOING을 탈퇴하면 현재까지 쌓아왔던 소모임 데이터를 복구할 수 없게 돼요. 탈퇴를 진행하시겠어요?',
                        style: TextStyle(
                          color: grayScaleGrey400,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // 텍스트와 버튼 사이 간격 조절
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // 버튼 중앙 정렬
                children: [
                  Container(
                    width: 150,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: grayScaleGrey600,
                        textStyle: const TextStyle(
                          color: grayScaleGrey550,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(
                            color: Color(0xff353538),
                          ),
                        ),
                        elevation: 0.0,
                      ),
                      onPressed: (){
                        print('취소');
                      },
                      child: const Text('나가기'),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 150,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: grayScaleWhite,
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(
                            color: Color(0xff353538),
                          ),
                        ),
                        elevation: 0.0,
                      ),
                      onPressed: (){
                        print('확인');
                      },
                      child: const Text(
                        '계속 진행하기',
                        style: TextStyle(
                          color: grayScaleBlack,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}
