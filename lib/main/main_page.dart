import 'package:flutter/material.dart';
import 'package:moing_flutter/app/app_state.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/home/home_screen.dart';
import 'package:moing_flutter/home/home_screen_state.dart';
import 'package:moing_flutter/main/main_state.dart';
import 'package:moing_flutter/missions/missions_screen.dart';
import 'package:moing_flutter/missions/missions_state.dart';
import 'package:moing_flutter/mypage/my_page.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  static const routeName = '/main';
  const MainPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MainState(context: context),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => AppState(),  // AppState를 추가합니다.
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeScreenState(context: context),
          lazy: false,
        ),
      ],
      builder: (context, snapshot) {
        return const MainPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /// 사용자 정보 없으면 첫 페이지로 돌아가기 (API 추가 예정)
    // final MeState meState = context.read<MeState>();
    // if (meState.me == null) {
    //   WidgetsBinding.instance.addPostFrameCallback(
    //         (_) {
    //       Navigator.pushNamedAndRemoveUntil(
    //         context,
    //         InitPage.routeName,
    //         ModalRoute.withName(InitPage.routeName),
    //       );
    //     },
    //   );
    // }
    return WillPopScope(
      onWillPop: () async {
        final appState = context.read<AppState>();

        if (appState.mainIndex > 0) {
          appState.moveToHomeScreen();
          return false;
        }

        return true;
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => MissionState(),
            lazy: false,
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            fit: StackFit.expand,
            children: [
              IndexedStack(
                sizing: StackFit.expand,
                index: context.watch<AppState>().mainIndex,
                children: const [
                  HomeScreen(),
                  MissionsScreen(),
                  MyPageScreen(),
                ],
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: BottomNavigationBar(
              currentIndex: context.watch<AppState>().mainIndex,
              onTap: (index) {
                context.read<AppState>().mainIndex = index;
              },
              backgroundColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: grayScaleGrey550,
              selectedItemColor: grayScaleGrey100,
              selectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: grayScaleGrey100),
              unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: grayScaleGrey550),
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 8, left: 8, right: 8,bottom: 6),
                    child: Icon(Icons.home),
                  ),
                  label: '홈',
                ),
                // BottomNavigationBarItem(
                //   icon: Stack(
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                //         child: Icon(Icons.chat_bubble_rounded),
                //       ),
                //       Positioned(
                //         top: 0,
                //         left: 0,
                //         child: Container(
                //           decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                //           padding: EdgeInsets.symmetric(horizontal: 4),
                //         ),
                //       ),
                //     ],
                //   ),
                //   label: '내 상담',
                // ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 8, left: 8, right: 8,bottom: 6),
                    child: Icon(Icons.tour),
                  ),
                  label: '미션목록',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 8, left: 8, right: 8,bottom: 6),
                    child: Icon(Icons.person),
                  ),
                  label: '마이페이지',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
