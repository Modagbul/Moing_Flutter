import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/login/invitate_link/welcome_team_state.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:provider/provider.dart';

class InvitationWelcomePage extends StatelessWidget {
  static const routeName = '/';

  static route(BuildContext context) {
    final String teamName = ModalRoute.of(context)?.settings.arguments as String;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => WelcomeTeamState(
              context: context,
              teamName: teamName,
            )),
      ],
      builder: (context, _) {
        return InvitationWelcomePage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    width: 200,
                    height: 54,
                    alignment: Alignment.center,
                    child: Text(
                      '챙귤님이 모닥불님을\n${context.watch<WelcomeTeamState>().teamName} 모임에 초대했어요',
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
                  onPressed: (){
                    Navigator.of(context).pushNamed(
                        MainPage.routeName);
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
