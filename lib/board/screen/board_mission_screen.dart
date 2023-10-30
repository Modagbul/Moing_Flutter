// BoardMissionScreen.dart
import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:provider/provider.dart';

import 'board_mission_state.dart';
import 'completed_mission_page.dart';
import 'ongoing_misson_page.dart';
import 'ongoing_misson_state.dart';

class BoardMissionScreen extends StatefulWidget {
  // static const routeName = '/board/mission';

  const BoardMissionScreen({Key? key}) : super(key: key);

  // static route(BuildContext context) {
  //   // final dynamic arguments = ModalRoute.of(context)?.settings.arguments;
  //   // final int teamId = arguments as int;
  //
  //   return MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(
  //         create: (_) => BoardMissionState(context: context),
  //       ),
  //       // OngoingMissionState 프로바이더를 추가합니다.
  //       // ChangeNotifierProvider(
  //       //   create: (_) => OngoingMissionState(context: context, teamId: teamId),
  //       // ),
  //     ],
  //     builder: (context, _) {
  //       return const BoardMissionScreen();
  //     },
  //   );
  // }


  @override
  State<BoardMissionScreen> createState() => _BoardMissionScreenState();
}

class _BoardMissionScreenState extends State<BoardMissionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 1.0, // 원하는 높이 설정
                  color: grayScaleGrey550, // 회색으로 설정
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 210), // 오른쪽에 여백 주기
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: grayScaleGrey200,
                  labelColor: grayScaleGrey200,
                  unselectedLabelColor: grayScaleGrey550,
                  tabs: [
                    _customTab(text: '진행중 미션'),
                    _customTab(text: '종료된 미션'),
                  ],
                  labelPadding: EdgeInsets.zero, // 탭바 내부의 기본 패딩 제거
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                OngoingMissionPage(),
                CompletedMissionPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Tab _customTab({required String text}) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8), // 텍스트 크기에 따라 여백 조정
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
