import 'package:flutter/material.dart';
import 'package:moing_flutter/board/component/team_member_card.dart';
import 'package:moing_flutter/board/screen/team_member_list_state.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/model/response/single_board_team_member_info.dart';
import 'package:provider/provider.dart';

class TeamMemberListPage extends StatelessWidget {
  static const routeName = '/board/goal/member/list';

  static route(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    final List<TeamMemberInfo> teamMemberInfoList =
        arguments as List<TeamMemberInfo>;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TeamMemeberListState(
            context: context,
            teamMemberInfoList: teamMemberInfoList,
          ),
        ),
      ],
      builder: (context, _) {
        return const TeamMemberListPage();
      },
    );
  }

  const TeamMemberListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TeamMemberInfo>? teamMemeberInfoList =
        context.watch<TeamMemeberListState>().teamMemberInfoList;
    return Scaffold(
      appBar: _renderAppBar(context: context),
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 24.0),
              Expanded(
                child: ListView.builder(
                  itemCount: teamMemeberInfoList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: TeamMemeberCard(
                        teamMemberInfo: teamMemeberInfoList[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _renderAppBar({required BuildContext context}) {
    return AppBar(
      backgroundColor: grayScaleGrey900,
      elevation: 0.0,
      title: const Text('모임원 소개'),
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(
          Icons.close,
        ),
        onPressed: context.read<TeamMemeberListState>().pressCloseButton,
      ),
    );
  }
}
