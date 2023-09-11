import 'package:flutter/material.dart';
import 'package:moing_flutter/login/onboarding/component/next_button.dart';
import 'package:moing_flutter/login/register_success/component/link_card.dart';
import 'package:moing_flutter/login/register_success/component/rich_text.dart';
import 'package:moing_flutter/login/register_success/guide_state.dart';
import 'package:provider/provider.dart';

class RegisterGuide extends StatelessWidget {
  static const routeName = '/register/guide';

  const RegisterGuide({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterGuideState(context: context)),
      ],
      builder: (context, _) {
        return const RegisterGuide();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 128.0,
              ),
              const Text(
                '소모임에 초대받았나요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffE8E8EF),
                ),
              ),
              const SizedBox(height: 32.0,),
              const RichTextGuide(),
              const SizedBox(height: 20.0,),
              const Text(
                '초대장이 없다면, 지금 바로 소모임을 만들어보세요.',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xff9B9999),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 60.0,
              ),
              const InvitationCard(),
              const SizedBox(height: 110,),
              NextButton(
                  text: '나만의 소모임 만들기',
                  textStyle: const TextStyle(
                    color: Color(0xffF1F1F1),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  buttonStyle: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(
                        MediaQuery.of(context).size.width, 60,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(
                          color: Color(0xff9B9999),
                        ),
                      ),
                    ),
                  ),
                  onPressed: myMoingPressed,
              ),
              const SizedBox(height: 12.0,),
              Align(
                alignment: Alignment.bottomCenter,
                child: NextButton(
                  text: '가입 완료하기',
                  textStyle: const TextStyle(
                    color: Color(0xff1C1B1B),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  buttonStyle: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(
                        MediaQuery.of(context).size.width, 60,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  onPressed: context.read<RegisterGuideState>().completePressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 나만의 소모임 만들기 클릭
  myMoingPressed() {

  }
}
