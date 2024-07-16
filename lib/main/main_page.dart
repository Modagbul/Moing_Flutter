import 'package:flutter/material.dart';
import 'package:moing_flutter/app/app_state.dart';
import 'package:moing_flutter/config/amplitude_config.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/main/main_appbar.dart';
import 'package:moing_flutter/home/home_screen.dart';
import 'package:moing_flutter/home/home_screen_state.dart';
import 'package:moing_flutter/main/main_state.dart';
import 'package:moing_flutter/missions/aggregate/missions_group_state.dart';
import 'package:moing_flutter/missions/aggregate/missions_screen.dart';
import 'package:moing_flutter/missions/aggregate/missions_state.dart';
import 'package:moing_flutter/mypage/my_page_screen.dart';
import 'package:moing_flutter/mypage/my_page_state.dart';
import 'package:moing_flutter/utils/loading/loading.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  static const routeName = '/main';

  const MainPage({super.key});

  static route(BuildContext context) {
    String newCreated = "";
    int selectedTeamId = 0;

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
          create: (_) => AppState(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) =>
              HomeScreenState(context: context, newCreated: newCreated),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => MissionsState(context: context),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => MissionsGroupState(
              context: context, selectedTeamId: selectedTeamId),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => MyPageState(context: context),
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
    return WillPopScope(
      onWillPop: () async {
        final mainState = context.read<MainState>();

        if (mainState.mainIndex > 0) {
          mainState.moveToHomeScreen();
          return false;
        }
        return true;
      },
      child: FutureBuilder(
        future: _initializeStates(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _mainContent(context);
          } else {
            return Center(
              child: LoadingPage(),
            );
          }
        },
      ),
    );
  }

  Future<void> _initializeStates(BuildContext context) async {
    await context.read<HomeScreenState>().initState();
    await context.read<MissionsState>().initState();
    await context.read<MissionsGroupState>().initState();
    await context.read<MyPageState>().initState();
  }

  Widget _mainContent(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        notificationCount: context.watch<MainState>().alarmCount ?? '0',
        onTapAlarm: context.read<MainState>().alarmPressed,
        onTapSetting: context.read<MainState>().settingPressed,
        screenIndex: context.watch<MainState>().mainIndex,
      ),
      backgroundColor: grayBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          IndexedStack(
            sizing: StackFit.expand,
            index: context.watch<MainState>().mainIndex,
            children: [
              HomeScreen(),
              MissionsScreen(),
              MyPageScreen(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: BottomNavigationBar(
        currentIndex: context.watch<MainState>().mainIndex,
        onTap: (index) async {
          if (index == 1) {
            String? nickname = await AmplitudeConfig.analytics.getUserId();
            AmplitudeConfig.analytics
                .logEvent("missioninprogress_click", eventProperties: {
              "tab": "진행 중 미션 클릭",
              "nickname": nickname ?? "unknown",
            });
          }
          context.read<MainState>().mainIndex = index;
        },
        backgroundColor: grayBackground,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: grayScaleGrey550,
        selectedItemColor: grayScaleGrey100,
        selectedLabelStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: grayScaleGrey100),
        unselectedLabelStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: grayScaleGrey550),
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 6),
              child: Icon(Icons.home),
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 6),
              child: Icon(Icons.tour),
            ),
            label: '진행 중 미션',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 6),
              child: Icon(Icons.person),
            ),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}
