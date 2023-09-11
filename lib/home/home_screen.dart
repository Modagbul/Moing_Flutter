import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/home/component/home_appbar.dart';
import 'package:moing_flutter/home/component/home_card.dart';
import 'package:moing_flutter/home/component/home_my_meeting.dart';
import 'package:moing_flutter/home/component/home_nickname_and_encourage.dart';
import 'package:moing_flutter/home/home_screen_state.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => HomeScreenState(context: context)),
      ],
      builder: (context, _) {
        return HomeScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAppBar(
                notificationCount: '3',
                onTap: context.read<HomeScreenState>().alarmPressed,
              ),
              const SizedBox(
                height: 32.0,
              ),
              HomeText(nickName: '모닥불', encourage: '오늘도 모잉이 응원해요!'),
              const SizedBox(height: 40.0),
              HomeMyMeeting(
                meetingCount: '2',
              ),
              const SizedBox(height: 12.0),
              HomeCard(),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      '모임 만들기',
                      style: TextStyle(
                        color: grayScaleGrey700,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size(162, 51)), // 원하는 너비와 높이
                        backgroundColor:
                            MaterialStateProperty.all<Color>(grayScaleGrey100),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(32.0), // borderRadius 설정
                          ),
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
