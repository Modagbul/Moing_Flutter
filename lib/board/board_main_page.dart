import 'package:flutter/material.dart';
import 'package:moing_flutter/board/screen/board_goal_screen.dart';
import 'package:moing_flutter/board/board_main_state.dart';
import 'package:moing_flutter/board/screen/board_mission_screen.dart';
import 'package:moing_flutter/board/component/board_main_bottom_sheet.dart';

import 'package:moing_flutter/const/color/colors.dart';
import 'package:provider/provider.dart';

class BoardMainPage extends StatefulWidget {
  static const routeName = '/board/main';

  const BoardMainPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BoardMainState(context: context)),
      ],
      builder: (context, _) {
        return const BoardMainPage();
      },
    );
  }

  @override
  State<BoardMainPage> createState() => _BoardMainPageState();
}

class _BoardMainPageState extends State<BoardMainPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read<BoardMainState>().initTabController(
          tabController: TabController(
            length: 2,
            vsync: this,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    const title = '소모임 이름';

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: renderAppBar(context: context, title: title),
      body: Column(
        children: [
          TabBar(
            controller: context.read<BoardMainState>().tabController,
            tabs: const [
              Tab(text: '목표보드'),
              Tab(text: '미션목록'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: context.read<BoardMainState>().tabController,
              children: const [
                BoardGoalScreen(),
                BoardMissionScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget renderAppBar({
    required BuildContext context,
    required String title,
  }) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(title),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            showGroupControlBottomSheet(
              context: context,
            );
          },
          icon: const Icon(Icons.more_vert),
        )
      ],
    );
  }

  void showGroupControlBottomSheet({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      backgroundColor: grayScaleGrey600,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      builder: (BuildContext context) {
        return const BoardMainBottomSheet();
      },
    );
  }
}
