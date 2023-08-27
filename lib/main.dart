import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moing_flutter/login/login_screen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDefault();
  
  KakaoSdk.init(nativeAppKey: '6671c3a9b377c8f302c17c14e2c940f2');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    ),
  );
}

Future<void> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp();
  print('Initialized default app $app');
}