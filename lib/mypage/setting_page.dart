import 'package:flutter/material.dart';
import 'package:moing_flutter/mypage/alarm_setting_page.dart';
import 'package:moing_flutter/mypage/revoke/mypage_revoke_page.dart';
import 'package:moing_flutter/mypage/revoke/mypage_revoke_reason_page.dart';
import 'package:moing_flutter/mypage/setting_state.dart';
import 'package:moing_flutter/utils/app_bar/moing_app_bar.dart';
import 'package:provider/provider.dart';

import '../const/color/colors.dart';
import '../login/sign_in/login_page.dart';
import '../make_group/component/warning_dialog.dart';
import '../model/api_code/api_code.dart';
import '../model/response/sign_out_response.dart';
import '../utils/shared_preferences/shared_preferences.dart';
import 'component/list_custom_tile.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final ApiCode apiCode = ApiCode();

  static const routeName = '/mypage/setting';

  static route(BuildContext context) {
    final int teamCount = ModalRoute.of(context)?.settings.arguments as int;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingState(context: context, teamCount: teamCount)),
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
        imagePath: 'asset/image/arrow_left.png',
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
                      imagePath: 'asset/image/right_arrow.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AlarmSettingPage.route(context)),
                        );
                      }),
                  ListCustomTile(
                    listName: '개인정보 처리 방침',
                    imagePath: 'asset/image/right_arrow.png',
                    onTap: () {},
                  ),
                  ListCustomTile(
                    listName: '로그아웃',
                    imagePath: 'asset/image/right_arrow.png',
                    onTap: () => _showLogoutDialog(context),
                  ),
                  ListCustomTile(
                    listName: '회원탈퇴',
                    imagePath: 'asset/image/right_arrow.png',
                    onTap: () {
                      int teamCount = Provider.of<SettingState>(context, listen: false).teamCount;
                      print('teamCount : $teamCount');
                      if(teamCount != 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyPageRevokePage()),
                        );
                      }
                      else {
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

  // void _showLogoutDialog(BuildContext context, ApiCode apiCode) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return WarningDialog(
  //         title: '정말 로그아웃하시겠어요?',
  //         content: '데이터는 그대로 보존되지만 푸시알림을 받을 수 없어요',
  //         onConfirm: () async {
  //           Navigator.of(context).pop();
  //           SharedPreferencesInfo prefsInfo = SharedPreferencesInfo();
  //           String? userIdString = await prefsInfo.loadPreferencesData('userId');
  //           int? userId = userIdString != null ? int.tryParse(userIdString) : null;
  //           if (userId != null) {
  //             final signOutResponse = await apiCode.signOut(userId: userId);
  //             if (signOutResponse != null && signOutResponse.isSuccess) {
  //               print('로그아웃 성공: ${signOutResponse.message}');
  //               Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, (route) => false);
  //             } else {
  //               print('로그아웃 실패: ${signOutResponse?.message ?? 'Unknown error'}');
  //             }
  //           } else {
  //             print('로그아웃 실패: 사용자 ID가 없습니다.');
  //           }
  //         },
  //         onCanceled: () => Navigator.of(context).pop(),
  //         leftText: '로그아웃',
  //         rightText: '남아있기',
  //       );
  //     },
  //   );
  // }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          title: '정말 로그아웃하시겠어요?',
          content: '데이터는 그대로 보존되지만 푸시알림을 받을 수 없어요',
          onConfirm: () async {
            Navigator.of(context).pop();
            await _logout(context);
          },
          onCanceled: () => Navigator.of(context).pop(),
          leftText: '로그아웃',
          rightText: '남아있기',
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferencesInfo prefsInfo = SharedPreferencesInfo();
    String? accessToken = await prefsInfo.loadPreferencesData('accessToken');

    if (accessToken != null) {
      final signOutResponse = await apiCode.signOut(accessToken: accessToken);
      if (signOutResponse != null && signOutResponse.isSuccess) {
        await prefsInfo.removePreferencesData('accessToken');
        await prefsInfo.removePreferencesData('refreshToken');
        Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, (route) => false);
      } else {
        print('로그아웃 실패: ${signOutResponse?.message ?? 'Unknown error'}');
      }
    } else {
      print('로그아웃 실패: 액세스 토큰이 없습니다.');
    }
  }

}

