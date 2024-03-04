import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class LoadingPage extends StatelessWidget {
  final Color? color;
  const LoadingPage({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color ?? grayBackground,
      body: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
