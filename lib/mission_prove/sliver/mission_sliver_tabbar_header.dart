import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class MissionSliverPersistentHeader extends StatelessWidget {
  const MissionSliverPersistentHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabController = context.read<MissionProveState>().tabController;

    return SliverPersistentHeader(
      pinned: true,
        delegate: TabBarDelegate(tabController: tabController));
  }
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  const TabBarDelegate({required this.tabController});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: grayBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.47,
              child: _CustomTabBar(
                tabs: const [
                  '나의 인증',
                  '모두의 인증',
                ],
                tabController: tabController,
              ),
            ),
            Divider(
              height: 0.1,
              color: grayScaleGrey600,
            ),
            // Container(
            //   width: double.infinity,
            //   height: 300,
            //   color: Colors.white,
            //   child: TabBarView(
            //     controller: context.read<MissionProveState>().tabController,
            //     children: [
            //       Text('HI~', style: TextStyle(color: Colors.white),),
            //       Text('Hello~',style: TextStyle(color: Colors.white),),
            //       // BoardGoalScreen(),
            //       // BoardMissionScreen(),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 69;

  @override
  double get minExtent => 49;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    if(oldDelegate is TabBarDelegate) {
      return tabController != oldDelegate.tabController;
    }
    return true;
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

