import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moing_flutter/login/login_screen.dart';

class MoingApp extends StatelessWidget {
  const MoingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Firebase load fail..."),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return LoginScreen();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
