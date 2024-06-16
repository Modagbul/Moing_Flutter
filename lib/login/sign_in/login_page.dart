import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moing_flutter/login/sign_in/component/custom_login_button.dart';
import 'package:moing_flutter/login/sign_in/login_state.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class LoginPage extends StatelessWidget {
  static const routeName = '/sign/in';

  const LoginPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginState(context: context),
        ),
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
                    child: Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'asset/icons/login_balloon.svg',
                        width: 215.79,
                        height: 114,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Lottie.asset(
                    'asset/graphic/big.json',
                    width: 260,
                    height: 260,
                  ),
                  const Spacer(),
                  if (Platform.isAndroid)
                    CustomButton(
                      onPressed: context.read<LoginState>().signInWithGoogle,
                      text: 'Google로 로그인',
                      imagePath: 'asset/icons/logo_google.svg',
                      buttonStyle: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 60),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    )
                  else if (Platform.isIOS)
                    CustomButton(
                      onPressed: context.read<LoginState>().signInWithApple,
                      text: 'Apple로 로그인',
                      imagePath: 'asset/icons/logo_apple.svg',
                      buttonStyle: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 60),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
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
                    imagePath: 'asset/icons/logo_kakao.svg',
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
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset(
                      'asset/icons/modakbul_icon.svg',
                      width: 100,
                      height: 30,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
