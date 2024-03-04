import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/create/mission_create/mission_check_choose.dart';
import 'package:moing_flutter/missions/create/mission_create/mission_end.dart';
import 'package:moing_flutter/missions/create/mission_create/mission_rule.dart';
import 'package:moing_flutter/missions/create/mission_create/mission_title_content.dart';
import 'package:moing_flutter/missions/create/mission_create/missions_app_bar.dart';
import 'package:moing_flutter/missions/create/mission_create/missions_footer.dart';
import 'package:moing_flutter/missions/create/missions_create_state.dart';
import 'package:provider/provider.dart';

class MissionsCreatePage extends StatelessWidget {
  static const routeName = '/missions/create';

  const MissionsCreatePage({super.key});

  static route(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    int teamId;
    int repeatMissions = 0;
    bool isLeader = false;

    if (arguments is Map) {
      teamId = arguments['teamId'];
      repeatMissions = arguments['repeatMissions'] ?? 0;
      isLeader = arguments['isLeader'] ?? false;
    } else if (arguments is int) {
      teamId = arguments;
    } else {
      throw ArgumentError('Invalid arguments for MissionsCreatePage.route');
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MissionCreateState(
              context: context, teamId: teamId, repeatMissions: repeatMissions, isLeader: isLeader),
          lazy: false,
        ),
      ],
      builder: (context, _) {
        return const MissionsCreatePage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayBackground,
      body: SafeArea(
        child: FooterLayout(
          footer: context.watch<MissionCreateState>().isTitleFocused
              ? MissionsFooter()
              : null,
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 56),
                        _missionText(),
                        const MissionTitleContent(),
                        const MissionEndDate(),
                        const MissionChoose(),
                        // const MissionRule(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: MissionAppBar(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _missionText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 34),
        Text(
          '미션을 만들어볼까요?',
          style: headerTextStyle.copyWith(color: grayScaleGrey100),
        ),
        const SizedBox(height: 52),
        Text(
          '미션 제목과 설명',
          style: contentTextStyle.copyWith(
              color: grayScaleGrey200, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
