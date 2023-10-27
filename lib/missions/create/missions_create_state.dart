import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';

class MissionCreateState extends ChangeNotifier {
  final BuildContext context;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  bool isTitleFocused = false;

  final List<String> textList = [
    '매일 물 2L 마시기',
    '매일 아침 이불정리하기',
    '오전 7시 기상 인증하기',
    '모닝페이지 작성하기',
    '하루 계획 세우기',
    '일어나자마자 양치하기',
    '휴대폰 6시간 이하 쓰기',
  ];

  String title = '';
  String content = '';

  MissionCreateState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "MissionCreateState" has been created');
    titleController.addListener(_onTitleTextChanged);
    titleFocusNode.addListener(onTitleFocusChanged);
  }

  @override
  void dispose() {
    log('Instance "MissionCreateState" has been removed');
    titleController.removeListener(_onTitleTextChanged);
    contentController.removeListener(_onContentTextChanged);
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _onTitleTextChanged() {
    title = titleController.text;
    notifyListeners();
  }

  void onTitleFocusChanged() {
    isTitleFocused = titleFocusNode.hasFocus;
    notifyListeners();
  }

  void _onContentTextChanged() {
    content = contentController.text;
    notifyListeners();
  }

  void updateTextField() {
    notifyListeners();
  }

  void setTitle(String value) {
    titleController.text = value;
    notifyListeners();
  }

  // 이름 텍스트 필드 초기화 메소드
  void clearTitleTextField() {
    titleController.clear();
    notifyListeners();
  }

  // 소개글 텍스트 필드 초기화 메소드
  void clearContentTextField() {
    contentController.clear();
    notifyListeners();
  }

  void openBottomModal() {
    TextStyle ts = const TextStyle(
        fontWeight: FontWeight.w700, fontSize: 20, color: grayScaleGrey100);
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
              width: double.infinity,
              height: 391,
              decoration: const BoxDecoration(
                color: grayScaleGrey600,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 34),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('#생활습관을 개선하는', style: ts),
                        Text(' 인증미션 추천',
                            style: ts.copyWith(color: grayScaleGrey400)),
                        const SizedBox(width: 44),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(Icons.close,
                                size: 28, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    GridView.builder(
                        itemCount: textList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 172 / 46,
                          mainAxisSpacing: 9,
                          crossAxisSpacing: 16,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setTitle(textList[index]);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  color: grayScaleGrey500),
                              child: Text(
                                textList[index],
                                style: contentTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: grayScaleGrey300,
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ));
        });
  }
}
