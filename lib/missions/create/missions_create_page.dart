import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/create/mission_create/mission_title_content.dart';
import 'package:moing_flutter/missions/create/mission_create/missions_app_bar.dart';
import 'package:moing_flutter/missions/create/mission_create/missions_footer.dart';
import 'package:moing_flutter/missions/create/missions_create_state.dart';
import 'package:provider/provider.dart';

class MissionsCreatePage extends StatelessWidget {
  static const routeName = '/missions/create';

  const MissionsCreatePage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MissionCreateState(context: context),
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
        child: GestureDetector(
          onTap: () {
            //FocusManager.instance.primaryFocus?.unfocus();
          },
          child: FooterLayout(
            footer: context.watch<MissionCreateState>().isTitleFocused
                ? MissionsFooter()
                : null,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MissionAppBar(),
                    _missionText(),
                    MissionTitleContent(),
                    SizedBox(
                      height: 52,
                    ),
                    Text(
                      '미션 마감일',
                      style: contentTextStyle.copyWith(
                          fontWeight: FontWeight.w600, color: grayScaleGrey200),
                    )
                  ],
                ),
              ),
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
        SizedBox(height: 34),
        Text(
          '미션을 만들어볼까요?',
          style: headerTextStyle.copyWith(color: grayScaleGrey100),
        ),
        SizedBox(height: 52),
        Text(
          '미션 제목과 내용',
          style: contentTextStyle.copyWith(
              color: grayScaleGrey200, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}