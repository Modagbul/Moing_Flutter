import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_last.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_state.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import 'component/tutorial_appbar.dart';

class TutorialThird extends StatefulWidget {
  static const routeName = '/tutorial/third';

  const TutorialThird({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => TutorialState(
              context: context,
            )),
      ],
      builder: (context, _) {
        return const TutorialThird();
      },
    );
  }

  @override
  State<TutorialThird> createState() => _TutorialThirdState();
}

class _TutorialThirdState extends State<TutorialThird> {
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
    double targetPadding = screenHeight / 2 + 175;

    return Scaffold(
      appBar: const TutorialAppBar(pageCount: '3'),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: SvgPicture.asset(
              'asset/icons/tutorial_third_bg.svg',
              fit: BoxFit.cover,
            ),
          ),
          if (_showContainer) ...[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.87,
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
                      '인증하기 버튼을 눌러보세요',
                      style: TextStyle(
                        color: grayScaleGrey400,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      textAlign: TextAlign.center,
                      '사진, 텍스트, 링크로 인증할 수 있어요',
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
                    const SizedBox(height: 43.0),
                    Align(
                      alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 62,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                  splashFactory: NoSplash.splashFactory
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  TutorialLast.routeName,
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
