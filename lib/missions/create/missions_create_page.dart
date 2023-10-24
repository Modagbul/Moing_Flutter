import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/create/missions_create_state.dart';
import 'package:moing_flutter/utils/app_bar/moing_app_bar.dart';
import 'package:provider/provider.dart';

class MissionsCreatePage extends StatelessWidget {
  static const routeName = '/missions/create';

  const MissionsCreatePage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MissionCreateState(context: context),
          lazy: false,
        ),
      ],
      builder: (context, _) {
        return const MissionsCreatePage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('신규미션 만들기', style: buttonTextStyle.copyWith(color: grayScaleGrey300),),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close), // 햄버거버튼 아이콘 생성
          onPressed: () {},
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 20),
            child: Text('만들기',style: buttonTextStyle.copyWith(color: grayScaleGrey500),),
          ),
        ],
      ),
    );
  }
}
