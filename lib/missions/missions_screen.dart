import 'package:flutter/material.dart';
import 'package:moing_flutter/missions/missions_group_page.dart';
import 'package:moing_flutter/missions/missions_state.dart';
import 'package:provider/provider.dart';

import '../const/color/colors.dart';
import '../home/component/home_appbar.dart';
import 'missions_all_page.dart';
import 'missions_group_state.dart';

class MissionsScreen extends StatefulWidget {
  static const routeName = '/missons';

  const MissionsScreen({
    super.key,
  });

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MissionsState(context: context)),
      ],
      builder: (context, _) {
        return const MissionsScreen();
      },
    );
  }

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    /// length?
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAppBar(
                notificationCount: '3',
                onTap: context.watch<MissionsState>().alarmPressed,
              ),
              const SizedBox(
                height: 32.0,
              ),
              Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 1.0, // 원하는 높이 설정
                      color: grayScaleGrey550, // 회색으로 설정
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 210), // 오른쪽에 여백 주기
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: grayScaleGrey200,
                      labelColor: grayScaleGrey200,
                      unselectedLabelColor: grayScaleGrey550,
                      tabs: [
                        _customTab(text: '전체 미션'),
                        _customTab(text: '모임별 미션'),
                      ],
                      labelPadding: EdgeInsets.zero, // 탭바 내부의 기본 패딩 제거
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    MissionsAllPage(),
                    MissionsGroupPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Tab _customTab({required String text}) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8), // 텍스트 크기에 따라 여백 조정
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}


//       /// 원본
//       Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               HomeAppBar(
//                 notificationCount: '3',
//                 onTap: context.watch<MissionsState>().alarmPressed,
//               ),
//               const SizedBox(
//                 height: 32.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start, // 버튼 중앙 정렬
//                 children: [
//                   AllMissionsButton(),
//                   const SizedBox(width: 5),
//                   GroupMissionsButton(),
//                   const SizedBox(width: 5),
//                 ],
//               ),
//               const SizedBox(
//                 height: 52.0,
//               ),
//               _Title(mainText: '한번 미션', countText: '1'),
//               const SizedBox(
//                 height: 12.0,
//               ),
//               SingleMissionCard(),
//               const SizedBox(
//                 height: 40.0,
//               ),
//               _Title(mainText: '반복 미션', countText: '1'),
//               const SizedBox(
//                 height: 12.0,
//               ),
//               RepeatMissionCard(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class AllMissionsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 99,
      height: 43,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: grayScaleWhite,
          padding: const EdgeInsets.all(12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
        child: Text(
          '전체미션',
          style: TextStyle(
            color: grayScaleGrey700,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class GroupMissionsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 43,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: grayScaleGrey700,
          padding: const EdgeInsets.all(12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  ChangeNotifierProvider(
                create: (_) => MissionsGroupState(),
                child: MissionsGroupPage(),
              ),
              transitionsBuilder: (context, animation1, animation2, child) {
                return child; // 애니메이션 없이 바로 child 위젯을 반환
              },
              transitionDuration: Duration(milliseconds: 0), // 전환 시간을 0으로 설정
            ),
          );
        },
        child: Text(
          '모임별 미션',
          style: TextStyle(
            color: grayScaleGrey400,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class MyDropdown extends StatefulWidget {
  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedValue,
      hint: Text(
        "모닥모닥불",
        style: TextStyle(color: grayScaleGrey300),
      ),
      dropdownColor: grayScaleGrey600,
      underline: Container(),
      items: <String>['모닥모닥불', '두번째모임', '세번째모임'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: grayScaleGrey100),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedValue = newValue;
        });
      },
    );
  }
}
