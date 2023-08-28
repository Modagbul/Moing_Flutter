import 'package:flutter/material.dart';
import 'package:moing_flutter/login/onboarding/component/image_onboard.dart';
import 'package:moing_flutter/login/onboarding/component/image_phase.dart';
import 'package:moing_flutter/login/onboarding/component/next_button.dart';
import 'package:moing_flutter/login/onboarding/component/skip_button.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_state.dart';
import 'package:provider/provider.dart';

class OnBoardingThirdPage extends StatelessWidget {
  static const routeName = '/onboard/third';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnBoardingState(context: context, pageCount: 3)),
      ],
      builder: (context, _) {
        return OnBoardingThirdPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SkipButton(
                onTap: () {},
              ),
              ImageOnBoard(
                imagePath: 'asset/image/black.jpeg',
              ),
              SizedBox(
                height: 32.0,
              ),
              Text(
                '모잉불과 함께 \n우리 모임을 불태울 수 있어요',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffF4F6F8),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 88.0,
              ),
              ImagePhase(
                  phase1: 'asset/image/onboard_phase2.png',
                  phase2: 'asset/image/onboard_phase2.png',
                  phase3: 'asset/image/onboard_phase1.png',
              ),
              SizedBox(
                height: 72.0,
              ),
              NextButton(
                onPressed: context.watch<OnBoardingState>().next,
                buttonStyle: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width, 60),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                        color: Color(0xff9B9999),
                      ),
                    ),
                  ),
                ),
                text: '시작하기',
                textStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1C1B1B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
