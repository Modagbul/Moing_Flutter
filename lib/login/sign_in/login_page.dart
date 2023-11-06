import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/login/sign_in/component/custom_login_button.dart';
import 'package:moing_flutter/login/sign_in/login_state.dart';
import 'package:moing_flutter/main/main_page.dart';
import 'package:provider/provider.dart';
import 'package:speech_balloon/speech_balloon.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/sign/in';

  const LoginPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginState(context: context)),
      ],
      builder: (context, _) {
        return const LoginPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64.0),
                    child: SpeechBalloon(
                      color: grayScaleGrey600,
                      width: double.infinity,
                      height: 118,
                      borderRadius: 16,
                      nipLocation: NipLocation.bottom,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          '열정 없는 자기계발 모임,\n오늘부터는 끝!',
                          textAlign: TextAlign.center,
                          style: headerTextStyle.copyWith(color: coralGrey100, fontWeight: FontWeight.w700,height: 1.4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  // Lottie.asset(
                  //     'asset/graphic/big.json',
                  //     width: 260,
                  //     height: 260,
                  // ),
                  const Spacer(),
                  CustomButton(
                    onPressed: context.read<LoginState>().signInWithApple,
                    text: 'Apple로 로그인',
                    imagePath: 'asset/image/logo_apple.png',
                    buttonStyle: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 60),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  CustomButton(
                    onPressed: context.read<LoginState>().signInWithKakao,
                    text: '카카오 로그인',
                    imagePath: 'asset/image/logo_kakao.png',
                    buttonStyle: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 60),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xffFEE500)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0, top: 40),
                      child: Image.asset(
                        'asset/image/modakbul_icon.png', // 이미지의 세로 크기를 100으로 설정
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
