import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/make_group/component/warning_dialog.dart';
import 'package:moing_flutter/missions/create/const/mission_create_text_list.dart';
import 'package:moing_flutter/missions/create/const/mission_modal_text_list.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/request/make_mission_request.dart';
import 'package:moing_flutter/utils/button/white_button.dart';

class MissionCreateState extends ChangeNotifier {
  final BuildContext context;
  final int teamId;
  final int repeatMissions;

  final APICall call = APICall();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final ruleController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  late FixedExtentScrollController scrollController;
  late FixedExtentScrollController timeScrollController;

  int missionCountIndex = 1;
  int timeCountIndex = 12;
  String apiUrl = '';

  TextStyle ts = const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 20, color: grayScaleGrey100);

  // 타이틀 포커스 여부
  bool isTitleFocused = false;

  // 반복미션 설정 여부
  bool isRepeatSelected = false;

  // 인증방식 선택 여부
  bool isMethodSelected = false;

  // 미션 추천 문구 리스트
  List<String> textList = [];
  // 미션 추천 문구
  String recommendText = '';

  String title = '';
  String content = '';
  String rule = '';
  String? selectedMethod;
  String formattedDate = '';
  String formattedTime = '';
  DateTime today = DateTime.now();

  MissionCreateState({
    required this.context,
    required this.teamId,
    required this.repeatMissions,
  }) {
    initState();
  }

  void initState() {
    log('Instance "MissionCreateState" has been created');
    print('teamId : $teamId, repeatMissions : $repeatMissions');
    getMissionRecommend();

    titleController.addListener(_onTitleTextChanged);
    titleFocusNode.addListener(onTitleFocusChanged);
    contentController.addListener(_onContentTextChanged);
    ruleController.addListener(_onRuleTextChanged);
    scrollController =
        FixedExtentScrollController(initialItem: missionCountIndex);
    timeScrollController =
        FixedExtentScrollController(initialItem: timeCountIndex);
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
    timeScrollController.dispose();
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

  /// 미션 추천 API
  void getMissionRecommend() async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/recommend';

    try {
      ApiResponse<String> apiResponse =
      await call.makeRequest<String>(
        url: apiUrl,
        method: 'GET',
        fromJson: (dataJson) => dataJson as String,
      );

      if (apiResponse.data != null) {
        print('mission 추천: ${apiResponse.data!}');
        switch(apiResponse.data!) {
          case 'SPORTS':
            textList = sportsList;
            recommendText = '건강한 몸을 만드는';
            break;
          case 'HABIT':
            textList = habitList;
            recommendText = '생활습관을 개선하는';
            break;
          case 'TEST':
            textList = testList;
            recommendText = '내일의 꿈을 위한';
            break;
          case 'STUDY':
            textList = studyList;
            recommendText = '좋은 학습을 도와주는';
            break;
          case 'READING':
            textList = readingList;
            recommendText = '좋은 독서를 도와주는';
            break;
          case 'ETC':
            textList = etcList;
            recommendText = '자기계발을 도와주는';
            break;
        }
        notifyListeners();
      }

      else {
        if(apiResponse.errorCode == 'J0003') {
          getMissionRecommend();
        }
        else {
          throw Exception('getMissionRecommend is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('나의 성공 횟수 조회 실패: $e');
    }
  }

  void showWarningDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WarningDialog(
              title: '미션 만들기를 멈추시겠어요?',
              content: '나가시면 입력하신 내용을 잃게 됩니다',
              onConfirm: () {
                Navigator.of(context).pop(true);
              },
              onCanceled: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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

  /// 마감 날짜 선택 시 IOS 날짜 선택 모달
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

  /// 마감 시간 선택 시 IOS 시간 선택 모달
  void timePicker() {
    timeScrollController.dispose();
    timeScrollController =
        FixedExtentScrollController(initialItem: timeCountIndex);

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        height: 300,  // 높이를 약간 조절하여 버튼에 공간을 확보
        child: Column(
          children: [
            Container(
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Picker 닫기
                    },
                  ),
                  CupertinoButton(
                    child: Text('확인'),
                    onPressed: () {
                      formattedTime = timeCountList[timeCountIndex].replaceAll("시", ":00");
                      notifyListeners();
                      Navigator.of(context).pop(); // Picker 닫기
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: timeScrollController,
                looping: true,
                itemExtent: 48,
                onSelectedItemChanged: (int index) {
                  timeCountIndex = index;
                  notifyListeners();
                },
                children: timeCountList
                    .map(
                      (item) => Center(
                    child: Text(
                      item,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
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
                        Text('#$recommendText', style: ts),
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
      int repeatMission;
      String way = '';
      String dueTo = '';
      switch(selectedMethod) {
        case '텍스트로 인증하기':
          way = 'TEXT';
          break;
        case '사진으로 인증하기':
          way = 'PHOTO';
          break;
        case '하이퍼링크로 인증하기':
          way = 'LINK';
          break;
      }

      // 반복 미션 변경한 경우
      if(isRepeatSelected) {
        repeatMission = missionCountIndex + 2;
        dueTo = '2099-12-31 00:00:00.000';
      } else {
        if(formattedDate.length < 1) {
          print('날짜를 선택해주세요...');
          return ;
        } else if (formattedTime.length < 1) {
          formattedTime = '12:00';
        }
        repeatMission = 1;
        dueTo = '$formattedDate $formattedTime:00.000';
      }

      apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions';


      // 단일 미션 시
      MakeMissionData data = MakeMissionData(
          title: title,
          dueTo: dueTo,
          rule: rule,
          content: content,
          number: repeatMission,
          type: isRepeatSelected == true ? 'REPEAT' : 'ONCE',
          way: way);

      print('------ 미션 생성 -----');
      print('repeatMission : $repeatMission');
      print('인증 방법 : $way');
      print('마감 시간 : $dueTo');
      print('타입 : ${data.type}');

      try {
        ApiResponse<Map<String, dynamic>> apiResponse =
        await call.makeRequest<Map<String, dynamic>>(
          url: apiUrl,
          method: 'POST',
          body: data.toJson(),
          fromJson: (data) => data as Map<String, dynamic>,
        );
        log('미션 생성 성공: ${apiResponse.data}');
        Navigator.of(context).pop(true);
      } catch (e) {
        log('미션 생성 실패: $e');
      }
    }
  }
}
