import 'dart:async';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moing_flutter/board/board_main_page.dart';
import 'package:moing_flutter/config/amplitude_config.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/make_group/group_create_category_page.dart';
import 'package:moing_flutter/make_group/group_create_category_state.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/response/get_team_mission_photo_list_response.dart';
import 'package:moing_flutter/model/response/group_team_response.dart';
import 'package:moing_flutter/utils/api/refresh_token.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class HomeScreenState extends ChangeNotifier {
  final BuildContext context;
  final TokenManagement tokenManagement = TokenManagement();
  final APICall call = APICall();

  // 토스트 문구
  final FToast fToast = FToast();
  String? status;
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

  HomeScreenState({required this.context, this.status}) {
    // initState();
  }

  Future<void> initState() async {
    log('Instance "HomeScreenState" has been created');
    fToast.init(context);
    await loadTeamData();
    await getTeamMissionPhotoListData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (status != "new" && status != "fromSignUp") {
        await checkUserRegister();
      }
    });
  }

  /// 소모임에 가입된 유저인지 확인
  Future<void> checkUserRegister() async {
    String warningText = '';
    // 이미 가입한 유저일 때
    if (status == 'isRegistered') {
      warningText = '이미 가입한 소모임이에요';
    } else if (status == 'full') {
      warningText = '최대 3개의 소모임에서만 활동할 수 있어요';
    } else if (status == 'T0003') {
      warningText = '한번 탈퇴한 소모임에 다시 가입할 수 없어요';
    } else if (status == 'T0005') {
      warningText = '이미 종료된 소모임입니다.';
    } else if (status != null && status!.isNotEmpty) {
      warningText = '소모임 가입에 실패했어요';
      print('소모임 가입 실패 에러 확인 : $status');
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
                          const SizedBox(width: 10),
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
          toastDuration: const Duration(milliseconds: 3000),
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
      teamList = futureData!.teamBlocks.reversed.toList();
      try {
        print('유저 프로퍼티 설정 시작!');
        setUserInfo(
            futureData!.userProperty.birthDate ?? 'null',
            futureData!.memberNickName,
            futureData!.userProperty.gender ?? 'null');
      } catch (e) {
        print('유저 프로퍼티 설정 도중 에러 발생: ${e.toString()}');
      }
      SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
      sharedPreferencesInfo.savePreferencesData(
          'teamCount', teamList.length.toString());
    }
    notifyListeners();
  }

  Future<void> getTeamMissionPhotoListData() async {
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
      } else {
        print('fetchApiData is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      print('홈 화면 받아 오는 중 에러 발생 : ${e.toString()}');
      return null;
    }
    return null;
  }

  // 모임 만들기 클릭
  void makeGroupPressed() {
    // 버벅임 애니메이션 처리
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            ChangeNotifierProvider(
          create: (_) => GroupCreateCategoryState(context: context),
          child: const GroupCreateCategoryPage(),
        ),
        transitionsBuilder: (context, animation1, animation2, child) {
          return child;
        },
        transitionDuration: const Duration(milliseconds: 0),
      ),
    );
  }

  // 가입한 모임 클릭
  void teamPressed(int teamId) {
    addAmplitudeGroupClickEvent(teamId);
    navigateBoardMainPage(teamId);
  }

  void navigateBoardMainPage(int teamId) {
    Navigator.pushNamed(context, BoardMainPage.routeName,
        arguments: {'teamId': teamId});
  }

  void addAmplitudeGroupClickEvent(int teamId) {
    AmplitudeConfig.analytics.logEvent("group_click", eventProperties: {
      "teamId": teamId,
    });
  }

  String convertCategoryName({required String category}) {
    String convertedCategory = '';

    switch (category) {
      case 'SPORTS':
        convertedCategory = '스포츠/운동';
        break;
      case 'HABIT':
        convertedCategory = '생활습관 개선';
        break;
      case 'TEST':
        convertedCategory = '시험/취업준비';
        break;
      case 'STUDY':
        convertedCategory = '스터디/공부';
        break;
      case 'READING':
        convertedCategory = '독서';
        break;
      default:
        convertedCategory = '자기계발';
        break;
    }

    return convertedCategory;
  }

  void setUserInfo(String birthDay, String nickname, String gender) {
    /// Amplitude - 유저 프로퍼티 설정
    AmplitudeConfig amplitudeConfig = AmplitudeConfig();
    if (birthDay == 'null') {
      amplitudeConfig.setUserInfo(
          gender: gender, age: 0, ageGroup: 'null', nickname: nickname);
      return;
    }
    int birth = int.parse(birthDay.split("-")[0]);
    // 나이
    int userAge = DateTime.now().year - birth + 1;
    String ageGroup = '';
    if (birth >= 2015) {
      ageGroup = '10대 이하';
    } else if (birth >= 2006 && birth < 2015) {
      ageGroup = '10대';
    } else if (birth >= 2002 && birth <= 2005) {
      ageGroup = '20대 초반';
    } else if (birth >= 1999 && birth <= 2001) {
      ageGroup = '20대 중반';
    } else if (birth >= 1995 && birth <= 1998) {
      ageGroup = '20대 후반';
    } else if (birth >= 1991 && birth <= 1994) {
      ageGroup = '30대 초반';
    } else if (birth >= 1988 && birth <= 1990) {
      ageGroup = '30대 중반';
    } else if (birth >= 1985 && birth <= 1987) {
      ageGroup = '30대 후반';
    }

    amplitudeConfig.setUserInfo(
        gender: futureData!.userProperty.gender ?? 'null',
        age: userAge,
        ageGroup: ageGroup,
        nickname: nickname);
  }
}
