import 'package:flutter/material.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialSignButton(
              onTap: context.read<LoginState>().signInWithKakao,
              imagePath: 'asset/image/kakao_login_logo.png',
            ),
            const SizedBox(height: 32.0),
            const Text(
                '아래는 애플 로그인!! 이미지만 asset/image에 추가하고 아래 imagePath 부분 변경해주면 돼!! 변경 후 이 텍스트는 지울 것~~'),
            SocialSignButton(
              onTap: context.read<LoginState>().signInWithApple,
              imagePath: 'asset/image/kakao_login_logo.png',
            ),
            ElevatedButton(
              onPressed: context.read<LoginState>().moveOnBoard,
              child: Text(
                '온보딩 페이지로 이동하기',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
