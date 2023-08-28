import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/init/init_state.dart';
import 'package:provider/provider.dart';

class InitPage extends StatelessWidget {
  static const routeName = '/';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => InitState(context: context),
          lazy: false,
        ),
      ],
      builder: (context, _) {
        return InitPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
                'asset/image/moing_icon.png',
                fit: BoxFit.contain,
              ),
            SvgPicture.asset(
              'asset/icons/moing_logo.svg',
              fit: BoxFit.contain,
            ),
            SvgPicture.asset(
              'asset/icons/moing_text.svg',
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

}
