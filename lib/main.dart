import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moing_flutter/login/login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDefault();

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
