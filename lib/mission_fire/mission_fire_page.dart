import 'package:flutter/material.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MissionFireState(context: context),
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
    return const Scaffold(
      backgroundColor: grayBackground,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(top: 56),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MissionFireProgressBar(),
                    MissionFireUser(),
                  ],
                ),
              ),
            ),
            Positioned(top: 0, left: 20, right: 20, child: MissionFireAppBar()),
          ],
        ),
      ),
    );
  }
}
