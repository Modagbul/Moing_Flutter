import 'package:flutter/material.dart';
import 'package:moing_flutter/mypage/alram_setting_page.dart';
import 'package:moing_flutter/mypage/revoke/mypage_revoke_page.dart';
import 'package:moing_flutter/mypage/setting_state.dart';
import 'package:moing_flutter/utils/app_bar/moing_app_bar.dart';
import 'package:provider/provider.dart';

import '../const/color/colors.dart';
import '../make_group/component/warning_dialog.dart';
import '../model/response/sign_out_response.dart';
import '../utils/shared_preferences/shared_preferences.dart';
import 'component/list_custom_tile.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  static const routeName = '/mypage/setting';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingState(context: context)),
      ],
      builder: (context, _) {
        return const SettingPage();
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
                          MaterialPageRoute(builder: (context) => AlramSettingPage()),
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
                    onTap: () {
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
                                  Navigator.of(context).pop();
                                  // // SharedPreferences에서 사용자 ID를 불러옴
                                  // SharedPreferencesInfo prefsInfo = SharedPreferencesInfo();
                                  //
                                  // String? userIdString = await prefsInfo.loadPreferencesData('userId');
                                  // int? userId;
                                  // if (userIdString != null) {
                                  //   userId = int.tryParse(userIdString);
                                  // }
                                  //
                                  // // 사용자 ID가 null이 아니면 로그아웃 함수 호출
                                  // if (userId != null) {
                                  //   // 로그아웃 로직을 수행
                                  //   SignOutResponse? response = await signOut(userId: userId);
                                  //   if (response != null && response.isSuccess) {
                                  //     // 로그아웃 성공 로직
                                  //     print('로그아웃 성공: ${response.message}');
                                  //     // 로그인 화면으로 이동하는 코드
                                  //   } else {
                                  //     // 로그아웃 실패 로직
                                  //     print('로그아웃 실패: ${response?.message ?? 'Unknown error'}');
                                  //   }
                                  // } else {
                                  //   // 사용자 ID가 null인 경우 오류 메시지 출력
                                  //   print('로그아웃 실패: 사용자 ID가 없습니다.');
                                  // }
                                },
                                onCanceled: () {
                                  Navigator.of(context).pop();
                                },
                                leftText: '로그아웃',
                                rightText: '남아있기',
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  ListCustomTile(
                    listName: '회원탈퇴',
                    imagePath: 'asset/image/right_arrow.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyPageRevokePage()),
                      );
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
}
