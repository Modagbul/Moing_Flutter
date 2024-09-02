import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_second.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_state.dart';
import 'package:provider/provider.dart';

import '../onboarding/component/onboarding_graphic.dart';
import 'component/tutorial_appbar.dart';

class TutorialFirst extends StatefulWidget {
  static const routeName = '/tutorial/first';

  const TutorialFirst({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => TutorialState(
                  context: context,
                )),
      ],
      builder: (context, _) {
        return const TutorialFirst();
      },
    );
  }

  @override
  State<TutorialFirst> createState() => _TutorialFirstState();
}

class _TutorialFirstState extends State<TutorialFirst> {
  bool _showContainer = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showContainer = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double targetPadding = screenHeight / 2 - 300;
    double targetPadding2 = screenHeight / 2 - 230;


    return Scaffold(
      appBar: const TutorialAppBar(pageCount: '1'),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: SvgPicture.asset(
              'asset/icons/tutorial_first_bg.svg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: targetPadding),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 148,
                      height: 148,
                      child: OnBoardingGraphic(
                          graphicPath: 'asset/graphic/level_one.json'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showContainer) ...[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.63,
                color: const Color(0xCC000000),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.25,
                color: const Color(0xCC000000),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: targetPadding2),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '불 키우기 버튼을 눌러보세요',
                      style: TextStyle(
                        color: grayScaleGrey400,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      textAlign: TextAlign.center,
                      '모임원들과 함께 미션을 인증해\n 불을 키울 수 있어요',
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
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 63,
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
                            Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => const TutorialSecond(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 300), // 전환 지속시간 설정
                            ));
                          },
                          child: const Text(
                            '',
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
        ],
      ),
    );
  }
}
