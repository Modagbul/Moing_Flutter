import 'package:flutter/material.dart';
import 'package:moing_flutter/login/onboarding_tutorial/tutorial_state.dart';
import 'package:provider/provider.dart';
import 'component/tutorial_appbar.dart';

class TutorialLast extends StatelessWidget {
  static const routeName = '/tutorial/last';

  const TutorialLast({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => TutorialState(
              context: context,
            )),
      ],
      builder: (context, _) {
        return const TutorialLast();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TutorialAppBar(pageCount: '4'),
    );
  }
}

