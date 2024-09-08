import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_state.dart';
import 'package:provider/provider.dart';
import '../../const/color/colors.dart';
import '../../main/main_page.dart';
import '../../utils/button/white_button.dart';
import 'component/tutorial_appbar.dart';

class TutorialLast extends StatefulWidget {
  static const routeName = '/tutorial/last';

  const TutorialLast({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => TutorialState(
                  context: context,
                )),
      ],
      builder: (context, _) {
        return const TutorialLast();
      },
    );
  }

  @override
  State<TutorialLast> createState() => _TutorialLastState();
}

class _TutorialLastState extends State<TutorialLast> {
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
      appBar: const TutorialAppBar(pageCount: '4'),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: SvgPicture.asset(
              'asset/icons/tutorial_last_bg.svg',
              fit: BoxFit.cover,
            ),
          ),
          if (_showContainer) ...[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.84,
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
                      '불 던지기 버튼을 눌러보세요',
                      style: TextStyle(
                        color: grayScaleGrey400,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      textAlign: TextAlign.center,
                      '독려 알림을 보내 모임원을 인증시키세요',
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
                    const SizedBox(height: 18.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
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
                            onPressed: () => _showTutorialBottomSheet(context),
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

  void _showTutorialBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: grayScaleGrey700,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 32.0,
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                children: [
                  Text(
                    '튜토리얼을 완료했어요',
                    style: TextStyle(
                      color: grayScaleGrey100,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '이제 갓생 모임을 만들고 모임원을 모아보세요!',
                    style: TextStyle(
                      color: grayScaleGrey400,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Image.asset(
                'asset/image/register_welcome.png',
                width: 205,
                height: 222,
                fit: BoxFit.fill,
              ),
              WhiteButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      MainPage.routeName, (route) => false);
                },
                text: '닫기',
              ),
            ],
          ),
        );
      },
    );
  }
}
