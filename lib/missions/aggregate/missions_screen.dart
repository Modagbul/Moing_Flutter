import 'package:flutter/material.dart';
import 'package:moing_flutter/missions/aggregate/missions_group_page.dart';
import 'package:moing_flutter/missions/aggregate/missions_state.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import '../../home/component/home_appbar.dart';
import '../../model/response/team_list_response.dart';
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
        ChangeNotifierProvider(create: (_) => MissionsGroupState(context: context)),
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
    List<TeamList> teams = Provider.of<MissionsState>(context).teams;

    return Scaffold(
      backgroundColor: grayBackground,
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
                  SizedBox(
                    width: 220,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: grayScaleGrey700,
                      unselectedLabelColor: grayScaleGrey400,
                      indicator: const BoxDecoration(
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
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                  ),
                  const Spacer(),
                  if (_tabController.index == 1)
                    MyDropdown(
                      teams: teams,
                      onTeamSelected: (teamId) {
                        Provider.of<MissionsState>(context, listen: false)
                            .setSelectedTeamId(teamId);
                      },
                    ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    MissionsAllPage.route(context),
                    MissionsGroupPage.route(context),
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
        padding: const EdgeInsets.all(10.0),
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
  final List<TeamList> teams;
  final void Function(int teamId) onTeamSelected;

  const MyDropdown({
    super.key,
    required this.teams,
    required this.onTeamSelected,
  });

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String? _selectedValue;
  String? _selectedTeamName;

  @override
  void initState() {
    super.initState();
    if (widget.teams.isNotEmpty) {
      _selectedValue = widget.teams[0].teamId.toString();
      _selectedTeamName = widget.teams[0].teamName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedValue,
      hint: Text(
        _selectedTeamName ?? "Select a team",
        style: const TextStyle(color: grayScaleGrey300),
      ),
      dropdownColor: grayScaleGrey600,
      underline: Container(),
      items: widget.teams.map((TeamList team) {
        return DropdownMenuItem<String>(
          value: team.teamId.toString(),
          child: Text(
            team.teamName,
            style: const TextStyle(color: grayScaleGrey100),
          ),
        );
      }).toList(),
        // MyDropdown 위젯에서 팀 선택 변경시 호출되는 메서드
        onChanged: (String? newValue) {
          var selectedTeam = widget.teams.firstWhere(
                  (team) => team.teamId.toString() == newValue,
              orElse: () => widget.teams[0]);
          setState(() {
            _selectedValue = newValue;
            _selectedTeamName = selectedTeam.teamName;

            var missionsState = Provider.of<MissionsState>(context, listen: false);
            missionsState.setSelectedTeamId(selectedTeam.teamId);

            var missionsGroupState = Provider.of<MissionsGroupState>(context, listen: false);
            missionsGroupState.updateSelectedTeamId(selectedTeam.teamId);

          });

        }

    );
  }
}
