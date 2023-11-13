import 'package:flutter/material.dart';
import 'package:moing_flutter/login/onboarding/component/image_phase.dart';
import 'package:moing_flutter/login/onboarding/component/introduce_text.dart';
import 'package:moing_flutter/login/onboarding/component/next_button.dart';
import 'package:moing_flutter/login/onboarding/component/onboarding_graphic.dart';
import 'package:moing_flutter/login/onboarding/component/skip_button.dart';
import 'package:moing_flutter/login/onboarding/on_boarding_state.dart';
import 'package:provider/provider.dart';

class OnBoardingThirdPage extends StatelessWidget {
  static const routeName = '/onboard/third';

  const OnBoardingThirdPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => OnBoardingState(context: context, pageCount: 3)),
      ],
      builder: (context, _) {
        return const OnBoardingThirdPage();
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
              IntroduceText(
                title: '불 던지기',
                comment: '게으른 모임원의 발등에\n불을 던져 재촉해봐요',
              ),
              OnBoardingGraphic(graphicPath: 'asset/graphic/onboarding_3.json'),
              const SizedBox(height: 52),
              const ImagePhase(
                  phase1: 'asset/image/onboard_phase2.png',
                  phase2: 'asset/image/onboard_phase2.png',
                  phase3: 'asset/image/onboard_phase1.png',
                  phase4: 'asset/image/onboard_phase2.png'),
              const Spacer(),
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
                          side: const BorderSide(
                            color: Color(0xff9B9999),
                          ),
                        ),
                      ),
                    ),
                    text: '다음으로',
                    textStyle: const TextStyle(
                      fontSize: 16.0,
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
