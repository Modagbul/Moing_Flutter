import 'package:flutter/material.dart';
import 'package:moing_flutter/init/init_state.dart';
import 'package:provider/provider.dart';

class InitPage extends StatelessWidget {
  static const routeName = '/';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InitState(context: context), lazy: false,),
      ],
      builder: (context, _) {
        return InitPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        /// splash 이미지 (임의로 카카오톡 이미지 집어넣음)
        Image.asset(
            'asset/image/kakao_login_logo.png',
            fit: BoxFit.contain,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            // brightness: Brightness.dark,
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
          ),
        ),
      ],
    );
  }
}
