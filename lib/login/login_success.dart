import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moing_flutter/login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          // 로그인 이력이 없는 경우
          if(!snapshot.hasData) {
            return LoginScreen();
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
