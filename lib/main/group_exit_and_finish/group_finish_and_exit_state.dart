import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moing_flutter/board/board_main_page.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_exit_success_page.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_finish_success_page.dart';
import 'package:moing_flutter/model/api_generic.dart';
import 'package:moing_flutter/model/api_response.dart';
import 'package:moing_flutter/model/response/exit_teem_info.dart';

class GroupFinishExitState extends ChangeNotifier {
  final BuildContext context;
  final int teamId;

  int finishCount = 0;
  int exitCount = 0;
  String finishButtonText = '소모임 강제종료하기';
  String exitButtonText = '소모임 탈퇴하기';

  String apiUrl = '';
  APICall call = APICall();
  ExitTeamInfo? teamInfo;

  GroupFinishExitState({required this.context, required this.teamId}) {
    print('Instance "GroupFinishExitState" has been created');
    loadExitData();
  }

  /// 삭제 전 조회 API
  void loadExitData() async {
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
        print('삭제 전 조회 성공!');
        }

      notifyListeners();
    } catch (e) {
      log('나의 성공 횟수 조회 실패: $e');
    }
  }

  /// 소모임 강제종료하기 버튼 클릭 시
  void finishPressed() {
    finishCount++;
    finishButtonText = '강제종료 완료하기';
    notifyListeners();

    /// 한 번 더 누르면 소모임 강제 종료 신청
    if (finishCount >= 2) {
      Navigator.pushReplacementNamed(
        context,
        GroupFinishSuccessPage.routeName,
        arguments: teamId,
      );
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
    Navigator.pushNamed(context, BoardMainPage.routeName, arguments: teamId);
  }
}
