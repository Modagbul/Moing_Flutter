import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/init/init_state.dart';
import 'package:provider/provider.dart';

class InitPage extends StatelessWidget {
  static const routeName = '/';

  const InitPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => InitState(context: context),
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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 68),
              Image.asset(
                'asset/image/moing_icon.png',
                width: double.infinity,
                height: 430,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: SvgPicture.asset(
                  'asset/icons/moing_text.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.45,
            left: MediaQuery.of(context).size.width * 0.25,
            right: MediaQuery.of(context).size.width * 0.25,
            child: SvgPicture.asset(
              'asset/icons/moing_logo.svg',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
