import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      body: Center(
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
            const SizedBox(height: 55.0),
            SocialSignButton(
              onTap: context.read<LoginState>().signInWithApple,
              imagePath: 'asset/image/apple_login_button.png',
            ),
            const SizedBox(height: 5.0),
            SocialSignButton(
              onTap: context.read<LoginState>().signInWithKakao,
              imagePath: 'asset/image/kakao_login_logo.png',
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}
