import 'package:flutter/material.dart';
import 'package:moing_flutter/init/init_page.dart';
import 'package:moing_flutter/mypage/alarm_setting_page.dart';
import 'package:moing_flutter/mypage/revoke/mypage_revoke_page.dart';
import 'package:moing_flutter/mypage/revoke/mypage_revoke_reason_page.dart';
import 'package:moing_flutter/mypage/setting_state.dart';
import 'package:moing_flutter/utils/app_bar/moing_app_bar.dart';
import 'package:moing_flutter/utils/shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../const/color/colors.dart';
import '../make_group/component/warning_dialog.dart';
import '../model/api_code/api_code.dart';
import 'blocked_users_page.dart';
import 'component/list_custom_tile.dart';
import 'component/question_dialog.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final ApiCode apiCode = ApiCode();

  static const routeName = '/mypage/setting';

  static route(BuildContext context) {
    final int teamCount = ModalRoute.of(context)?.settings.arguments as int;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                SettingState(context: context, teamCount: teamCount)),
      ],
      builder: (context, _) {
        return SettingPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoingAppBar(
        title: '환경설정',
        imagePath: 'asset/icons/arrow_left.svg',
        onTap: () => Navigator.pop(context),
      ),
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: 8.0),
                  ListCustomTile(
                      listName: '알림설정',
                      imagePath: 'asset/icons/right_arrow.svg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AlarmSettingPage.route(context)),
                        );
                      }),
                  ListCustomTile(
                    listName: '개인정보 처리 방침',
                    imagePath: 'asset/icons/right_arrow.svg',
                    onTap: () async {
                      String link =
                          'https://docs.google.com/document/d/18R3xXUVD_c2GCowrmo4KdMHkkosFkMQFqXD_1TaJSgs/edit';
                      Uri _url = Uri.parse(link);
                      if (!await launchUrl(
                        _url,
                        mode: LaunchMode.externalApplication,
                      )) {
                        throw ArgumentError("해당 링크에 접속할 수 없습니다.");
                      }
                      print('개인정보 처리 방침 클릭!');
                    },
                  ),
                  ListCustomTile(
                      listName: '차단멤버 관리',
                      imagePath: 'asset/icons/right_arrow.svg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BlockedUsersPage.route(context)),
                        );
                      }),
                  ListCustomTile(
                    listName: '문의하기',
                    imagePath: 'asset/icons/right_arrow.svg',
                    onTap: () => _showQuestionDialog(context),
                  ),
                  ListCustomTile(
                    listName: '로그아웃',
                    imagePath: 'asset/icons/right_arrow.svg',
                    onTap: () => _showLogoutDialog(context),
                  ),
                  ListCustomTile(
                    listName: '회원탈퇴',
                    imagePath: 'asset/icons/right_arrow.svg',
                    onTap: () {
                      int teamCount =
                          Provider.of<SettingState>(context, listen: false)
                              .teamCount;
                      print('회원 탈퇴를 위해 teamCount 조회 : $teamCount');
                      if (teamCount != 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyPageRevokePage()),
                        );
                      } else {
                        Navigator.of(context).pushNamed(
                          MyPageRevokeReasonPage.routeName,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WarningDialog(
              title: '정말 로그아웃하시겠어요?',
              content: '데이터는 그대로 보존되지만 푸시알림을 받을 수 없어요',
              onConfirm: () async {
                await _logout(context);
              },
              onCanceled: () => Navigator.of(context).pop(),
              leftText: '남아있기',
              rightText: '로그아웃',
            ),
          ],
        );
      },
    );
  }

  void _showQuestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            QuestionDialog(
              title: '문의하실 일이 있나요?',
              content:
                  '서비스 이용에 대한 문의 또는 피드백은\n moing.official@gmail.com로 보내주세요!',
              onConfirm: () => Navigator.pop(context),
              btnText: '확인했어요',
            ),
          ],
        );
      },
    );
  }

  _logout(BuildContext context) async {
    bool? signOutResponse = await apiCode.signOut();
    print('로그아웃 Response : ${signOutResponse.toString()}');
    if (signOutResponse != null && signOutResponse) {
      print('settingPage에서 로그아웃 성공 : ${signOutResponse.toString()}');

      SharedPreferencesInfo sharedPreferencesInfo = SharedPreferencesInfo();
      sharedPreferencesInfo.removePreferencesData('ACCESS_TOKEN');
      sharedPreferencesInfo.removePreferencesData('REFRESH_TOKEN');
      Navigator.of(context).pop();
      Navigator.pushNamedAndRemoveUntil(
          context, InitPage.routeName, (route) => false);
    } else {
      print('로그아웃 에러 발생');
    }
  }
}
