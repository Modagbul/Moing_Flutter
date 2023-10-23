import 'package:flutter/material.dart';
import 'package:moing_flutter/missions/aggregate/missions_group_page.dart';
import 'package:moing_flutter/missions/aggregate/missions_state.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import '../../home/component/home_appbar.dart';
import 'missions_all_page.dart';

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
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 220,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: grayScaleGrey700,
                      unselectedLabelColor: grayScaleGrey400,
                      indicator: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.transparent, width: 0),
                        ),
                      ),
                      tabs: [
                        _customTab(
                            text: '전체 미션',
                            width: 99,
                            isSelected: _tabController.index == 0),
                        _customTab(
                            text: '모임별 미션',
                            width: 112,
                            isSelected: _tabController.index == 1),
                      ],
                      labelPadding: EdgeInsets.zero,
                      onTap: (index) {
                        setState(() {});
                      },
                      overlayColor: MaterialStateProperty.all(
                          Colors.transparent), // 물결 효과 색상을 투명하게 설정
                    ),
                  ),
                  Spacer(),
                  if (_tabController.index == 1) // "모임별 미션" 탭이 선택된 경우
                    MyDropdown(),
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

  Tab _customTab(
      {required String text, required double width, required bool isSelected}) {
    return Tab(
      child: Container(
        width: width,
        height: 43,
        decoration: BoxDecoration(
          color: isSelected ? grayScaleGrey100 : grayScaleGrey700,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? grayScaleGrey700 : grayScaleGrey400,
            ),
          ),
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
