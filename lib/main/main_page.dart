import 'package:flutter/material.dart';
import 'package:moing_flutter/app/app_state.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/home/home_screen.dart';
import 'package:moing_flutter/home/home_screen_state.dart';
import 'package:moing_flutter/main/main_state.dart';
import 'package:moing_flutter/missions/aggregate/missions_group_state.dart';
import 'package:moing_flutter/missions/aggregate/missions_screen.dart';
import 'package:moing_flutter/missions/aggregate/missions_state.dart';
import 'package:moing_flutter/mypage/my_page_screen.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  static const routeName = '/main';

  const MainPage({super.key});

  static route(BuildContext context) {
    String newCreated = "";
    if (ModalRoute.of(context)?.settings.arguments != null) {
      newCreated = ModalRoute.of(context)?.settings.arguments as String;
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MainState(context: context),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => AppState(), // AppState를 추가합니다.
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeScreenState(context: context, newCreated: newCreated),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => MissionsState(context: context), // MissionsState 추가
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => MissionsGroupState(context: context),
          // MissionsState 추가
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
    int teamCount = context.read<HomeScreenState>().futureData?.teamBlocks.length ?? 0;
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
            create: (_) => MissionsState(context: context),
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
                children: [
                  HomeScreen(),
                  MissionsScreen(),
                  MyPageScreen.route(context: context, teamCount: teamCount),
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
              backgroundColor: grayBackground,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: grayScaleGrey550,
              selectedItemColor: grayScaleGrey100,
              selectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: grayScaleGrey100),
              unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: grayScaleGrey550),
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding:
                        EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 6),
                    child: Icon(Icons.home),
                  ),
                  label: '홈',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding:
                        EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 6),
                    child: Icon(Icons.tour),
                  ),
                  label: '미션목록',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding:
                        EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 6),
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
