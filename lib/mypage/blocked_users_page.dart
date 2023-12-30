import 'package:flutter/material.dart';
import 'package:moing_flutter/utils/app_bar/moing_app_bar.dart';
import 'package:provider/provider.dart';

import '../const/color/colors.dart';
import 'blocked_users_state.dart';
import 'component/blocked_member_card.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  static const routeName = '/mypage/setting/blocked';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => BlockedUsersState(context: context)),
      ],
      builder: (context, _) {
        return const BlockedUsersPage();
      },
    );
  }

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<BlockedUsersState>();
    return Scaffold(
      appBar: MoingAppBar(
        title: '차단멤버 관리',
        imagePath: 'asset/icons/arrow_left.svg',
        onTap: () => Navigator.pop(context),
      ),
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              if (state.blockedMemberStatus != null &&
                  state.blockedMemberStatus!.isNotEmpty)
                ...state.blockedMemberStatus!
                    .map(
                      (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        BlockedMemberCard(
                          targetId: e.targetId,
                          nickName: e.nickName,
                          introduce: e.introduce ?? '아직 한 줄 다짐이 없어요',
                          profileImg: e.profileImg ?? '',
                          // onTap: () {
                          //   Navigator.of(context).pushNamed(
                          //       MissionProvePage.routeName,
                          //       arguments: MissionProveArgument(
                          //           isRepeated: false,
                          //           teamId: context.read<OngoingMissionState>().teamId,
                          //           missionId: e.missionId,
                          //           status: e.status,
                          //           isEnded: false)
                          //   ).then((_) {
                          //     Provider.of<OngoingMissionState>(context,
                          //         listen: false)
                          //         .reloadMissionStatus();
                          //   });
                          // },
                        ),
                      ],
                    ),
                  ),
                )
                    .toList()
              else
                Visibility(
                  visible: state.blockedMemberStatus?.isEmpty ?? true,
                  replacement: const SizedBox(height: 126),
                  child: const SizedBox(
                    height: 126,
                    child: Center(
                      child: Text(
                        '차단한 유저가 없어요.',
                        style: TextStyle(
                          color: grayScaleGrey400,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: BlockedMemberInfoList.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 12.0),
              //         child: BlockedMemberCard(
              //           blockedMemberInfo: BlockedMemberInfoList[index],
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
