import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_first.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_state.dart';
import 'package:provider/provider.dart';

import '../../main/main_page.dart';
import '../../utils/button/white_button.dart';
import 'component/tutorial_appbar.dart';

class TutorialZero extends StatelessWidget {
  static const routeName = '/tutorial/zero';

  const TutorialZero({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => TutorialState(
                  context: context,
                )),
      ],
      builder: (context, _) {
        return const TutorialZero();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double targetPadding = screenHeight / 2 + 100;

    return Scaffold(
      appBar: const TutorialAppBar(pageCount: '0'),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'asset/image/tutorial_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color(0xCC000000),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: targetPadding),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '반가워요! 모잉 사용법을 \n 간단하게 알려드릴게요',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  SvgPicture.asset(
                    'asset/icons/icon_arrow_tutorial.svg',
                    width: 28,
                    height: 28,
                  ),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: WhiteButton(
                      onPressed: () {
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) => const TutorialFirst(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 300), // 전환 지속시간 설정
                        ));
                      },
                      text: '튜토리얼 시작하기',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 62,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.transparent),
                          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.transparent;
                              }
                              return null;
                            },
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          shadowColor: MaterialStateProperty.all(Colors.transparent),
                          splashFactory: NoSplash.splashFactory,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              MainPage.routeName, (route) => false);
                        },
                        child: const Text(
                          '괜찮아요',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
