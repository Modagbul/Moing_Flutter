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

  // 반복 미션 여부
  final bool isRepeated;
  final int teamId;
  final int missionId;

  late TabController tabController;

  final APICall call = APICall();
  String apiUrl = '';

  String missionTitle = '';
  String missionContent = '';
  String missionRule = '';

  // 나의 인증인 경우
  bool isMeProved = false;

  // 나의 인증이면 true, 아니면 false
  bool isMeOrEveryProved = true;

  // 인증 후 더보기 버튼 클릭했을 때
  String missionMoreButton = '';

  // 나의 인증 리스트
  List<MyMissionProveData>? myMissionList;

  MissionProveState(
      {required this.context,
      required this.isRepeated,
      required this.teamId,
      required this.missionId}) {
    initState();
  }

  void initState() {
    log('Instance "MissionProveState" has been created');
    print('isRepeated : $isRepeated, teamId : $teamId, missionId: $missionId');

    getMissionContent();
    // 반복 미션인 경우, 나의 성공횟수 조회
    if (isRepeated) {
      loadMyMissionProveCount();
    }
    loadMissionData();
  }

  /// 반복 미션 시 나의 성공 횟수 조회 API
  void loadMyMissionProveCount() async {
    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive/my-status';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (dataJson) => dataJson as Map<String, dynamic>,
      );

      log('나의 성공 횟수 조회 성공: ${apiResponse.data}');
      print(' 조회 완료 : ${apiResponse.data?['total']}');
      print(' 조회 완료 : ${apiResponse.data?['done']}');

      notifyListeners();
    } catch (e) {
      log('나의 성공 횟수 조회 실패: $e');
    }
  }

  void initTabController({required TabController tabController}) {
    this.tabController = tabController;
    tabController.addListener(_onTabChanged);
  }

  // 탭 변화 관찰
  void _onTabChanged() {
    if (!tabController.indexIsChanging) {
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
    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive';

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
      if (isMeProved) {
        myMissionList = apiResponse.data;
      }
      notifyListeners();
      print('내가 인증했나 ? $isMeProved, 미션리스트 비었니? : ${myMissionList?.isEmpty}');
    } catch (e) {
      log('나의 인증 조회 실패: $e');
    }
  }

  /// 더보기 버튼 클릭 시
  void setMission(String? val) {
    missionMoreButton = val!;
    // 인증 수정하기 버튼 클릭 시...
    if (missionMoreButton.contains('fix')) {
      print('인증 수정 버튼 클릭!');
    }
    // 다시 인증하기 버튼 클릭 시..
    else if (missionMoreButton.contains('retry')) {
      print('인증 다시 버튼 클릭!');
    }
    notifyListeners();
  }

  /// 미션 내용(규칙) 조회 API
  void getMissionContent() async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (dataJson) => dataJson as Map<String, dynamic>,
      );

      log('나의 성공 횟수 조회 성공: ${apiResponse.data}');
      if (apiResponse.data != null) {
        missionTitle = apiResponse.data?['title'];
        missionContent = apiResponse.data?['content'];
        missionRule = apiResponse.data?['rule'];
        print('시간 : ${apiResponse.data?['dueTo']}');
      }

      notifyListeners();
    } catch (e) {
      log('나의 성공 횟수 조회 실패: $e');
    }
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
                    Text(
                      '미션내용과 규칙',
                      style: middleTextStyle.copyWith(color: grayScaleGrey100),
                    ),
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
                Text(
                  '미션 내용',
                  style: contentTextStyle.copyWith(
                      fontWeight: FontWeight.w600, color: grayScaleGrey100),
                ),
                SizedBox(height: 4),
                Container(
                  child: Text(
                    missionContent,
                    style: bodyTextStyle.copyWith(
                        fontWeight: FontWeight.w500, color: grayScaleGrey400),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  '미션 규칙',
                  style: contentTextStyle.copyWith(
                      fontWeight: FontWeight.w600, color: grayScaleGrey100),
                ),
                SizedBox(height: 4),
                Container(
                  child: Text(
                    missionRule,
                    style: bodyTextStyle.copyWith(
                        fontWeight: FontWeight.w500, color: grayScaleGrey400),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: WhiteButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: '확인했어요'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
