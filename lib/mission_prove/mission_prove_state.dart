import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/response/mission/my_mission_get_prove_response.dart';
import 'package:moing_flutter/utils/button/white_button.dart';

class MissionProveState with ChangeNotifier {
  final BuildContext context;
  late TabController tabController;
  final APICall call = APICall();

  // 반복 미션 여부
  bool isRepeated = false;
  // 나의 인증인 경우
  bool isMeProved = false;
  // 나의 인증이면 true, 아니면 false
  bool isMeOrEveryProved = true;
  // 인증 후 더보기 버튼 클릭했을 때
  String missionMoreButton = '';
  // 나의 인증 리스트
  List<MyMissionProveData>? myMissionList;

  MissionProveState({required this.context}) {
    initState();
  }

  void initState() {
    log('Instance "MissionProveState" has been created');
    loadMissionData();
  }

  void initTabController({required TabController tabController}) {
    this.tabController = tabController;
    tabController.addListener(_onTabChanged);
  }

  // 탭 변화 관찰
  void _onTabChanged() {
    if(!tabController.indexIsChanging) {
      isMeOrEveryProved = tabController.index == 0 ? true : false;
      print('탭 : ${tabController.index}, 나의 인증 : $isMeOrEveryProved');
      notifyListeners();
    }
  }

  void dispose() {
    tabController.dispose();
    tabController.removeListener(_onTabChanged);
    log('Instance "MissionProveState" has been removed');
    super.dispose();
  }

  // 나의 인증 현황 조회하기
  void loadMissionData() async {
    int teamId = 9;
    int missionId = 4;
    final String apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive';
    final APICall call = APICall();

    try {
      ApiResponse<List<MyMissionProveData>> apiResponse =
      await call.makeRequest<List<MyMissionProveData>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (dataJson) => List<MyMissionProveData>.from(
          (dataJson as List).map(
                (item) => MyMissionProveData.fromJson(item as Map<String, dynamic>),
          ),
        ),
      );
      log('나의 인증 조회 성공: ${apiResponse.data}');
      isMeProved = (apiResponse.data!.isEmpty) ? false : true;
      if(isMeProved) {
        myMissionList = apiResponse.data;
      }
      notifyListeners();
      print('내가 인증했나 ? $isMeProved');
    } catch (e) {
      log('나의 인증 조회 실패: $e');
    }
  }

  /// 더보기 버튼 클릭 시
  void setMission(String? val) {
    missionMoreButton = val!;
    // 인증 수정하기 버튼 클릭 시...
    if(missionMoreButton.contains('fix')) {
      print('인증 수정 버튼 클릭!');
    }
    // 다시 인증하기 버튼 클릭 시..
    else if (missionMoreButton.contains('retry')){
      print('인증 다시 버튼 클릭!');
    }
    notifyListeners();
  }
  // 미션 내용 모달
  void showMissionRuleBottomModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 700,
          decoration: const BoxDecoration(
            color: grayScaleGrey600,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, top: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('미션내용과 규칙', style: middleTextStyle.copyWith(color: grayScaleGrey100),),
                    Spacer(),
                    Container(
                      alignment: Alignment.center,
                      width: 72,
                      height: 33,
                      decoration: BoxDecoration(
                        color: grayScaleGrey500,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '사진인증',
                        style: bodyTextStyle.copyWith(color: grayScaleGrey200),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text('미션 내용', style: contentTextStyle.copyWith(fontWeight: FontWeight.w600, color:grayScaleGrey100),),
                SizedBox(height: 4),
                Container(
                  child: Text('안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요300자끝',
                  style: bodyTextStyle.copyWith(fontWeight: FontWeight.w500, color: grayScaleGrey400),),
                ),
                SizedBox(height: 24),
                Text('미션 규칙', style: contentTextStyle.copyWith(fontWeight: FontWeight.w600, color:grayScaleGrey100),),
                SizedBox(height: 4),
                Container(
                  child: Text('안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요',
                    style: bodyTextStyle.copyWith(fontWeight: FontWeight.w500, color: grayScaleGrey400),),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: WhiteButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, text: '확인했어요'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}