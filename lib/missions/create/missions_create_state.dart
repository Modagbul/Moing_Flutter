import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moing_flutter/config/amplitude_config.dart';
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
  final bool isLeader;

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

  // 미션 만들기 성공 여부
  bool isSuccess = false;

  // 오늘 날짜 선택 여부
  bool isPickedToday = false;
  bool onLoading = false;

  // 미션 추천 문구 리스트
  List<String> textList = [];

  // 당일 날짜와 그 이후 날짜를 위한 list
  List<String> timeList = [];

  // 미션 추천 문구
  String recommendText = '';

  String title = '';
  String content = '';
  String rule = '';
  String? selectedMethod;
  String formattedDate = '';
  String formattedTime = '';

  final FToast fToast = FToast();

  MissionCreateState({
    required this.context,
    required this.teamId,
    required this.repeatMissions,
    required this.isLeader,
  }) {
    initState();
  }

  void initState() async {
    log('Instance "MissionCreateState" has been created');
    print(
        'teamId : $teamId, repeatMissions : $repeatMissions, isLeader: $isLeader');
    await getMissionRecommend();

    titleController.addListener(_onTitleTextChanged);
    titleFocusNode.addListener(onTitleFocusChanged);
    contentController.addListener(_onContentTextChanged);
    ruleController.addListener(_onRuleTextChanged);
    scrollController =
        FixedExtentScrollController(initialItem: missionCountIndex);
    timeScrollController =
        FixedExtentScrollController(initialItem: timeCountIndex);

    fToast.init(context);
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
    checkAddition();
    notifyListeners();
  }

  void _onRuleTextChanged() {
    rule = ruleController.text;
    checkAddition();
    notifyListeners();
  }

  void onTitleFocusChanged() {
    isTitleFocused = titleFocusNode.hasFocus;
    notifyListeners();
  }

  void _onContentTextChanged() {
    content = contentController.text;
    checkAddition();
    notifyListeners();
  }

  void updateTextField() {
    notifyListeners();
  }

  void setTitle(String value) {
    titleController.text = value;
    checkAddition();
    notifyListeners();
  }

  // 이름 텍스트 필드 초기화 메소드
  void clearTitleTextField() {
    titleController.clear();
    checkAddition();
    notifyListeners();
  }

  // 소개글 텍스트 필드 초기화 메소드
  void clearContentTextField() {
    contentController.clear();
    checkAddition();
    notifyListeners();
  }

  void clearRuleTextField() {
    ruleController.clear();
    checkAddition();
    notifyListeners();
  }

  // 선택 변경하기
  void setRepeatSelected() {
    isRepeatSelected = !isRepeatSelected;
    checkAddition();
    notifyListeners();
  }

  // 인증 방식 여부
  void setMethod(String method) {
    selectedMethod = method;
    isMethodSelected = true;
    checkAddition();
    notifyListeners();
  }

  /// 미션 추천 API
  Future<void> getMissionRecommend() async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/recommend';

    try {
      ApiResponse<String> apiResponse = await call.makeRequest<String>(
        url: apiUrl,
        method: 'GET',
        fromJson: (dataJson) => dataJson as String,
      );

      if (apiResponse.data != null) {
        switch (apiResponse.data!) {
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
          default:
            textList = etcList;
            recommendText = '자기계발을 도와주는';
            break;
        }
        notifyListeners();
      } else {
        print(
            'getMissionRecommend is Null, error code : ${apiResponse.errorCode}');
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
          height: 340,
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
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: CupertinoPicker(
                  diameterRatio: 10000,
                  scrollController: scrollController,
                  itemExtent: 48,
                  onSelectedItemChanged: (int index) {
                    missionCountIndex = index;
                    checkAddition();
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
    if (onLoading) return;
    onLoading = true;
    DateTime now = DateTime.now();
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: now,
        maxTime: DateTime(now.year + 3, now.month, now.day), onConfirm: (date) {
      formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      isPickedToday = (now.year == date.year &&
              now.month == date.month &&
              now.day == date.day)
          ? true
          : false;

      // 만약 당일 날짜를 설정한 경우
      if (isPickedToday) {
        DateTime oneHourAgo = now.add(Duration(hours: 1));
        int afterOneHour = oneHourAgo.hour;
        timeCountIndex = afterOneHour;
        timeList = timeCountList.sublist(afterOneHour, 24);
        formattedTime = timeList[0].replaceAll("시", ":00");
      } else {
        timeList = List.from(timeCountList);
        timeCountIndex = 12;
        formattedTime = timeList[12].replaceAll("시", ":00");
      }
      checkAddition();
      notifyListeners();
    }, currentTime: DateTime.now(), locale: LocaleType.ko);
    onLoading = false;
  }

  /// 마감 시간 선택 시 IOS 시간 선택 모달
  void timePicker() {
    if (onLoading) return;
    onLoading = true;

    timeScrollController.dispose();
    timeScrollController =
        FixedExtentScrollController(initialItem: timeCountIndex);
    timeList = timeList.length < 1 ? List.from(timeCountList) : timeList;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        height: 300, // 높이를 약간 조절하여 버튼에 공간을 확보
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
                      /// 날짜 지정 안했을 때
                      if (formattedDate.length < 1) {
                        DateTime now = DateTime.now();
                        int currentHour = now.hour;
                        // 현재 시간이 선택한 시간보다 큰 경우
                        if (int.parse(
                                timeList[timeCountIndex].replaceAll("시", "")) <=
                            currentHour) {
                          DateTime tomorrow = now.add(Duration(days: 1));
                          formattedDate =
                              "${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}";
                        }
                      }
                      formattedTime =
                          timeList[timeCountIndex].replaceAll("시", ":00");
                      checkAddition();
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
                children: timeList
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
    onLoading = false;
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
                        Spacer(),
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
                              checkAddition();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  color: grayScaleGrey500),
                              child: Text(
                                textList[index],
                                style: bodyTextStyle.copyWith(
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

  /// 성공 조건인지 확인하기
  void checkAddition() {
    /// 반복 미션인 경우
    if (isRepeatSelected) {
      if (titleController.text.isNotEmpty &&
          contentController.text.isNotEmpty &&
          isMethodSelected) {
        // && ruleController.text.isNotEmpty
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    }

    /// 한번 미션인 경우
    else {
      /// TODO : formattedTime 설정 해줘야 함.
      if (titleController.text.isNotEmpty &&
          contentController.text.isNotEmpty &&
          formattedDate.length > 1 &&
          isMethodSelected) {
        //  && ruleController.text.isNotEmpty
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    }
    notifyListeners();
  }

  Future<void> submit() async {
    if (onLoading) return;
    onLoading = true;

    if (isSuccess) {
      int repeatMission;
      String way = '';
      String dueTo = '';
      switch (selectedMethod) {
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
      if (isRepeatSelected) {
        repeatMission = missionCountIndex + 1;
        dueTo = '2099-12-31 00:00:00.000';
      } else {
        if (formattedTime.length < 1) {
          formattedTime = '12:00';
        }
        repeatMission = 1;
        dueTo = '$formattedDate $formattedTime:00.000';
      }

      apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions';
      MakeMissionData data = MakeMissionData(
          title: title,
          dueTo: dueTo,
          rule: rule,
          content: content,
          number: repeatMission,
          type: isRepeatSelected == true ? 'REPEAT' : 'ONCE',
          way: way);

      try {
        ApiResponse<Map<String, dynamic>> apiResponse =
            await call.makeRequest<Map<String, dynamic>>(
          url: apiUrl,
          method: 'POST',
          body: data.toJson(),
          fromJson: (data) => data as Map<String, dynamic>,
        );
        log('미션 생성 성공: ${apiResponse.data}');

        // 한번 미션 생성 or 반복 미션 생성
        String? nickname = await AmplitudeConfig.analytics.getUserId();
        if (nickname == null) {
          isRepeatSelected == true
              ? AmplitudeConfig.analytics.logEvent("mission_repeat_make")
              : AmplitudeConfig.analytics.logEvent("mission_once_make");
        } else {
          isRepeatSelected == true
              ? AmplitudeConfig.analytics.logEvent("mission_repeat_make",
                  eventProperties: {
                      "mission_maker": nickname,
                      "mission_category": way
                    })
              : AmplitudeConfig.analytics.logEvent("mission_once_make",
                  eventProperties: {
                      "mission_maker": nickname,
                      "mission_category": way
                    });
        }

        Navigator.of(context).pop(true);
      } catch (e) {
        log('미션 생성 실패: $e');
      }
    }
    onLoading = false;

    String warningText = '미션이 등록되었어요.';

    if (warningText.isNotEmpty) {
      fToast.showToast(
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 51,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        warningText,
                        style: bodyTextStyle.copyWith(
                          color: grayScaleGrey700,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          toastDuration: const Duration(milliseconds: 3000),
          positionedToastBuilder: (context, child) {
            return Positioned(
              top: 114.0,
              left: 0.0,
              right: 0,
              child: child,
            );
          });
    }
  }
}
