import 'package:flutter/material.dart';
import 'package:moing_flutter/board/component/board_main_bottom_sheet.dart';
import 'package:moing_flutter/board/screen/board_goal_screen.dart';
import 'package:moing_flutter/board/board_main_state.dart';
import 'package:moing_flutter/board/screen/board_mission_screen.dart';
import 'package:moing_flutter/board/component/board_main_bottom_sheet_leader.dart';
import 'package:moing_flutter/board/screen/board_mission_state.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:moing_flutter/model/response/single_board_team_info.dart';
import 'package:moing_flutter/utils/alert_dialog/alert_dialog.dart';
import 'package:provider/provider.dart';

class BoardMainPage extends StatefulWidget {
  static const routeName = '/board/main';

  const BoardMainPage({super.key});

  static route(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final int teamId = arguments['teamId'];
    bool isSuccess = arguments['isSuccess'] ?? false;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => BoardMainState(
                context: context, teamId: teamId, isSuccess: isSuccess)),
        ChangeNotifierProvider(
            create: (_) => BoardMissionState(context: context)),
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<BoardMainState>().isSuccess) {
        ViewUtil().showSnackBar(
          context: context,
          message: '소모임 정보 수정이 완료되었어요',
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<BoardMainState>().isSuccess) {
        ViewUtil().showSnackBar(
          context: context,
          message: '이미 소모임 삭제가 진행 중이에요',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TeamInfo? teamInfo = context.watch<BoardMainState>().teamInfo;
    final String teamName = teamInfo?.teamName ?? '';
    final int teamId = context.read<BoardMainState>().teamId;

    return Scaffold(
      backgroundColor: grayScaleGrey900,
      appBar: renderAppBar(context: context, title: teamName, teamId: teamId),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
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
              children: [
                const BoardGoalScreen(),
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
    required int teamId,
  }) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(title),
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back), // 뒤로 가기 아이콘
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, MainPage.routeName, (route) => false);
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            showGroupControlBottomSheet(
              context: context,
              teamId: teamId,
            );
          },
          icon: const Icon(Icons.more_vert),
        )
      ],
    );
  }

  void showGroupControlBottomSheet({
    required BuildContext context,
    required int teamId,
  }) {
    final int currentUserId =
        context.read<BoardMainState>().teamInfo?.currentUserId ?? 0;
    final currentUserInfo = context
        .read<BoardMainState>()
        .teamInfo
        ?.teamMemberInfoList
        .firstWhere((element) => element.memberId == currentUserId);
    final bool isLeader = currentUserInfo?.isLeader ?? false;
    final isDeleted = context.read<BoardMainState>().teamInfo?.isDeleted;

    showModalBottomSheet(
      backgroundColor: grayScaleGrey600,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      builder: (BuildContext context) {
        return isLeader
            ? BoardMainBottomSheetLeader(
                teamId: teamId, isDeleted: isDeleted!,
              )
            : BoardMainBottomSheet(
                teamId: teamId,
              );
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
