import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moing_flutter/login/sign_in/component/custom_login_button.dart';
import 'package:moing_flutter/login/sign_in/component/login_button.dart';
import 'package:moing_flutter/login/sign_in/login_state.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/sign/in';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginState(context: context)),
      ],
      builder: (context, _) {
        return LoginPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25.0),
              Image.asset(
                'asset/image/moing_icon_sign.png',
                width: 393,
                height: 403,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 73.0,),
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
              const SizedBox(height: 16.0,),
              CustomButton(
                onPressed: context.read<LoginState>().signInWithKakao,
                text: '카카오 로그인',
                imagePath: 'asset/image/logo_kakao.png',
                buttonStyle: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width, 60),
                  ),
                  backgroundColor: MaterialStateProperty.all(Color(0xffFEE500)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: ElevatedButton(
                    onPressed: context.read<LoginState>().moveOnBoard,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // 배경색을 투명으로 설정
                    ),
                    child:
                    Image.asset(
                      'asset/image/modakbul_icon.png',// 이미지의 세로 크기를 100으로 설정
                      fit: BoxFit.contain,
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
