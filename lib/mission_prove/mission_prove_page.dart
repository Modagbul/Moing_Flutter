import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/mission_prove/component/mission_prove_argument.dart';
import 'package:moing_flutter/mission_prove/component/prove_button/mission_like_share.dart';
import 'package:moing_flutter/mission_prove/component/mission_current_situation.dart';
import 'package:moing_flutter/mission_prove/component/prove_button/mission_not_prove_button.dart';
import 'package:moing_flutter/mission_prove/component/prove_button/mission_prove_button.dart';
import 'package:moing_flutter/mission_prove/component/repeat_every_mission/every_mission_prove_test.dart';
import 'package:moing_flutter/mission_prove/component/repeat_my_mission_prove.dart';
import 'package:moing_flutter/mission_prove/component/single_my_mission_not_prove.dart';
import 'package:moing_flutter/mission_prove/component/single_my_mission_prove.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:moing_flutter/mission_prove/sliver/mission_sliver_appbar.dart';
import 'package:moing_flutter/mission_prove/sliver/mission_sliver_tabbar_header.dart';
import 'package:provider/provider.dart';

class MissionProvePage extends StatefulWidget {
  static const routeName = '/missions/prove';

  const MissionProvePage({super.key});

  static route(BuildContext context) {
    final argument = ModalRoute.of(context)?.settings.arguments as MissionProveArgument;
    final bool isRepeated = argument.isRepeated;
    final int teamId = argument.teamId;
    final int missionId = argument.missionId;
    final String status = argument.status;
    final bool isEnded = argument.isEnded;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => MissionProveState(
                  context: context,
                  isRepeated: isRepeated,
                  teamId: teamId,
                  missionId: missionId,
                  repeatMissionStatus: status,
                  isEnded : isEnded,
                )),
      ],
      builder: (context, _) {
        return const MissionProvePage();
      },
    );
  }

  @override
  State<MissionProvePage> createState() => _MissionProvePageState();
}

class _MissionProvePageState extends State<MissionProvePage>
    with SingleTickerProviderStateMixin {

  MissionProveState? missionProveState;

  @override
  void initState() {
    super.initState();
    context.read<MissionProveState>().initTabController(
          tabController: TabController(
            length: 2,
            vsync: this,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MissionProveState>();
    return Scaffold(
      backgroundColor: grayBackground,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                MissionSliverAppBar(),
                MissionCurrentSituation(),
                MissionSliverPersistentHeader(),
                sliverSizedBox(height: 20),

                /// isMeOrEveryProved : true -> 나의 인증, false -> 모두의 인증
                /// myMissionList : 미션 인증 시 가져오는 리스트
                /// isMeProved : 나의 오늘 인증 여부

                /// 나의 인증이면서 아직 인증 안한 경우
                if (state.myMissionList == null ||
                    (state.isMeOrEveryProved &&
                        state.myMissionList != null &&
                        state.myMissionList!.isEmpty))
                  SingleMyMissionNotProved(),

                /// 나의 인증이면서 반복 미션에서 인증한 경우
                if (state.isMeOrEveryProved && state.isRepeated &&
                    state.myMissionList != null && state.myMissionList!.isNotEmpty)
                  RepeatMyMissionProved(),

                /// 나의 인증이면서 한번 미션에서 인증 한 경우
                if (state.isMeOrEveryProved && !state.isRepeated &&
                    state.myMissionList != null && state.myMissionList!.isNotEmpty)
                  SingleMyMissionProved(),

                /// 모두의 인증이면서 한번 미션에서 인증 안한 경우
                if (state.myMissionList == null ||
                    (!state.isMeOrEveryProved &&
                        state.everyMissionList != null &&
                        state.everyMissionList!.isEmpty))
                  SingleMyMissionNotProved(),

                /// 모두의 인증이면서 인증 한 경우
                if (!state.isMeOrEveryProved &&
                    state.everyMissionList != null && state.everyMissionList!.isNotEmpty)
                  EveryMissionProved(),
                
                /// 한번 미션에서 나의 인증 한 경우 좋아요, 이미지 저장 Row
                if(!state.isRepeated && state.myMissionList != null
                    && state.myMissionList!.isNotEmpty && state.isMeOrEveryProved)
                MissionLikeShare(),
                if (!state.isMeOrEveryProved)
                  sliverSizedBox(height: 160),
              ],
            ),

            /// 인증 안한 경우
            if(!state.isEnded && ((state.repeatMissionStatus != 'WAIT' && state.isRepeated) ||
                (!state.isRepeated && state.myMissionList != null && state.myMissionList!.isEmpty)))
             MissionNotProveButton(),
            /// 인증 한 경우
            if(!state.isEnded && !state.isRepeated &&
                state.myMissionList != null && state.myMissionList!.isNotEmpty)
            MissionProveButton(),

          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter sliverSizedBox({required double height}) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: height,
      ),
    );
  }
}
