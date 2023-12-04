import 'package:flutter/material.dart';
import 'package:moing_flutter/login/register_success/guide.dart';

class WelcomePage extends StatefulWidget {
  static const routeName = '/register/welcome';
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final String nickname = ModalRoute.of(context)?.settings.arguments as String;
    /// 1.2초 후에 안내 페이지로 이동
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        Navigator.of(context).pushNamed(
          RegisterGuide.routeName,
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/image/register_welcome.png',
              width: 353,
              height: 353,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 20.0,),
            Text(
              '환영해요, $nickname님!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                color: Color(0xffF4F6F8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
