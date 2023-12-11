import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/board/board_main_state.dart';
import 'package:moing_flutter/board/screen/completed_mission_state.dart';
import 'package:moing_flutter/board/screen/ongoing_misson_state.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:provider/provider.dart';

import 'board_mission_state.dart';
import 'completed_mission_page.dart';
import 'ongoing_misson_page.dart';

class BoardMissionScreen extends StatefulWidget {
  static const routeName = '/board/mission';
  BoardMissionScreen({Key? key}) : super(key: key);

  @override
  State<BoardMissionScreen> createState() => _BoardMissionScreenState();
}

class _BoardMissionScreenState extends State<BoardMissionScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BoardMissionState>().initTabController(
            tabController: TabController(
              length: 2,
              vsync: this,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabController = context.select<BoardMissionState, TabController?>(
      (state) => state.tabController,
    );

    if (tabController == null) {
      return Container();
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OngoingMissionState(
            context: context,
            teamId: context.watch<BoardMainState>().teamId,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CompletedMissionState(
            context: context,
            teamId: context.watch<BoardMainState>().teamId,
          ),
        ),
      ],
      child: Scaffold(
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
                    color: grayScaleGrey600, // 회색으로 설정
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 150), // 오른쪽에 여백 주기
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TabBar(
                      controller: tabController,
                      indicatorColor: grayScaleGrey200,
                      labelColor: grayScaleGrey200,
                      unselectedLabelColor: grayScaleGrey550,
                      tabs: [
                        _customTab(text: '진행중 미션'),
                        _customTab(text: '종료된 미션'),
                      ],
                      labelPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  OngoingMissionPage(),
                  // CompletedMissionPage.route(context),
                  CompletedMissionPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Tab _customTab({required String text}) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8), // 텍스트 크기에 따라 여백 조정
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
