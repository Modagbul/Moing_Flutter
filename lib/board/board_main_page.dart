import 'package:flutter/material.dart';
import 'package:moing_flutter/board/screen/board_goal_screen.dart';
import 'package:moing_flutter/board/board_main_state.dart';
import 'package:moing_flutter/board/screen/board_mission_screen.dart';
import 'package:moing_flutter/board/component/board_main_bottom_sheet.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:provider/provider.dart';

class BoardMainPage extends StatefulWidget {
  static const routeName = '/board/main';

  const BoardMainPage({Key? key}) : super(key: key);

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
      backgroundColor: grayScaleGrey900,
      appBar: renderAppBar(context: context, title: title),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: _CustomTabBar(
              tabs: const [
                '목표보드',
                '미션인증',
              ],
              tabController: context.read<BoardMainState>().tabController,
            ),
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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back), // 뒤로 가기 아이콘
        onPressed: () {
          Navigator.of(context).pop(); // 뒤로 가기 버튼을 누르면 이전 화면으로 돌아갑니다.
        },
      ),
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
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelColor: grayScaleGrey550,
      unselectedLabelStyle: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
      ),
      indicatorColor: Colors.transparent,
      controller: tabController,
      tabs: tabs.map((tabText) {
        return Tab(text: tabText);
      }).toList(),
    );
  }
}
