import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  static const routeName = '/onboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원가입'
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
      ),
    );
  }
}
