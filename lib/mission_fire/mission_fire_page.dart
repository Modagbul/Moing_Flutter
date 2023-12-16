import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_fire/component/mission_fire_appbar.dart';
import 'package:moing_flutter/mission_fire/component/mission_fire_progressbar.dart';
import 'package:moing_flutter/mission_fire/component/mission_fire_user.dart';
import 'package:moing_flutter/mission_fire/mission_fire_state.dart';
import 'package:provider/provider.dart';

class MissionFirePage extends StatelessWidget {
  static const routeName = '/missions/fire';

  const MissionFirePage({super.key});

  static route(BuildContext context) {
    final Map<String, dynamic> data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final int teamId = data['teamId'] as int;
    final int missionId = data['missionId'] as int;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MissionFireState(
            context: context,
            teamId: teamId,
            missionId: missionId,
          ),
          lazy: false,
        ),
      ],
      builder: (context, _) {
        return const MissionFirePage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayBackground,
      body: SafeArea(
        child: Stack(
          children: [
            const SingleChildScrollView(
              padding: EdgeInsets.only(top: 56),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MissionFireProgressBar(),
                    MissionFireUser(),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            const Positioned(
                top: 0, left: 20, right: 20, child: MissionFireAppBar()),
            if (context.watch<MissionFireState>().selectedIndex != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 190,
                    height: 62,
                    child: ElevatedButton(
                      onPressed: context.read<MissionFireState>().firePressed,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(grayScaleGrey100),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(32.0), // borderRadius 설정
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '불 던지기',
                            style: buttonTextStyle.copyWith(
                              color: grayScaleGrey900,
                            ),
                          ),
                          const SizedBox(width: 5),
                          SvgPicture.asset(
                            'asset/icons/icon_fire_black.svg',
                            width: 15.0,
                            height: 18.0,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
