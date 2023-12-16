import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/login/invitate_link/welcome_team_state.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:provider/provider.dart';

class InvitationWelcomePage extends StatelessWidget {
  static const routeName = '/invitation/welcome';

  static route(BuildContext context) {
    final Map<String, dynamic> data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String teamName = data['teamName'] as String;
    final String teamLeaderName = data['teamLeaderName'] as String;
    final String memberName = data['memberName'] as String;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => WelcomeTeamState(
                  context: context,
                  teamName: teamName,
                  teamLeaderName: teamLeaderName,
                  memberName: memberName,
                )),
      ],
      builder: (context, _) {
        return InvitationWelcomePage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<WelcomeTeamState>();
    return Scaffold(
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 128),
                  Center(
                    child: Text('모임에 오신 걸 환영해요!',
                        style: headerTextStyle.copyWith(color: grayScaleGrey100)),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: 250,
                    height: 54,
                    alignment: Alignment.center,
                    child: Text(
                      '${state.teamLeaderName}님이 ${state.memberName}님을\n${state.teamName} 모임에 초대했어요',
                      style: contentTextStyle.copyWith(height: 1.68),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 36),
                  Image.asset(
                    'asset/image/icon_invitation.png',
                    width: 255,
                    height: 255,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              Positioned(
                bottom: 32,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(MainPage.routeName);
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width - 40, 62),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  child: Text(
                    '초대 수락하기',
                    style: buttonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
