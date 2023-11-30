import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/init/init_state.dart';
import 'package:moing_flutter/utils/dynamic_link/dynamic_link.dart';
import 'package:provider/provider.dart';

class InitPage extends StatelessWidget {
  static const routeName = '/';

  const InitPage({super.key});

  static route(BuildContext context) {
    String? teamId = ModalRoute.of(context)?.settings.arguments as String?;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => InitState(
              context: context,
              teamId: teamId,
              dynamicLinkService: DynamicLinkService(context: context)),
          lazy: false,
        ),
      ],
      builder: (context, _) {
        return const InitPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'asset/graphic/splash.gif',
          width: 288,
          height: 360,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
