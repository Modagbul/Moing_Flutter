import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moing_flutter/login/sign_in/login_page.dart';

class LoginSuccessPage extends StatelessWidget {
  const LoginSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          // 로그인 이력이 없는 경우
          if(!snapshot.hasData) {
            return LoginPage();
          }
          else {
            return Center(
              child: Column(
                children: [
                  Text('${snapshot.data!.displayName}님 환영합니다.'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
