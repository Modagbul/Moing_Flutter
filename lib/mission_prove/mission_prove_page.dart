import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/component/mission_current_situation.dart';
import 'package:moing_flutter/mission_prove/component/mission_prove_app_bar.dart';
import 'package:moing_flutter/mission_prove/component/mission_prove_tabbar.dart';
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
        child: CustomScrollView(
          slivers: [
            MissionSliverAppBar(),
            MissionCurrentSituation(),
            MissionSliverPersistentHeader(),
            sliverSizedBox(height: 20),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                height: 300,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.red,
                height: 300,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.blue,
                height: 300,
              ),
            ),
            // Column(
            //   children: [
            //     SingleChildScrollView(
            //       child: Column(
            //         children: [
            //           MissionProveTabBar(),
            //           // Container(
            //           //   width: double.infinity,
            //           //   height: 300,
            //           //   color: Colors.red,
            //           // ),
            //         ],
            //       )
            //     )
            //   ],
            // ),
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
