
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/missions/aggregate/missions_group_page.dart';
import 'package:moing_flutter/missions/aggregate/missions_state.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import '../../model/response/team_list_response.dart';
import 'missions_all_page.dart';
import 'missions_group_state.dart';

class MissionsScreen extends StatefulWidget {
  static const routeName = '/missons';

  const MissionsScreen({
    super.key,
  });

  static get selectedTeamId => null;

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MissionsState(context: context)),
        ChangeNotifierProvider(
            create: (_) => MissionsGroupState(
                context: context, selectedTeamId: selectedTeamId)),
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
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 210,
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
                    // MissionsGroupPage.route(context),
                    const MissionsGroupPage(),
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

  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    if (widget.teams.isNotEmpty) {
      _selectedValue = widget.teams[0].teamId.toString();
      _selectedTeamName = widget.teams[0].teamName;

      var missionsState = Provider.of<MissionsState>(context, listen: false);
      missionsState.setSelectedTeamId(widget.teams[0].teamId);

      var missionsGroupState =
      Provider.of<MissionsGroupState>(context, listen: false);
      missionsGroupState.updateSelectedTeamId(widget.teams[0].teamId);
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayTeamName = _selectedTeamName ?? "모임 없음";

    if (displayTeamName.length > 5) {
      displayTeamName = '${displayTeamName.substring(0, 5)}...';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            displayTeamName,
            style: TextStyle(
                color: _selectedValue != null
                    ? grayScaleGrey100
                    : grayScaleGrey400),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            popupMenuTheme: const PopupMenuThemeData(
              color: grayScaleGrey900,
            ),
          ),
          child: PopupMenuButton<String>(
              offset: const Offset(0, 60),
              icon: SvgPicture.asset(
                  _isMenuOpen
                      ? 'asset/icons/drop_arrow_not_icon.svg'
                      : 'asset/icons/drop_arrow_icon.svg',
                  width: 20,
                  height: 20
              ),
              onSelected: (String value) {
                var selectedTeam = widget.teams.firstWhere(
                        (team) => team.teamId.toString() == value,
                    orElse: () => widget.teams[0]);

                _isMenuOpen = false;

                setState(() {
                  _selectedValue = value;
                  _selectedTeamName = selectedTeam.teamName;
                });

                var missionsState =
                Provider.of<MissionsState>(context, listen: false);
                missionsState.setSelectedTeamId(selectedTeam.teamId);

                var missionsGroupState =
                Provider.of<MissionsGroupState>(context, listen: false);
                missionsGroupState.updateSelectedTeamId(selectedTeam.teamId);
              },
              onCanceled: () {
                setState(() {
                  _isMenuOpen = false;
                });
              },
              itemBuilder: (BuildContext context) {
                setState(() {
                  _isMenuOpen = true;
                });
                return widget.teams.map((TeamList team) {
                  return PopupMenuItem<String>(
                    value: team.teamId.toString(),
                    child: Text(
                      team.teamName,
                      style: TextStyle(
                        color: team.teamId.toString() == _selectedValue
                            ? grayScaleGrey100
                            : grayScaleGrey400,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ),
      ],
    );
  }
}