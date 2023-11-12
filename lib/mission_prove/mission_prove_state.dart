import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
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
import 'package:moing_flutter/missions/create/link_auth_page.dart';
import 'package:moing_flutter/missions/create/skip_mission_page.dart';
import 'package:moing_flutter/missions/create/text_auth_page.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/response/mission/my_mission_get_prove_response.dart';
import 'package:moing_flutter/model/response/mission/other_mission_get_prove_response.dart';
import 'package:moing_flutter/utils/button/white_button.dart';
import 'package:moing_flutter/utils/image_upload/image_upload.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MissionProveState with ChangeNotifier {
  final BuildContext context;
  final int teamId;
  final int missionId;
  final bool isRepeated; // 반복 미션 여부

  late TabController tabController;
  WebViewController webViewController = WebViewController();

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

  // 내가 당일에 인증한 경우 T/F 값
  bool isMeProved = false;

  // 미션 인증시 알림 독려 여부
  bool isFireText = false;

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

  String nobodyText = '데이터를 불러오는 중입니다...';

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
    loadMissionData();
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
      }
      notifyListeners();
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
      }
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
      if(!isMeOrEveryProved && everyMissionList != null && everyMissionList!.isEmpty) {
        nobodyText = '아직 아무도\n인증하지 않았어요';
      }
      else if(isMeOrEveryProved && myMissionList != null && myMissionList!.isEmpty) {
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
  void loadMissionData() async {
    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive';

    try {
      ApiResponse<MyMissionProveAllData> apiResponse =
          await call.makeRequest<MyMissionProveAllData>(
        url: apiUrl,
        method: 'GET',
        fromJson: (dataJson) => MyMissionProveAllData.fromJson(dataJson),
      );

      if(apiResponse.data != null) {
        print('나의 인증 조회중...');
        // 오늘 미션 인증했는지 조회
        isMeProved = apiResponse.data?.today as bool;
        myMissionList = apiResponse.data?.archives;
        if(myMissionList != null && myMissionList!.isNotEmpty) {
          print('총 길이 : ${myMissionList!.length}');
          for(MyMissionProveData data in myMissionList!) {
            myRepeatMissionTime.add(formatDateTime(data.createdDate));
          }
        }
        if(myMissionList != null && myMissionList!.isEmpty) {
          nobodyText = '아직 인증하지 않았어요';
        }
        print('myMissionList Data : ${apiResponse.data!.archives.toString()}');
        print('내가 오늘 인증했나 ? $isMeProved, 미션리스트 비었니? : ${myMissionList?.isEmpty}');
        notifyListeners();
      }
    } catch (e) {
      log('나의 인증 조회 실패: $e');
    }
  }

  /// 모인원 미션 인증 조회
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
                (item) => EveryMissionProveData.fromJson(item as Map<String, dynamic>),
          ),
        ),
      );

      if(apiResponse.isSuccess == true) {
        print('모두의 인증 조회 성공: ${apiResponse.data?.toString()}');
        everyMissionList = apiResponse.data;
      }
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
      submit(isFix: true);
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

      if (apiResponse.data != null) {
        missionTitle = apiResponse.data?['title'];
        missionContent = apiResponse.data?['content'];
        missionRule = apiResponse.data?['rule'];
        missionWay = apiResponse.data?['way'];
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
        print('mission 인증 방식 : ${missionWay}');
        // 남은 시간 계산
        calculateTimeLeft(apiResponse.data?['dueTo']);
      }

      notifyListeners();
    } catch (e) {
      log('나의 성공 횟수 조회 실패: $e');
    }
  }

  /// 미션 인증 API
  Future<void> submitMission({required String url, bool? isFix}) async {
    print('method : ${isFix == true ? 'PUT' : 'POST'}');
    apiUrl =
        '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/archive';
    Map<String, dynamic> data = {"status": 'COMPLETE', "archive": url};

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
          await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: isFix == true ? 'PUT' : 'POST',
        body: data,
        fromJson: (dataJson) => dataJson as Map<String, dynamic>,
      );

      notifyListeners();
      if (apiResponse.data != null) {
        print('미션인증 성공!');
      }
    } catch (e) {
      log('미션인증 실패: $e');
    }
  }

  // 미션 스킵 화면으로 이동
  void missionSkip() async {
    var result = await Navigator.of(context)
        .pushNamed(SkipMissionPage.routeName, arguments: {
      'teamId': teamId,
      'missionId': missionId,
    });

    if(result != null && result == true) {
      initState();
    }
  }

  // 미션 인증하기 버튼 클릭
  void submit({bool? isFix}) async {
    // 텍스트 인증 시
    if (missionWay.contains('텍스트')) {
      var result = await Navigator.of(context)
          .pushNamed(TextAuthPage.routeName, arguments: {
        'teamId': teamId,
        'missionId': missionId,
      });
      if (result != null && result is bool && result) {
        // 미션 인증 성공 모달
        showMissionSuccessDialog();
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
        showMissionSuccessDialog();
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
          isFix == true ? await submitMission(url: imageUrl, isFix: true) :  await submitMission(url: imageUrl);
          showMissionSuccessDialog();
          initState();
        }
      }
      notifyListeners();
    }
  }

  // 이미지 공유하기 모달
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
                                  child: Icon(Icons.close,size: 28,color: grayScaleGrey300,)),
                              SizedBox(width: 32),
                              Text('내 인증 공유하기',
                              style: buttonTextStyle.copyWith(color: grayScaleGrey300)),
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
                                  index != null ? myMissionList![index].archive : myMissionList![0].archive,
                                  width: 313,
                                  height: 313,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 100, // scrim의 높이
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.5), // 하단이 어둡게 처리됨
                                          Colors.transparent,             // 점차 투명해짐
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
                                          index != null ? myRepeatMissionTime[index][0] : myRepeatMissionTime[0][0],
                                          style: bodyTextStyle.copyWith(
                                            color: grayScaleGrey400,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          index != null ? myRepeatMissionTime[index][1] : myRepeatMissionTime[0][1],
                                          style: bodyTextStyle.copyWith(
                                            color: grayScaleGrey400,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                ),
                                Positioned(
                                  bottom: 23,
                                  left: 20,
                                  child: Text('작업한 내용 인증하기',
                                  style: buttonTextStyle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,)),
                                ),
                                Positioned(
                                  bottom: 20,
                                  right: 20,
                                  child: Image.asset(
                                    'asset/image/icon_fire_white.png',
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                            /// 이미지 갤러리에 저장
                            var renderObject = globalKey.currentContext?.findRenderObject();
                            if (renderObject is RenderRepaintBoundary) {
                              var boundary = renderObject;
                              ui.Image image = await boundary.toImage(pixelRatio: 3);
                              final directory = (await getApplicationDocumentsDirectory()).path;
                            ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                            if(byteData != null) {
                              Uint8List pngBytes = byteData.buffer.asUint8List();
                              File imgFile = new File('$directory/screenshot.png');
                              await imgFile.writeAsBytes(pngBytes);

                              // 갤러리에 저장
                              final result = await ImageGallerySaver.saveFile(imgFile.path);
                              if (result['isSuccess'] == true) {
                                // 토스트 문구 출력
                                fToast.showToast(
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 51,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '갤러리에 이미지 저장 성공!',
                                              style: contentTextStyle.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: grayScaleGrey900,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    toastDuration: Duration(milliseconds: 1500),
                                    positionedToastBuilder: (context, child) {
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
                          }},
                            style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            minimumSize: MaterialStateProperty.all<Size>(
                                Size(double.infinity, 62)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(grayScaleGrey500)),
                            child: Text('이미지 저장하기',
                            style: buttonTextStyle.copyWith(color: grayScaleGrey300)),
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

  // 미션 인증 시 모달
  void showMissionSuccessDialog() {
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
                    '모잉불이 기뻐해요!',
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
                        '${singleMissionMyCount + 1}/$singleMissionTotalCount명 인증성공',
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

    Future.delayed(Duration(milliseconds: 1000), () {
      isFireText = true;
      Navigator.of(context).pop();
      notifyListeners();
    });
  }

  /// 미션 상세내용 확인
  void getMissionDetailContent(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
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
                        (myMissionList!.length - index).toString(),
                        style: bodyTextStyle.copyWith(color: grayScaleGrey700),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      DateFormat('yy.MM.dd').format(
                          DateTime.parse(myMissionList![index].createdDate)),
                      style: bodyTextStyle.copyWith(
                          color: grayScaleGrey300, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 12),
                    Text(
                      DateFormat('HH:mm').format(
                          DateTime.parse(myMissionList![index].createdDate)),
                      style: bodyTextStyle.copyWith(
                          color: grayScaleGrey300, fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          print('... 클릭');
                        },
                        child: Icon(
                          Icons.more_vert_outlined,
                          color: grayScaleGrey300,
                        )),
                  ],
                ),
                SizedBox(height: 16),

                /// 사진 텍스트 링크 중 선택
                if (missionWay.contains('사진') && myMissionList![index].status == 'COMPLETE')
                  Container(
                      width: double.infinity,
                      height: 265,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          myMissionList![index].archive,
                          fit: BoxFit.cover,
                        ),
                      )),
                if (missionWay.contains('링크') && myMissionList![index].status == 'COMPLETE')
                  Container(
                    width: double.infinity,
                    height: 265,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: WebViewWidget(
                      controller: webViewController
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..loadRequest(Uri.parse(
                            'https://${myMissionList![index].archive}')),
                    ),
                  ),
                if (missionWay.contains('텍스트') || myMissionList![index].status == 'SKIP')
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 265,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: grayScaleGrey500, width: 1),
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            myMissionList![index].archive,
                            style:
                                contentTextStyle.copyWith(color: grayScaleGrey200),
                          ),
                        ),
                      ),
                      if(myMissionList![index].status == 'SKIP')
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
                Spacer(),

                /// 아래는 버튼 구현
                if (missionWay.contains('사진') && myMissionList![index].status == 'COMPLETE')
                  Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 138,
                                height: 51,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: grayScaleGrey500,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '좋아요 ',
                                      style: contentTextStyle.copyWith(
                                          color: grayScaleGrey100,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      myMissionList![index].hearts.toString(),
                                      style: contentTextStyle.copyWith(
                                          color: coralGrey500),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  print('바텀시트에서 공유하기 버튼 클릭');
                                  missionShareDialog(index: index);
                                },
                                child: Container(
                                  width: 138,
                                  height: 51,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: grayScaleGrey500,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '공유하기',
                                        style: contentTextStyle.copyWith(
                                            color: grayScaleGrey100,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                if (missionWay.contains('텍스트') || missionWay.contains('링크') ||
                myMissionList![index].status == 'SKIP')
                  Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 138,
                            height: 51,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: grayScaleGrey500,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '좋아요 ',
                                  style: contentTextStyle.copyWith(
                                      color: grayScaleGrey100,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  myMissionList![index].hearts.toString(),
                                  style: contentTextStyle.copyWith(
                                      color: coralGrey500),
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
  }

  /// 미션 내용 모달
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
                        missionWay,
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

  // 인증 날짜 변환
  List<String> formatDateTime(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    String formattedDate = DateFormat('yy.MM.dd').format(parsedDate);
    String formattedTime = DateFormat('HH:mm').format(parsedDate);

    return [formattedDate, formattedTime];
  }
}
