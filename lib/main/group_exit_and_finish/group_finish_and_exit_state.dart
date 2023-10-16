import 'package:flutter/cupertino.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_exit_success_page.dart';
import 'package:moing_flutter/main/group_exit_and_finish/group_finish_success_page.dart';

class GroupFinishExitState extends ChangeNotifier {
  final BuildContext context;
  int finishCount = 0;
  int exitCount = 0;
  String finishButtonText = '소모임 강제종료하기';
  String exitButtonText = '소모임 탈퇴하기';

  GroupFinishExitState({required this.context}) {
    print('Instance "GroupFinishExitState" has been created');
  }

  /// 소모임 강제종료하기 버튼 클릭 시
  void finishPressed() {
    finishCount++;
    finishButtonText = '강제종료 완료하기';
    notifyListeners();

    /// 한 번 더 누르면 소모임 강제 종료 신청
    if(finishCount >= 2) {
      Navigator.of(context).pushNamed(
        GroupFinishSuccessPage.routeName,
      );
    }
  }
  
  /// 소모임 탈퇴 버튼 클릭 시
  void exitPressed() {
    exitCount++;
    exitButtonText = '소모임 탈퇴 완료하기';
    notifyListeners();

    /// 한 번 더 누르면 소모임 탈퇴 신청
    if( exitCount >= 2) {
      Navigator.of(context).pushNamed(
        GroupExitApplyPage.routeName,
      );
    }
  }
}