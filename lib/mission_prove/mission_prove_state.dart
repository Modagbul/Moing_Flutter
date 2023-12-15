import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_fire/mission_fire_page.dart';
import 'package:moing_flutter/mission_prove/mission_state.dart';
import 'package:moing_flutter/missions/create/link_auth_page.dart';
import 'package:moing_flutter/missions/create/skip_mission_page.dart';
import 'package:moing_flutter/missions/create/text_auth_page.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/response/mission/my_mission_get_prove_response.dart';
import 'package:moing_flutter/model/response/mission/other_mission_get_prove_response.dart';
import 'package:moing_flutter/utils/image_upload/image_upload.dart';
import 'package:moing_flutter/utils/toast/toast_message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:speech_balloon/speech_balloon.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MissionProveState with ChangeNotifier {
  final BuildContext context;
  final int teamId;
  final int missionId;
  final bool isRepeated; // 반복 미션 여부
  final MissionState missionState = MissionState();

  late TabController tabController;

  final APICall call = APICall();
  final ImageUpload imageUpload = ImageUpload();

  String apiUrl = '';
  String imageUrl = '';
  // 사진 업로드
  XFile? avatarFile;

  // 미션 제목
  String missionTitle = '';
  // 미션 내용
  String missionContent = '';
  // 미션 규칙
  String missionRule = '';

  // 미션 방법(텍스트, 사진, 링크)
  String missionWay = '';
  // 미션 종료 날짜
  String missionDueTo = '';
  // 반복인증 시 나의 성공 횟수
  int repeatMissionMyCount = 0;
  // 반복인증 시 전체 성공 횟수
  int repeatMissionTotalCount = 0;

  // 한번인증 시 현재 성공 횟수
  int singleMissionMyCount = 0;
  // 한번인증 시 전체 성공 횟수
  int singleMissionTotalCount = 0;

  // 남은 시간 반환
  String missionRemainTime = '';

  // 리더 여부
  bool isLeader = false;
  // 내가 당일에 인증한 경우 T/F 값
  bool isMeProved = false;

  // 나의 인증이면 true, 모두의 인증이면 false
  bool isMeOrEveryProved = true;

  // 인증 후 더보기 버튼 클릭했을 때
  String missionMoreButton = '';

  // 나의 인증 조회 시 받아오는 리스트
  MyMissionProveAllData? myMissionData;
  List<MyMissionProveData>? myMissionList;
  // 시간대 정렬 리스트
  List<List<String>> myRepeatMissionTime = [];

  // 모두의 인증 조회 시 받아오는 리스트
  List<EveryMissionProveData>? everyMissionList;

  // 이미지 저장을 위한 key
  var globalKey = new GlobalKey();
  // 이미지 저장 성공 여부
  bool isSavedGallery = false;

  // 토스트 문구
  FToast fToast = FToast();
  final ToastMessage toastMessage = ToastMessage();

  String nobodyText = '데이터를 불러오는 중입니다...';
  bool onLoading = false;

  MissionProveState(
      {required this.context,
      required this.isRepeated,
      required this.teamId,
      required this.missionId}) {
    initState();
  }

  void initState() async {
    log('Instance "MissionProveState" has been created');
    print('isRepeated : $isRepeated, teamId : $teamId, missionId: $missionId');
    fToast.init(context);

    // 나의 인증 현황 조회하기
    await loadMissionData();
    // 모두의 인증 현황 조회하기
    loadEveryMissionData();
    // 미션 내용, 규칙 조회 --> 미션 제목, 기한, 규칙, 내용, 반복 or 한번 미션, 인증 방식(텍스트, 링크, 사진) 리턴
    getMissionContent();
    // 반복 미션인 경우, 나의 성공횟수 조회
    if (isRepeated) {
      loadMyMissionProveCount();
    }
    // 한번 미션인 경우,
    if (!isRepeated) {
      // 모임원 성공횟수 조회
      loadTeamMissionProveCount();
    }
  }

  // 남은 시간 조회
  calculateTimeLeft(String endTime) {
    DateTime now = DateTime.now();
    DateTime serverEndTime = DateTime.parse(endTime);
    Duration difference = serverEndTime.difference(now);

    if (difference.isNegative) {
      missionRemainTime = '시간 종료';
    } else {
      String formattedTime = '';
      int days = difference.inDays;
      int hours = difference.inHours % 24;
      int minutes = difference.inMinutes % 60;

      if (days > 0) {
        formattedTime += '$days일 ';
      }
      if (hours > 0) {
        formattedTime += '$hours시간 ';
      }
      if (minutes > 0) {
        formattedTime += '$minutes분 ';
      }

      missionRemainTime = formattedTime + '후 종료';
    }
  }

  /// 불 던져 독려해요 토스트 문구
  void showFireToast() {
    fToast.showToast(
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: SpeechBalloon(
              color: coralGrey500,
              width: double.infinity,
              height: 33,
              borderRadius: 24,
              nipLocation: NipLocation.bottom,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '미션을 인증하지 않은 모임원에게 불을 던져 독려해요',
                    style: bodyTextStyle.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        toastDuration: Duration(milliseconds: 1500),
        positionedToastBuilder: (context, child) {
          if (!isRepeated) {
            return Positioned(
              child: child,
              bottom: 145.0,
              left: 0.0,
              right: 0,
            );
          } else {
            return Positioned(
              child: child,
              top: 190.0,
              left: 0.0,
              right: 0,
            );
          }
        });
  }

  /// 단일 미션 링크 이동
  void singleMissionLink() async {
    try {
      if (onLoading) return;
      onLoading = true;
      launchUrl(Uri.parse(myMissionList![0].archive));
    } catch (e) {
      print('단일 미션 링크 이동 중 에러 발생 : ${e}');
    } finally {
      onLoading = false;
    }
  }

  /// 모임원 미션 인증 성공 인원 조회 API
  void loadTeamMissionProveCount() async {
    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive/status';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (dataJson) => dataJson as Map<String, dynamic>,
      );

      if (apiResponse.data != null) {
        singleMissionMyCount = int.parse(apiResponse.data?['done']);
        singleMissionTotalCount = int.parse(apiResponse.data?['total']);
        notifyListeners();
      } else {
        if (apiResponse.errorCode == 'J0003') {
          loadTeamMissionProveCount();
        } else {
          throw Exception(
              'loadTeamMissionProveCount is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('나의 성공 횟수 조회 실패: $e');
    }
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

      if (apiResponse.data != null) {
        repeatMissionMyCount = int.parse(apiResponse.data?['done']);
        repeatMissionTotalCount = int.parse(apiResponse.data?['total']);
        notifyListeners();
      } else {
        if (apiResponse.errorCode == 'J0003') {
          loadMyMissionProveCount();
        } else {
          throw Exception(
              'loadMyMissionProveCount is Null, error code : ${apiResponse.errorCode}');
        }
      }
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
      if (!isMeOrEveryProved &&
          everyMissionList != null &&
          everyMissionList!.isEmpty) {
        nobodyText = '아직 아무도\n인증하지 않았어요';
      } else if (isMeOrEveryProved &&
          myMissionList != null &&
          myMissionList!.isEmpty) {
        nobodyText = '아직 인증하지 않았어요';
      }
      notifyListeners();
    }
  }

  void dispose() {
    tabController.dispose();
    tabController.removeListener(_onTabChanged);
    fToast.removeCustomToast();
    log('Instance "MissionProveState" has been removed');
    super.dispose();
  }

  // 나의 인증 현황 조회하기
  Future<void> loadMissionData() async {
    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive';

    try {
      ApiResponse<MyMissionProveAllData> apiResponse =
          await call.makeRequest<MyMissionProveAllData>(
        url: apiUrl,
        method: 'GET',
        fromJson: (dataJson) => MyMissionProveAllData.fromJson(dataJson),
      );

      if (apiResponse.data != null) {
        // 오늘 미션 인증했는지 조회
        isMeProved = apiResponse.data?.today as bool;
        myMissionList = apiResponse.data?.archives;
        print('내 인증 리스트 개수 : ${myMissionList?.length}');
        if (myMissionList != null && myMissionList!.isNotEmpty) {
          for (MyMissionProveData data in myMissionList!) {
            myRepeatMissionTime.add(formatDateTime(data.createdDate));
          }
        }
        if (myMissionList != null && myMissionList!.isEmpty) {
          nobodyText = '아직 인증하지 않았어요';
        }
        print(
            '내가 오늘 인증했나 ? $isMeProved, 미션리스트 비었니? : ${myMissionList?.isEmpty}');
        notifyListeners();
      } else {
        print('loadMissionData is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('나의 인증 조회 실패: $e');
    }
  }

  /// 모임원 미션 인증 조회
  void loadEveryMissionData() async {
    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive/others';

    try {
      ApiResponse<List<EveryMissionProveData>> apiResponse =
          await call.makeRequest<List<EveryMissionProveData>>(
        url: apiUrl,
        method: 'GET',
        fromJson: (dataJson) => List<EveryMissionProveData>.from(
          (dataJson as List).map(
            (item) =>
                EveryMissionProveData.fromJson(item as Map<String, dynamic>),
          ),
        ),
      );

      if (apiResponse.isSuccess == true) {
        everyMissionList = apiResponse.data;
      } else {
        if (apiResponse.errorCode == 'J0003') {
          loadEveryMissionData();
        } else {
          throw Exception(
              'loadEveryMissionData is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('모임원 인증 조회 실패: $e');
    }
  }

  /// 더보기 버튼 클릭 시
  void setMission({String? val, int? index}) {
    if (onLoading) return;
    onLoading = true;
    missionMoreButton = val!;
    // 다시 인증하기 버튼 클릭 시..
    if (missionMoreButton.contains('retry')) {
      print('인증 다시 버튼 클릭!');
      missionDelete(index: index);
    }
    onLoading = false;
    notifyListeners();
  }

  /// 미션 삭제 API
  void missionDelete({int? index}) async {
    int count = -1;
    if (isRepeated) {
      if (index != null) {
        count = index;
        print('삭제하려는 count : $count');
      }
    } else {
      // 단일 미션일 때
      count = myMissionList![0].count;
    }
    print('count : $count');
    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive/$count';

    try {
      ApiResponse<int> apiResponse = await call.makeRequest<int>(
        url: apiUrl,
        method: 'DELETE',
        fromJson: (dataJson) => dataJson as int,
      );

      if (apiResponse.isSuccess) {
        print('${apiResponse.data} 미션 삭제가 완료되었습니다.');
        initState();
      } else {
        if (apiResponse.errorCode == 'J0003') {
          missionDelete();
        } else {
          throw Exception(
              'missionDelete is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('미션 삭제 실패: $e');
    }
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

      if (apiResponse.data != null) {
        missionTitle = apiResponse.data?['title'];
        missionContent = apiResponse.data?['content'];
        missionRule = apiResponse.data?['rule'];
        missionWay = apiResponse.data?['way'];
        isLeader = apiResponse.data?['isLeader'];
        switch (apiResponse.data?['way']) {
          case 'TEXT':
            missionWay = '텍스트인증';
            break;
          case 'PHOTO':
            missionWay = '사진인증';
            break;
          case 'LINK':
            missionWay = '링크인증';
            break;
        }
        // 남은 시간 계산
        missionDueTo = apiResponse.data?['dueTo'];
        calculateTimeLeft(missionDueTo);
        notifyListeners();
      } else {
        if (apiResponse.errorCode == 'J0003') {
          getMissionContent();
        } else {
          throw Exception(
              'getMissionContent is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('나의 성공 횟수 조회 실패: $e');
    }
  }

  /// 미션 인증 API
  Future<bool?> submitMission({required String url}) async {
    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive';
    Map<String, dynamic> data = {"status": 'COMPLETE', "archive": url};

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        body: data,
        fromJson: (dataJson) => dataJson as Map<String, dynamic>,
      );

      if (apiResponse.data != null) {
        print('미션인증 성공!');
        notifyListeners();
        return true;
      } else {
        if (apiResponse.errorCode == 'J0003') {
          submitMission(url: url);
        } else {
          throw Exception(
              'submitMission is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('미션인증 실패: $e');
      return false;
    }
  }

  // 미션 스킵 화면으로 이동
  void missionSkip() async {
    if (onLoading) return;
    onLoading = true;

    var result = await Navigator.of(context)
        .pushNamed(SkipMissionPage.routeName, arguments: {
      'teamId': teamId,
      'missionId': missionId,
    });

    if (result != null && result == true) {
      initState();
    }
    onLoading = false;
  }

  /// 미션 인증하기 버튼 클릭
  void submit() async {
    try {
      if (onLoading) return;
      onLoading = true;

      // 텍스트 인증 시
      if (missionWay.contains('텍스트')) {
        var result = await Navigator.of(context)
            .pushNamed(TextAuthPage.routeName, arguments: {
          'teamId': teamId,
          'missionId': missionId,
        });
        if (result != null && result is bool && result) {
          // 미션 인증 성공 모달
          await showMissionSuccessDialog();
          initState();
        }
      }
      // 링크 인증 시
      else if (missionWay.contains('링크')) {
        var result = await Navigator.of(context)
            .pushNamed(LinkAuthPage.routeName, arguments: {
          'teamId': teamId,
          'missionId': missionId,
        });
        if (result != null && result is bool && result) {
          // 미션 인증 성공 모달
          await showMissionSuccessDialog();
          initState();
        }
      }
      // 사진 인증 시
      else {
        print('사진 인증 시작!');
        await Permission.photos.request();
        final XFile? assetFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        avatarFile = assetFile;
        if (avatarFile != null) {
          String extension = imageUpload.getFileExtension(avatarFile!);
          String? tmpUrl =
              await imageUpload.getPresignedUrl(extension, avatarFile!);

          /// 이미지 url 받기
          imageUrl = tmpUrl ?? '';
          // presigned url 발급 성공 시
          if (imageUrl.isNotEmpty) {
            bool? isSuccess = await submitMission(url: imageUrl);
            if (isSuccess != null && isSuccess) {
              await showMissionSuccessDialog();
              initState();
            }
          }
        }
        notifyListeners();
      }
    } catch (e) {
      print('미션 인증 도중 에러 발생 : ${e}');
    } finally {
      onLoading = false;
    }
  }

  /// 불 던지러 가기 버튼 클릭 시
  void firePressed() {
    if (onLoading) return;
    onLoading = true;

    /// 내가 인증했을 때
    // if(context.read<MissionProveState>().isMeProved) {
    //   print('불 던지러 가기 버튼 클릭1!');
    // }
    // else {
    //   print('불 던지러 가기 버튼 클릭2!');
    // }
    onLoading = false;
    Navigator.of(context).pushNamed(MissionFirePage.routeName, arguments: {
      'teamId': teamId,
      'missionId': missionId,
    });
  }

  /// 미션 인증물 에러토스트 띄우기
  likePressedToast() {
    if (onLoading) return;
    onLoading = true;
    toastMessage.showToastMessage(
      fToast: fToast,
      warningText: '내 인증에는 좋아요를 누를 수 없어요.',
      toastBottom: 145.0,
      toastLeft: 0,
      toastRight: 0,
    );
    onLoading = false;
  }

  /// 미션 인증물 좋아요
  likePressed(
      {required int archiveId,
      required int index,
      required String heartStatus}) async {
    if (onLoading) return;
    onLoading = true;
    String beforeHeartStatus = heartStatus != 'true' ? 'True' : 'False';
    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive/$archiveId/heart/$beforeHeartStatus';

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'PUT',
        fromJson: (dataJson) => dataJson as Map<String, dynamic>,
      );

      if (apiResponse.data != null) {
        String missionHeartStatus = apiResponse.data?['missionHeartStatus'];
        int newHearts = apiResponse.data?['hearts'];

        everyMissionList![index].heartStatus =
            missionHeartStatus == 'True' ? 'true' : 'false';
        everyMissionList![index].hearts = newHearts;
        print('index : $index, hearts : ${everyMissionList![index].hearts}');
        notifyListeners();
      } else {
        if (apiResponse.errorCode == 'J0003') {
          likePressed(
              archiveId: archiveId, index: index, heartStatus: heartStatus);
        } else {
          throw Exception(
              'likePressed is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('미션인증 실패: $e');
    }
    onLoading = false;
  }

  /// 이미지 공유하기 모달
  void missionShareDialog({int? index}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  width: double.infinity,
                  height: 487,
                  decoration: BoxDecoration(
                    color: grayScaleGrey700,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 28,
                                    color: grayScaleGrey300,
                                  )),
                              SizedBox(width: 32),
                              Text('내 인증 공유하기',
                                  style: buttonTextStyle.copyWith(
                                      color: grayScaleGrey300)),
                            ],
                          ),
                        ),
                        RepaintBoundary(
                          key: globalKey,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                Image.network(
                                  index != null
                                      ? myMissionList![index].archive
                                      : myMissionList![0].archive,
                                  width: 313,
                                  height: 313,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    // scrim의 높이
                                    // height: 100,
                                    height: 313,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          coralGrey500,
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 52,
                                  left: 20,
                                  child: Row(
                                    children: [
                                      Text(
                                        index != null
                                            ? myRepeatMissionTime[index][0]
                                            : myRepeatMissionTime[0][0],
                                        style: bodyTextStyle.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        index != null
                                            ? myRepeatMissionTime[index][1]
                                            : myRepeatMissionTime[0][1],
                                        style: bodyTextStyle.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 23,
                                  left: 20,
                                  child: Text(missionTitle,
                                      style: buttonTextStyle.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                                Positioned(
                                  bottom: 20,
                                  right: 20,
                                  child: SvgPicture.asset(
                                    'asset/icons/mission_prove_fire_white.svg',
                                    width: 52,
                                    height: 52,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              /// 이미지 갤러리에 저장
                              var renderObject =
                                  globalKey.currentContext?.findRenderObject();
                              if (renderObject is RenderRepaintBoundary) {
                                var boundary = renderObject;
                                ui.Image image =
                                    await boundary.toImage(pixelRatio: 3);
                                final directory =
                                    (await getApplicationDocumentsDirectory())
                                        .path;
                                ByteData? byteData = await image.toByteData(
                                    format: ui.ImageByteFormat.png);
                                if (byteData != null) {
                                  Uint8List pngBytes =
                                      byteData.buffer.asUint8List();
                                  File imgFile =
                                      new File('$directory/screenshot.png');
                                  await imgFile.writeAsBytes(pngBytes);

                                  // 갤러리에 저장
                                  final result =
                                      await ImageGallerySaver.saveFile(
                                          imgFile.path);
                                  if (result['isSuccess'] == true) {
                                    // 토스트 문구 출력
                                    fToast.showToast(
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Container(
                                              width: double.infinity,
                                              height: 51,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '갤러리에 이미지 저장 성공!',
                                                  style:
                                                      contentTextStyle.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: grayScaleGrey900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        toastDuration:
                                            Duration(milliseconds: 1500),
                                        positionedToastBuilder:
                                            (context, child) {
                                          return Positioned(
                                            child: child,
                                            bottom: 64.0,
                                            left: 0.0,
                                            right: 0,
                                          );
                                        });
                                    imgFile.delete();
                                  }
                                }
                              }
                            },
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(double.infinity, 62)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    grayScaleGrey500)),
                            child: Text('이미지 저장하기',
                                style: buttonTextStyle.copyWith(
                                    color: grayScaleGrey300)),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        );
      },
    );
  }

  /// 미션 인증 시 모달
  Future<void> showMissionSuccessDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
              width: double.infinity,
              height: 455,
              decoration: BoxDecoration(
                color: grayScaleGrey600,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 32),
                  Image.asset(
                    'asset/image/moing_flower.png',
                    width: 254,
                    height: 254,
                  ),
                  SizedBox(height: 16),
                  Text(
                    isRepeated
                        ? '${myMissionList!.length + 1}회차 인증완료!'
                        : '모잉불이 기뻐해요!',
                    style: middleTextStyle.copyWith(color: grayScaleGrey100),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '덕분에 모잉불이 쑥쑥 커지고 있어요',
                    style: bodyTextStyle.copyWith(
                        fontWeight: FontWeight.w500, color: grayScaleGrey400),
                  ),
                  SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: RoundedProgressBar(
                      milliseconds: 1000,
                      borderRadius: BorderRadius.circular(24),
                      childLeft: Text(
                        isRepeated
                            ? '남은 횟수까지 파이팅!'
                            : '${singleMissionMyCount + 1}/$singleMissionTotalCount명 인증성공',
                        style: bodyTextStyle.copyWith(color: grayScaleGrey100),
                      ),
                      percent: singleMissionMyCount < singleMissionTotalCount
                          ? (singleMissionMyCount + 1) *
                              100 /
                              singleMissionTotalCount
                          : 100,
                      style: RoundedProgressBarStyle(
                        colorBorder: Colors.transparent,
                        colorProgress: coralGrey500,
                        backgroundProgress: grayScaleGrey500,
                        widthShadow: 0,
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );

    Future.delayed(Duration(milliseconds: 2000), () {
      Navigator.of(context).pop();
      notifyListeners();
      showFireToast();
    });
  }

  Future<void> _launchUrl(String link) async {
    if (onLoading) return;
    onLoading = true;
    Uri _url = Uri.parse(link);
    if (!await launchUrl(
      _url,
      mode: LaunchMode.externalApplication,
    )) {
      throw ArgumentError("해당 링크에 접속할 수 없습니다.");
    }
    onLoading = false;
  }

  /// 나의 인증, 모두의 인증에 따라 리스트의 인덱스 반환
  dynamic getCurrentMission(int index) {
    return isMeOrEveryProved ? myMissionList![index] : everyMissionList![index];
  }

  /// 신고하기 API
  void doReport() async {
    if (onLoading) return;
    onLoading = true;

    apiUrl = '${dotenv.env['MOING_API']}/api/report/MISSION/$missionId/archive';

    try {
      ApiResponse<int> apiResponse = await call.makeRequest<int>(
        url: apiUrl,
        method: 'DELETE',
        fromJson: (dataJson) => dataJson as int,
      );

      if (apiResponse.isSuccess) {
        print('${apiResponse.data} 미션 삭제가 완료되었습니다.');
        initState();
      } else {
        if (apiResponse.errorCode == 'J0003') {
          missionDelete();
        } else {
          throw Exception(
              'missionDelete is Null, error code : ${apiResponse.errorCode}');
        }
      }
    } catch (e) {
      log('미션 삭제 실패: $e');
    }
    onLoading = false;
  }

  /// 미션 상세내용 확인
  void getMissionDetailContent(int index) {
    print('반복 미션 상세내용 확인');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            var currentMission = getCurrentMission(index);
            return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: grayScaleGrey600,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 46),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          child: Text(
                            currentMission.count.toString(),
                            // (myMissionList!.length - index).toString(),
                            style:
                                bodyTextStyle.copyWith(color: grayScaleGrey700),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          DateFormat('yy.MM.dd').format(
                              // DateTime.parse(myMissionList![index].createdDate)),
                              DateTime.parse(currentMission.createdDate)),
                          style: bodyTextStyle.copyWith(
                              color: grayScaleGrey300,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 12),
                        Text(
                          DateFormat('HH:mm').format(
                              DateTime.parse(currentMission.createdDate)),
                          style: bodyTextStyle.copyWith(
                              color: grayScaleGrey300,
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        if (isMeOrEveryProved)
                          DropdownButton<String>(
                            underline: SizedBox.shrink(),
                            style: contentTextStyle.copyWith(
                                color: grayScaleGrey100),
                            dropdownColor: grayScaleGrey500,
                            icon: Icon(
                              Icons.more_vert_outlined,
                              color: grayScaleGrey300,
                            ),
                            iconEnabledColor: Colors.white,
                            items: <DropdownMenuItem<String>>[
                              DropdownMenuItem(
                                  value: 'retry',
                                  child: Container(
                                    padding: EdgeInsets.only(top: 8, right: 8),
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text('다시 인증하기'),
                                        Text(
                                          '기존 인증내역이 취소돼요',
                                          style: bodyTextStyle.copyWith(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                            isDense: true,
                            onChanged: (String? val) {
                              setMission(val: val, index: currentMission.count);
                              Navigator.of(context).pop();
                            },
                          ),
                        if (!isMeOrEveryProved)
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              items: <DropdownMenuItem<String>>[
                                DropdownMenuItem(
                                    value: 'report',
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 16),
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '인증내역 신고하기',
                                          style: contentTextStyle.copyWith(
                                              color: grayScaleGrey100),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    )),
                              ],
                              onChanged: (String? val) {
                                print('신고하기 버튼 클릭');
                                fToast.showToast(
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            height: 51,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '신고가 완료되었어요',
                                                  style: bodyTextStyle.copyWith(
                                                      color: grayScaleGrey700),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                    toastDuration: Duration(milliseconds: 2000),
                                    positionedToastBuilder: (context, child) {
                                      return Positioned(
                                        child: child,
                                        bottom: 40.0,
                                        left: 0.0,
                                        right: 0,
                                      );
                                    });
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 20,
                                width: 150,
                              ),
                              iconStyleData: IconStyleData(
                                icon: Icon(
                                  Icons.more_vert_outlined,
                                ),
                                iconSize: 20,
                                iconEnabledColor: grayScaleGrey300,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 51,
                                width: 185,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: grayScaleGrey500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16),

                    /// 사진 텍스트 링크 중 선택
                    if (missionWay.contains('사진') &&
                        currentMission.status == 'COMPLETE')
                      Container(
                          width: double.infinity,
                          height: 265,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              currentMission.archive,
                              fit: BoxFit.cover,
                            ),
                          )),
                    if (missionWay.contains('링크') &&
                        currentMission.status == 'COMPLETE')
                      GestureDetector(
                        onTap: () async {
                          await _launchUrl(currentMission.archive);
                        },
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 77,
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: grayScaleGrey500, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 20),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'asset/image/icon_link.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      SizedBox(width: 12),
                                      Text('링크 바로보기',
                                          style: contentTextStyle.copyWith(
                                              color: grayScaleGrey100)),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 48.0, bottom: 20),
                                  child: Text(
                                    currentMission.archive,
                                    style: smallTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (missionWay.contains('텍스트') ||
                        currentMission.status == 'SKIP')
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 265,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: grayScaleGrey500, width: 1),
                            ),
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                currentMission.archive,
                                style: contentTextStyle.copyWith(
                                    color: grayScaleGrey200),
                              ),
                            ),
                          ),
                          if (currentMission.status == 'SKIP')
                            Positioned(
                              bottom: 16,
                              left: MediaQuery.of(context).size.width / 3.2,
                              child: Text(
                                '미션을 건너뛰었어요',
                                style: contentTextStyle,
                              ),
                            ),
                        ],
                      ),
                    SizedBox(height: 12),

                    /// 버튼 구현
                    if (missionWay.contains('사진') &&
                        currentMission.status == 'COMPLETE')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                // 내 사진 좋아요 버튼 클릭
                                if (currentMission.runtimeType.toString() ==
                                    'MyMissionProveData') {
                                  print('내 미션 바텀시트에서 좋아요 클릭');
                                  likePressedToast();
                                }
                                // 모두으 인증 좋아요 버튼 클릭
                                else if (currentMission.runtimeType
                                        .toString() ==
                                    'EveryMissionProveData') {
                                  int selectedIndex = index;
                                  await likePressed(
                                      archiveId: currentMission.archiveId,
                                      index: selectedIndex,
                                      heartStatus: currentMission.heartStatus);
                                  setState(() {
                                    currentMission.hearts =
                                        everyMissionList![index].hearts;
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'asset/icons/mission_like.svg',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    currentMission.hearts.toString(),
                                    style: contentTextStyle.copyWith(
                                      color: grayScaleGrey400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: missionShareDialog,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'asset/icons/mission_image_upload.svg',
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '이미지 저장',
                                    style: bodyTextStyle.copyWith(
                                        color: grayScaleGrey300,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (missionWay.contains('텍스트') ||
                        missionWay.contains('링크') ||
                        currentMission.status == 'SKIP')
                      Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  // 내 사진 좋아요 버튼 클릭
                                  if (currentMission.runtimeType.toString() ==
                                      'MyMissionProveData') {
                                    print('내 미션 바텀시트에서 좋아요 클릭');
                                    likePressedToast();
                                  }
                                  // 모두으 인증 좋아요 버튼 클릭
                                  else if (currentMission.runtimeType
                                          .toString() ==
                                      'EveryMissionProveData') {
                                    int selectedIndex = index;
                                    print(
                                        'curMis heartStatus : ${currentMission.heartStatus}');
                                    await likePressed(
                                        archiveId: currentMission.archiveId,
                                        index: selectedIndex,
                                        heartStatus:
                                            currentMission.heartStatus);
                                    setState(() {
                                      currentMission.hearts =
                                          everyMissionList![index].hearts;
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'asset/icons/mission_like.svg',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      currentMission.hearts.toString(),
                                      style: contentTextStyle.copyWith(
                                        color: grayScaleGrey400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    notifyListeners();
  }

  /// 더보기 버튼 클릭 시
  clickMoreModal() {
    if (isLeader) {
      showModal('more');
    }
  }

  /// 바텀 모달 클릭
  void showModal(String value) async {
    switch (value) {
      // 더보기 클릭
      case 'more':
        bool result = await missionState.showMoreDetails(
          context: context,
          missionTitle: missionTitle,
          missionContent: missionContent,
          missionRule: missionRule,
          dueTo: missionDueTo,
          isRepeated: isRepeated,
          teamId: teamId,
          missionId: missionId,
          repeatCount: repeatMissionTotalCount,
          missionWay: missionWay,
        );

        if (result) {
          initState();
        }
        break;
      // 미션내용 클릭
      case 'content':
        missionState.showContentAndRule(
            context: context,
            missionWay: missionWay,
            missionContent: missionContent,
            missionRule: missionRule);
      // 미션 인증하기 클릭
      case 'mission':
        var missionResult =
            await missionState.MissionSuccessPressed(context: context);
        print('missionResult2 : $missionResult');
        if (missionResult != null) {
          if (missionResult == 'skip') {
            missionSkip();
          } else if (missionResult == 'submit') {
            submit();
          }
        }
    }
  }

  // 인증 날짜 변환
  List<String> formatDateTime(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    String formattedDate = DateFormat('yy.MM.dd').format(parsedDate);
    String formattedTime = DateFormat('HH:mm').format(parsedDate);

    return [formattedDate, formattedTime];
  }
}
