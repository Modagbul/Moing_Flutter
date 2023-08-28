import 'package:flutter/material.dart';
import 'package:moing_flutter/login/onboarding/component/image_onboard.dart';
import 'package:moing_flutter/login/onboarding/component/image_phase.dart';
import 'package:moing_flutter/login/onboarding/component/next_button.dart';
import 'package:moing_flutter/login/onboarding/component/skip_button.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_state.dart';
import 'package:provider/provider.dart';

class OnBoardingFirstPage extends StatelessWidget {
  static const routeName = '/onboard/first';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnBoardingState(context: context, pageCount: 1,)),
      ],
      builder: (context, _) {
        return OnBoardingFirstPage();
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
                onTap: context.read<OnBoardingState>().skip,
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
                  color: Color(0xffF4F6F8),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 88.0,
              ),
              ImagePhase(
                  phase1: 'asset/image/onboard_phase1.png',
                  phase2: 'asset/image/onboard_phase2.png',
                  phase3: 'asset/image/onboard_phase2.png'),
              SizedBox(
                height: 72.0,
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: NextButton(
                    onPressed: context.watch<OnBoardingState>().next,
                    buttonStyle: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 60),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(
                            color: Color(0xff9B9999),
                          ),
                        ),
                      ),
                    ),
                    text: '다음으로',
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffF1F1F1),
                    ),
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
