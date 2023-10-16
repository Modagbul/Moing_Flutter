import 'package:flutter/material.dart';
import 'package:moing_flutter/missions/component/repeat_mission_card.dart';
import 'package:moing_flutter/missions/component/single_mission_card.dart';
import 'package:moing_flutter/missions/missions_screen.dart';
import 'package:provider/provider.dart';

import '../const/color/colors.dart';
import '../home/component/home_appbar.dart';
import 'missions_group_state.dart';
import 'missions_state.dart';

class MissionsGroupPage extends StatelessWidget {
  static const routeName = '/missons/group';

  const MissionsGroupPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => MissionsGroupState(context: context)),
      ],
      builder: (context, _) {
        return const MissionsGroupPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAppBar(
                notificationCount: '3',
                onTap: context.watch<MissionsGroupState>().alarmPressed,
              ),
              const SizedBox(
                height: 32.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // 버튼 중앙 정렬
                children: [
                  AllMissionsButton(),
                  const SizedBox(width: 5),
                  GroupMissionsButton(),
                  const SizedBox(width: 5),
                  Spacer(),
                  MyDropdown(),
                ],
              ),
              const SizedBox(
                height: 52.0,
              ),
              _Title(mainText: '한번 미션', countText: '1'),
              const SizedBox(
                height: 12.0,
              ),
              SingleMissionCard(),
              const SizedBox(
                height: 40.0,
              ),
              _Title(mainText: '반복 미션', countText: '1'),
              const SizedBox(
                height: 12.0,
              ),
              RepeatMissionCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class AllMissionsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 99,
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
                create: (_) => MissionsState(context: context),
                child: MissionsScreen(),
              ),
              transitionsBuilder: (context, animation1, animation2, child) {
                return child; // 애니메이션 없이 바로 child 위젯을 반환
              },
              transitionDuration: Duration(milliseconds: 0), // 전환 시간을 0으로 설정
            ),
          );
        },
        child: Text(
          '전체미션',
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

class GroupMissionsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
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
          '모임별 미션',
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

class _Title extends StatelessWidget {
  final String mainText;
  final String countText;

  _Title({
    required this.mainText,
    required this.countText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          mainText,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: grayScaleGrey100,
          ),
        ),
        const SizedBox(
          width: 4.0,
        ),
        Text(
          countText,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: grayScaleGrey400,
          ),
        ),
      ],
    );
  }
}
