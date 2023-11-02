import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/component/mission_current_situation.dart';
import 'package:moing_flutter/mission_prove/component/prove_button/mission_prove_button.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => MissionProveState(context: context)),
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
                /// 나의 인증이면서 아직 인증 안한 경우
                if(context.watch<MissionProveState>().isMeOrEveryProved &&
                context.watch<MissionProveState>().myMissionList != null &&
                    !context.watch<MissionProveState>().isMeProved)
                SingleMyMissionNotProved(),
                /// 나의 인증이면서 인증 한 경우
                if(context.watch<MissionProveState>().isMeOrEveryProved &&
                    context.watch<MissionProveState>().myMissionList != null &&
                    context.watch<MissionProveState>().isMeProved)
                SingleMyMissionProved(),
              ],
            ),

            /// 인증 안한 경우
            // MissionNotProveButton(),
            /// 인증 한 경우
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
