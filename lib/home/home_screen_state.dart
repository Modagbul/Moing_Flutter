import 'dart:async';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moing_flutter/board/board_main_page.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/make_group/group_create_start_page.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/response/get_team_mission_photo_list_response.dart';
import 'package:moing_flutter/model/response/group_team_response.dart';
import 'package:moing_flutter/utils/api/refresh_token.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';

class HomeScreenState extends ChangeNotifier {
  final BuildContext context;
  final TokenManagement tokenManagement = TokenManagement();
  final APICall call = APICall();

  // 토스트 문구
  final FToast fToast = FToast();
  String? newCreated;
  String nickname = '';

  TeamData? futureData;
  List<TeamBlock> teamList = [];
  List<TeamMissionPhotoData>? futureTeamMissionPhotoList;
  List<TeamMissionPhotoData> teamMissionPhotoList = [];

  /// Test API
  final ApiCode apiCode = ApiCode();

  String apiUrl = '';

  // 알림 여부
  bool isNotification = false;

  HomeScreenState({required this.context, this.newCreated}){
    initState();
  }

  void initState() async {
    log('Instance "HomeScreenState" has been created');
    fToast.init(context);
    await loadTeamData();
    getTeamMissionPhotoListData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(newCreated != "new") {
        checkUserRegister();
      }
    });
  }

  /// 소모임에 가입된 유저인지 확인
  void checkUserRegister() {
    String warningText = '';
    // 이미 가입한 유저일 때
    if (newCreated == 'isRegistered') {
      warningText = '이미 가입한 소모임이에요';
    } else if (newCreated == 'full') {
      warningText = '최대 3개의 소모임에서만 활동할 수 있어요';
    } else if (newCreated == 'T0003') {
      warningText = '한번 탈퇴한 소모임에 다시 가입할 수 없어요';
    } else if (newCreated != null && newCreated!.isNotEmpty) {
      warningText = '소모임 가입에 실패했어요';
      print('소모임 가입 실패 에러 확인 : $newCreated');
    }
    if (warningText.length > 1) {
      fToast.showToast(
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 41,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'asset/icons/toast_danger.svg',
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      Text(
                        warningText,
                        style: bodyTextStyle.copyWith(color: grayScaleGrey700),
                      ),
                    ],
                  ),
                )),
          ),
          toastDuration: Duration(milliseconds: 3000),
          positionedToastBuilder: (context, child) {
            return Positioned(
              child: child,
              bottom: 140.0,
              left: 0.0,
              right: 0,
            );
          });
    }
    notifyListeners();
  }

  /// API 데이터 로딩
  Future<void> loadTeamData() async {
    futureData = await fetchApiData();
    if (futureData != null) {
      print('futureData length : ${futureData?.teamBlocks.length}');
      teamList = futureData!.teamBlocks.reversed.toList();
      SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
      sharedPreferencesInfo.savePreferencesData(
          'teamCount', teamList.length.toString());
    }
    notifyListeners();
  }

  void getTeamMissionPhotoListData() async {
    futureTeamMissionPhotoList = await apiCode.getTeamMissionPhotoList();
    if (futureTeamMissionPhotoList != null) {
      teamMissionPhotoList = futureTeamMissionPhotoList!;
      loadTeamData();
    }
  }

  Future<TeamData?> fetchApiData() async {
    try {
      apiUrl = '${dotenv.env['MOING_API']}/api/team';
      ApiResponse<TeamData> apiResponse = await call.makeRequest<TeamData>(
        url: apiUrl,
        method: 'GET',
        fromJson: (json) => TeamData.fromJson(json),
      );

      if (apiResponse.isSuccess == true) {
        nickname = apiResponse.data!.memberNickName;
        return apiResponse.data!;
      }
      // else {
      //   if(apiResponse.errorCode == 'J0003') {
      //     fetchApiData();
      //   }
        else {
          throw Exception('fetchApiData is Null, error code : ${apiResponse.errorCode}');
        //}
      }
    } catch (e) {
      print('홈 화면 받아 오는 중 에러 발생 : ${e.toString()}');
      return null;
    }
    return null;
  }

  // 모임 만들기 클릭
  void makeGroupPressed() {
    Navigator.of(context).pushNamed(
      GroupCreateStartPage.routeName,
    );
  }

  // 가입한 모임 클릭
  void teamPressed(int teamId) {
    /// 목표보드 페이지로 이동
    Navigator.pushNamed(context, BoardMainPage.routeName,
        arguments: {'teamId': teamId});
  }
}
