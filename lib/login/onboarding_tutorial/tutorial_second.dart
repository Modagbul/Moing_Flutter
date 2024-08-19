import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_state.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_third.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import 'component/tutorial_appbar.dart';

class TutorialSecond extends StatefulWidget {
  static const routeName = '/tutorial/second';

  const TutorialSecond({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => TutorialState(
                  context: context,
                )),
      ],
      builder: (context, _) {
        return const TutorialSecond();
      },
    );
  }

  @override
  State<TutorialSecond> createState() => _TutorialSecondState();
}

class _TutorialSecondState extends State<TutorialSecond> {
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
    double targetPadding = screenHeight / 2 - 135;

    return Scaffold(
      appBar: const TutorialAppBar(pageCount: '2'),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: SvgPicture.asset(
              'asset/icons/tutorial_second_bg.svg',
              fit: BoxFit.cover,
            ),
          ),
          if (_showContainer) ...[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.69,
                color: const Color(0xCC000000),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.15,
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
                      '완료하기 버튼을 눌러보세요',
                      style: TextStyle(
                        color: grayScaleGrey400,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      textAlign: TextAlign.center,
                      '우리 모임의 미션을 확인해보세요',
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
                    const SizedBox(height: 61.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 35.0),
                        child: SizedBox(
                          width: 87,
                          height: 45,
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
                              Navigator.of(context).pushNamed(
                                TutorialThird.routeName,
                              );
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
