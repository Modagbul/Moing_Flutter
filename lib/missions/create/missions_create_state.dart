import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/make_group/component/warning_dialog.dart';
import 'package:moing_flutter/utils/button/white_button.dart';

class MissionCreateState extends ChangeNotifier {
  final BuildContext context;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final ruleController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  late FixedExtentScrollController scrollController;

  int missionCountIndex = 1;

  TextStyle ts = const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 20, color: grayScaleGrey100);

  // 타이틀 포커스 여부
  bool isTitleFocused = false;

  // 반복미션 설정 여부
  bool isRepeatSelected = false;

  // 인증방식 선택 여부
  bool isMethodSelected = false;

  final List<String> textList = [
    '매일 물 2L 마시기',
    '매일 아침 이불정리하기',
    '오전 7시 기상 인증하기',
    '모닝페이지 작성하기',
    '하루 계획 세우기',
    '일어나자마자 양치하기',
    '휴대폰 6시간 이하 쓰기',
  ];

  final List<String> missionCountList = [
    '주 2회',
    '주 3회',
    '주 4회',
    '주 5회',
    '주 6회',
    '주 7회',
  ];

  String title = '';
  String content = '';
  String rule = '';
  String? selectedMethod;
  String formattedDate = '';
  String formattedTime = '';
  DateTime today = DateTime.now();

  /// TODO : 수정 예정
  int repeatMission = 1;

  MissionCreateState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "MissionCreateState" has been created');
    titleController.addListener(_onTitleTextChanged);
    titleFocusNode.addListener(onTitleFocusChanged);
    contentController.addListener(_onContentTextChanged);
    ruleController.addListener(_onRuleTextChanged);
    scrollController =
        FixedExtentScrollController(initialItem: missionCountIndex);
  }

  @override
  void dispose() {
    log('Instance "MissionCreateState" has been removed');
    titleController.removeListener(_onTitleTextChanged);
    contentController.removeListener(_onContentTextChanged);
    ruleController.removeListener(_onRuleTextChanged);
    titleFocusNode.removeListener(onTitleFocusChanged);

    titleController.dispose();
    contentController.dispose();
    ruleController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _onTitleTextChanged() {
    title = titleController.text;
    notifyListeners();
  }

  void _onRuleTextChanged() {
    rule = ruleController.text;
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

  void clearRuleTextField() {
    ruleController.clear();
    notifyListeners();
  }

  // 선택 변경하기
  void setRepeatSelected() {
    isRepeatSelected = !isRepeatSelected;
    notifyListeners();
  }

  void setMethod(String method) {
    selectedMethod = method;
    isMethodSelected = true;
    notifyListeners();
  }

  void showWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WarningDialog(
              title: '미션 만들기를 끝내시겠어요?',
              content: '나가시면 입력하신 내용을 잃게 됩니다',
              onConfirm: () {
                Navigator.of(context).pop(true);
              },
              onCanceled: () {
                // Navigator.pushNamedAndRemoveUntil(
                //   context,
                //   MainPage.routeName,
                //       (route) => false,
                // );
              },
              leftText: '나가기',
              rightText: '계속 진행하기',
            ),
          ],
        );
      },
    );
  }

  /// 인증 횟수 클릭 시 생기는 바텀 모달
  void openCertificateCountModal() {
    scrollController.dispose();
    scrollController =
        FixedExtentScrollController(initialItem: missionCountIndex);

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
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 34),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('인증 횟수', style: ts),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.close,
                          size: 28, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 20),
                child: Text(
                  '주 1회는 일반 미션으로 가능해요',
                  style: bodyTextStyle.copyWith(
                    color: grayScaleGrey400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: CupertinoPicker(
                  diameterRatio: 10000,
                  scrollController: scrollController,
                  itemExtent: 48,
                  onSelectedItemChanged: (int index) {
                    missionCountIndex = index;
                    notifyListeners();
                  },
                  children: missionCountList
                      .map(
                        (item) => Center(
                          child: Text(
                            item,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: grayScaleGrey100),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Spacer(),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 32.0, left: 20, right: 20),
                child: WhiteButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: '선택 완료'),
              ),
            ],
          ),
        );
      },
    );
  }

  // 마감 날짜 선택 시 IOS 날짜 선택 모달
  void datePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 1, 1),
        maxTime: DateTime(2024, 12, 31), onConfirm: (date) {
      today = date;
      formattedDate =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      notifyListeners();
    }, currentTime: DateTime.now(), locale: LocaleType.ko);
  }

  void timePicker() {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (time) {
        formattedTime = '${time.hour.toString().padLeft(2, '0')}:00';
        notifyListeners();
      },
      currentTime: DateTime.now(),
      locale: LocaleType.ko,
    );
  }

  /// 미션 제목 시 생기는 바텀 모달
  void openBottomModal() {
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
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
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

  void submit() async {
    if (isMethodSelected &&
        titleController.text.isNotEmpty &&
        contentController.text.isNotEmpty &&
        ruleController.text.isNotEmpty) {
      print('미션 제목 : $title');
      print('미션 내용 : $content');
      print('인증 규칙 : $rule');
      print('마감 날짜 : $formattedDate');
    }
  }
}
