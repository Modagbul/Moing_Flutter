import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/make_group/component/warning_dialog.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:moing_flutter/missions/fix/mission_fix_data.dart';
import 'package:moing_flutter/missions/fix/mission_fix_page.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/utils/button/white_button.dart';
import 'package:provider/provider.dart';

class MissionState {
  /// 사용자 차단 클릭 시
  Future<String> showUserBlockModal({
    required BuildContext context,
    required int makerId,
    required String nickname,
  }) async {
    var result = await showDialog(
      context: context,
      builder: (ctx) {
        String title = "'$nickname'님을 차단하시겠어요?";
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WarningDialog(
              title: title,
              content: '차단한 이용자의 콘텐츠가 더 이상 표시되지 않아요\n[설정>차단 멤버 관리]에서 언제든 해제할 수 있어요',
              onConfirm: () {
                Navigator.of(ctx).pop(true);
              },
              onCanceled: () {
                Navigator.of(ctx).pop();
              },
              leftText: '취소하기',
              rightText: '차단하기',
            ),
          ],
        );
      },
    );
    return (result != null && result == true) ? 'userBlock' : 'false';
  }

  /// 미션 더보기 클릭 시
  Future<String> showMoreDetails({
    required BuildContext context,
    required String missionTitle,
    required String missionContent,
    required String missionRule,
    required String dueTo,
    required bool isRepeated,
    required int teamId,
    required int missionId,
    required int repeatCount,
    required String missionWay,
  }) async {
    MissionFixData data = MissionFixData(
      missionTitle: missionTitle,
      missionContent: missionContent,
      missionDueto: dueTo,
      missionRule: missionRule,
      isRepeated: isRepeated,
      teamId: teamId,
      missionId: missionId,
      repeatCount: repeatCount,
      missionWay: missionWay,
    );

    var modalResult = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 200,
          decoration: const BoxDecoration(
            color: grayScaleGrey600,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isRepeated
                    ? Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              print('반복미션 종료하기 클릭');
                              var endResult =
                                  await showEndRepeatModal(context: context);
                              (endResult.runtimeType == String &&
                                      endResult == 'end')
                                  ? Navigator.of(context).pop('end')
                                  : Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'asset/icons/repeat_mission_end.svg',
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 24),
                                  Text(
                                    '반복미션 종료하기',
                                    style: middleTextStyle.copyWith(
                                        color: grayScaleGrey100),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              print('한번미션 종료하기 클릭');
                              var endResult = await showEndOnceModal(context: context);
                              (endResult.runtimeType == String && endResult == 'end')
                                  ? Navigator.of(context).pop('end')
                                  : Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'asset/icons/repeat_mission_end.svg',
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 24),
                                  Text(
                                    '한번미션 종료하기',
                                    style: middleTextStyle.copyWith(
                                        color: grayScaleGrey100),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(height: 16),
                        ],
                      ),
                // GestureDetector(
                //   onTap: () async {
                //     print('미션 수정하기 클릭');
                //     var result = await Navigator.of(context).pushNamed(MissionFixPage.routeName, arguments: data);
                //     if(result != null && result == true) {
                //       Navigator.of(context).pop(true);
                //     }
                //     else {
                //       Navigator.of(context).pop();
                //     }
                //   },
                //   child: Container(
                //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         SvgPicture.asset(
                //           'asset/icons/mission_skip.svg',
                //           width: 32,
                //           height: 32,
                //           fit: BoxFit.cover,
                //         ),
                //         SizedBox(width: 24),
                //         Text(
                //           '미션 수정하기',
                //           style: middleTextStyle.copyWith(color: grayScaleGrey100),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 16),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 62,
                      decoration: BoxDecoration(
                        color: grayScaleGrey500,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '닫기',
                        style:
                            buttonTextStyle.copyWith(color: grayScaleGrey300),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (modalResult == 'end') {
      return 'end';
    } else if (modalResult == true) {
      return 'true';
    } else {
      return 'false';
    }
  }

  /// 반복미션 종료 바텀모달
  Future<String> showEndRepeatModal({required BuildContext context}) async {
    var result = await showDialog(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WarningDialog(
              title: '반복미션을 종료하시겠어요?',
              content: '종료하면 해당 반복미션은 더 이상 인증할 수 없어요',
              onConfirm: () {
                Navigator.of(ctx).pop(true);
              },
              onCanceled: () {
                Navigator.of(ctx).pop();
              },
              leftText: '취소하기',
              rightText: '종료하기',
            ),
          ],
        );
      },
    );
    return (result != null && result == true) ? 'end' : 'false';
  }

  /// 반복미션 종료 바텀모달
  Future<String> showEndOnceModal({required BuildContext context}) async {
    var result = await showDialog(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WarningDialog(
              title: '한번미션을 종료하시겠어요?',
              content: '종료하면 해당 한번미션은 더 이상 인증할 수 없어요',
              onConfirm: () {
                Navigator.of(ctx).pop(true);
              },
              onCanceled: () {
                Navigator.of(ctx).pop();
              },
              leftText: '취소하기',
              rightText: '종료하기',
            ),
          ],
        );
      },
    );
    return (result != null && result == true) ? 'end' : 'false';
  }

  /// 미션 내용, 규칙 클릭 시
  Future<String?> showContentAndRule({
    required BuildContext context,
    required String missionWay,
    required String missionContent,
    required String missionRule,
    required bool isLeader,
    required String dueTo,
    required bool isRepeated,
    required int teamId,
    required int missionId,
    required int repeatCount,
    required String missionTitle,
    bool? isRead,
  }) async {
    print('미션 설명 클릭');
    MissionFixData data = MissionFixData(
      missionTitle: missionTitle,
      missionContent: missionContent,
      missionDueto: dueTo,
      missionRule: missionRule,
      isRepeated: isRepeated,
      teamId: teamId,
      missionId: missionId,
      repeatCount: repeatCount,
      missionWay: missionWay,
    );

    var result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 482,
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
                      '미션 설명',
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
                  '미션 설명과 규칙을 확인해주세요',
                  style: contentTextStyle.copyWith(
                      fontWeight: FontWeight.w600, color: grayScaleGrey100),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Text(
                        missionContent,
                        style: bodyTextStyle.copyWith(
                            fontWeight: FontWeight.w500, color: grayScaleGrey400),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: isLeader
                      ? GestureDetector(
                      onTap: () async {
                        print('미션 수정하기 클릭');
                        var result = await Navigator.of(context).pushNamed(MissionFixPage.routeName, arguments: data);
                        if(result != null && result == true) {
                          print('미션을 수정하였습니다.');
                          Navigator.of(context).pop("fix");
                        }
                        else {
                          Navigator.of(context).pop();
                        }
                      },
                        child: Container(
                    decoration: BoxDecoration(
                        color: grayScaleGrey500,
                        borderRadius: BorderRadius.circular(16),
                    ),
                    width: double.infinity,
                    height: 62,
                    child: Center(child: Text('미션 수정하기', style: buttonTextStyle.copyWith(color: Colors.white),)),
                  ),
                      )
                      : WhiteButton(
                      onPressed: () => Navigator.of(context).pop(),
                      text: '확인했어요'),
                ),
              ],
            ),
          ),
        );
      },
    );
    /// 미션 설명 읽음 처리
    bool read = false;
    if(isRead == false) {
      read = await readMissionRule(teamId, missionId);
    }
    if (result == "fix") return "missionFix_$read";
    return null;
  }

  /// 미션 읽음 처리
  Future<bool> readMissionRule(int teamId, int missionId) async {
    String apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/missions/$missionId/confirm';
    APICall call = APICall();

    try {
      ApiResponse<Map<String, dynamic>> apiResponse =
      await call.makeRequest<Map<String, dynamic>>(
        url: apiUrl,
        method: 'POST',
        fromJson: (dataJson) => dataJson as Map<String, dynamic>,
      );
      print('미션 설명 읽기에 성공했습니다!');
      return apiResponse.isSuccess ? true : false;
    } catch (e) {
      print('미션 설명 읽기 실패: $e');
      return false;
    }
  }

  /// 미션 인증하기 클릭 시 바텀 모달
  Future<String?> MissionSuccessPressed({
    required BuildContext context,
  }) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 200,
          decoration: const BoxDecoration(
            color: grayScaleGrey600,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print('미션 인증하기 클릭!');
                    Navigator.of(context).pop('submit');
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    height: 64,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'asset/icons/mission_certificate.svg',
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 24),
                        Text(
                          '미션 인증하기',
                          style:
                              buttonTextStyle.copyWith(color: grayScaleGrey200),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    print('미션 건너뛰기 클릭!');
                    Navigator.of(context).pop('skip');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'asset/icons/mission_skip.svg',
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 24),
                      Text(
                        '미션 건너뛰기',
                        style:
                            buttonTextStyle.copyWith(color: grayScaleGrey200),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
