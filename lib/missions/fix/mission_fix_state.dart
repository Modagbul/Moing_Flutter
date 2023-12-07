import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:moing_flutter/missions/create/const/mission_create_text_list.dart';
import 'package:moing_flutter/missions/fix/mission_fix_data.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';

class MissionFixState extends ChangeNotifier {
  final BuildContext context;
  final MissionFixData fixData;
  final TextEditingController contentController = TextEditingController();
  final TextEditingController ruleController = TextEditingController();
  late FixedExtentScrollController timeScrollController;
  int timeCountIndex = 12;

  // 당일 날짜와 그 이후 날짜를 위한 list
  List<String> timeList = [];

  String formattedDate = '';
  String formattedTime = '';
  String dueTo = '';
  // 오늘 날짜 선택 여부
  bool isPickedToday = false;
  // 미션 내용 변화 여부
  bool isContentChanged = false;
  bool isRuleChanged = false;

  // 완료 버
  bool checkSubmit = true;

  MissionFixState({
    required this.context,
    required this.fixData,
  }) {
    initState();
  }

  void initState() {
    DateTime dueTo = DateTime.parse(fixData.missionDueto);
    formattedDate = DateFormat('yyyy-MM-dd').format(dueTo);
    formattedTime = DateFormat('HH:mm').format(dueTo);

    contentController.text = fixData.missionContent;
    ruleController.text = fixData.missionRule;
    timeScrollController = FixedExtentScrollController(initialItem: timeCountIndex);
    notifyListeners();
  }

  void dispose() {
    contentController.dispose();
    ruleController.dispose();
    timeScrollController.dispose();
  }

  void updateTextField() {
    isContentChanged = (contentController.value.text != fixData.missionContent) ? true : false;
    isRuleChanged = (ruleController.value.text != fixData.missionRule) ? true : false;
    checkSubmit = (ruleController.value.text.isEmpty || contentController.value.text.isEmpty) ? false : true;
    notifyListeners();
  }

  void datePicker() {
    DateTime now = DateTime.now();
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: now,
        maxTime: DateTime(now.year + 3, now.month, now.day),
        onConfirm: (date) {
          formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
          isPickedToday = (now.year == date.year && now.month == date.month && now.day == date.day)
              ? true : false;

          // 만약 당일 날짜를 설정한 경우
          if (isPickedToday) {
            DateTime oneHourAgo = now.add(Duration(hours: 1));
            int afterOneHour = oneHourAgo.hour;
            timeCountIndex = afterOneHour;
            timeList = timeCountList.sublist(afterOneHour, 24);
            formattedTime = timeList[0].replaceAll("시", ":00");
          }
          else {
            timeList = List.from(timeCountList);
            timeCountIndex = 12;
            formattedTime = timeList[12].replaceAll("시", ":00");
          }
          // checkAddition();
          notifyListeners();
        }, currentTime: DateTime.now(), locale: LocaleType.ko);
  }

  /// 마감 시간 선택 시 IOS 시간 선택 모달
  void timePicker() {
    timeScrollController.dispose();
    timeScrollController = FixedExtentScrollController(initialItem: timeCountIndex);
    timeList = timeList.length < 1 ? List.from(timeCountList) : timeList;

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
                      /// 날짜 지정 안했을 때
                      if(formattedDate.length < 1) {
                        DateTime now = DateTime.now();
                        int currentHour = now.hour;
                        // 현재 시간이 선택한 시간보다 큰 경우
                        if(int.parse(timeList[timeCountIndex].replaceAll("시", "")) <= currentHour) {
                          DateTime tomorrow = now.add(Duration(days: 1));
                          formattedDate = "${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}";
                        }
                      }
                      formattedTime = timeList[timeCountIndex].replaceAll("시", ":00");
                      // checkAddition();
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
                children: timeList.map(
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

  void submit() async {
    if(checkSubmit) {
      String teamId = fixData.teamId.toString();
      String missionId = fixData.missionId.toString();
      // 반복 미션 변경한 경우
      if(fixData.isRepeated) {
        dueTo = '2099-12-31 00:00:00.000';
      } else {
        if (formattedTime.length < 1) {
          formattedTime = '12:00';
        }
        dueTo = '$formattedDate $formattedTime:00.000';
      }

      String way = '';
      if(fixData.missionWay.contains('링크')) {
        way = 'LINK';
      } else if (fixData.missionWay.contains('사진')) {
        way = 'PHOTO';
      } else if (fixData.missionWay.contains('텍스트')) {
        way = 'TEXT';
      }

      int repeatCount = fixData.repeatCount == 0 ? 1 : fixData.repeatCount;
      final String apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId';
      final APICall call = APICall();
      Map<String, dynamic> data = {
        "title": fixData.missionTitle,
        "dueTo": dueTo,
        "rule": ruleController.value.text,
        "content": contentController.value.text,
        "number": repeatCount,
        "type": fixData.isRepeated ? "REPEAT" : "ONCE",
        "way": way,
      };

      print('data : ${data.toString()}');

      try {
        ApiResponse<Map<String, dynamic>> apiResponse =
            await call.makeRequest<Map<String, dynamic>>(
          url: apiUrl,
          method: 'PUT',
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
            throw Exception('미션 수정 실패1, error code : ${apiResponse.errorCode}');
          }
        }
      } catch (e) {
        log('미션 수정 실패2: $e');
      }
    }
  }
}