import 'package:flutter/material.dart';
import 'package:moing_flutter/board/screen/board_goal_screen.dart';
import 'package:moing_flutter/board/screen/board_mission_screen.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class MissionProveTabBar extends StatelessWidget {
  const MissionProveTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.47,
          child: _CustomTabBar(
            tabs: const [
              '나의 인증',
              '모두의 인증',
            ],
            tabController: context.read<MissionProveState>().tabController,
          ),
        ),
        Divider(
          height: 0.1,
          color: grayScaleGrey600,
        ),
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 300,
          color: Colors.white,
          child: TabBarView(
            controller: context.read<MissionProveState>().tabController,
            children: [
              Text('HI~', style: TextStyle(color: Colors.white),),
              Text('Hello~',style: TextStyle(color: Colors.white),),
              // BoardGoalScreen(),
              // BoardMissionScreen(),
            ],
          ),
        ),
      ],
    );
  }
}

class _CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final TabController tabController;

  const _CustomTabBar({
    required this.tabs,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: grayScaleGrey100,
      labelStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelColor: grayScaleGrey550,
      unselectedLabelStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
      indicatorColor: grayScaleGrey100,
      controller: tabController,
      tabs: tabs.map((tabText) {
        return Tab(text: tabText);
      }).toList(),
    );
  }
}
