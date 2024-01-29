import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/board/board_main_page.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_exit_success_page.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_finish_success_page.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/model/api_code/api_code.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/response/exit_teem_info.dart';
import 'package:provider/provider.dart';

class GroupFinishExitState extends ChangeNotifier {
  final BuildContext context;
  final int teamId;
  final String text;
  final ApiCode apiCode = ApiCode();
  String? teamName;

  int finishCount = 0;
  int exitCount = 0;
  String finishButtonText = '소모임 강제종료하기';
  String exitButtonText = '소모임 탈퇴하기';
  String exitDescription = '';

  String apiUrl = '';
  APICall call = APICall();
  ExitTeamInfo? teamInfo;

  bool onLoading = false;

  GroupFinishExitState({
    required this.context, required this.teamId, required this.text, required this.teamName}) {
    print('teamName : $teamName');
    initState();
  }

  void initState() async {
    await loadExitData();
  }

  /// 삭제 전 조회 API
  Future<void> loadExitData() async {
    apiUrl = '${dotenv.env['MOING_API']}/api/team/$teamId/review';

    try {
      ApiResponse<ExitTeamInfo> apiResponse =
      await call.makeRequest<ExitTeamInfo>(
        url: apiUrl,
        method: 'GET',
        fromJson: (dataJson) => ExitTeamInfo.fromJson(dataJson),
      );

      if (apiResponse.data != null) {
        teamInfo = apiResponse.data;
        log('삭제 전 조회 성공!');

        /// 소모임장인 경우
        if(teamInfo != null && teamInfo!.isLeader == true) {
          finishButtonText = '소모임 강제종료하기';
          exitDescription = '소모임 강제종료 시 모든 모임원들은\n자동 탈퇴처리 돼요.\n3일의 안내기간이 지나면 삭제될 예정이에요.';
        }
        else {
          // 소모임원인 경우
          finishButtonText = '소모임 탈퇴하기';
          exitDescription = '탈퇴 시 ${teamInfo!.memberName}님의\n해당 소모임 미션활동 정보가 삭제돼요.\n한번 탈퇴하면 다시 돌아올 수 없어요';
        }
        notifyListeners();
        }

      else {
        print('loadExitData is Null, error code : ${apiResponse.errorCode}');
      }
    } catch (e) {
      log('나의 성공 횟수 조회 실패: $e');
    }
  }

  /// 소모임 강제종료하기 버튼 클릭 시
  void finishPressed() async {
    /// 모임원이 1명인 소모임
    if(teamInfo != null) {
      int deleteTeamId;
      if(teamInfo!.numOfMember == 1) {
        deleteTeamId = await apiCode.deleteTeam(teamId: teamId);
        if(deleteTeamId == teamId) {
          Navigator.pushReplacementNamed(
            context,
            GroupFinishSuccessPage.routeName,
            arguments: {
              'teamId': teamId,
              'text': '소모임 강제 종료가\n완료되었어요.'
            },
          );
          notifyListeners();
        }
      } else {
        finishCount++;
        if(teamInfo!.isLeader) {
          finishButtonText = '강제종료 완료하기';
        } else {
          finishButtonText = '소모임 탈퇴 완료하기';
        }
      }
    }
    notifyListeners();

    /// 한 번 더 누르면 소모임 강제 종료 신청
    if (finishCount >= 2) {
      if(onLoading) return;
      onLoading = true;

      int deleteTeamId;
      // 소모임 장인 경우
      if(teamInfo != null) {
        if(teamInfo!.isLeader) {
          deleteTeamId = await apiCode.deleteTeam(teamId: teamId);
          onLoading = false;
          if(deleteTeamId == teamId) {
            Navigator.pushReplacementNamed(
              context,
              GroupFinishSuccessPage.routeName,
              arguments: {
                'teamId': teamId,
                'text': '소모임 강제 종료\n신청이 완료되었어요.',
                'teamName': teamInfo!.teamName,
              },
            );
          }
        }
        else {
          deleteTeamId = await apiCode.deleteTeamUser(teamId: teamId);
          onLoading = false;
          if(deleteTeamId == teamId) {
            Navigator.pushReplacementNamed(
              context,
              GroupExitApplyPage.routeName,
              arguments: teamId,
            );
          }
        }
      }
    }
  }

  /// 소모임 탈퇴 버튼 클릭 시
  void exitPressed() {
    exitCount++;
    exitButtonText = '소모임 탈퇴 완료하기';
    notifyListeners();

    /// 한 번 더 누르면 소모임 탈퇴 신청
    if (exitCount >= 2) {
      Navigator.of(context).pushNamed(
        GroupExitApplyPage.routeName,
      );
    }
  }

  // 강제종료 성공 후 목표보드로 되돌아갈 때
  void finishSuccessPressed() {
    if(text.contains('종료가')) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainPage.routeName,
            (route) => false,
      );
    }
    else {
      Navigator.pushNamed(context, BoardMainPage.routeName, arguments: {'teamId': teamId});
    }
  }
}
