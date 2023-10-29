import 'package:flutter/material.dart';
import 'package:moing_flutter/mypage/component/list_toggle_tile.dart';
import 'package:moing_flutter/mypage/setting_state.dart';
import 'package:moing_flutter/utils/app_bar/moing_app_bar.dart';
import 'package:provider/provider.dart';

import '../const/color/colors.dart';
import 'alram_setting_state.dart';
import 'component/list_custom_tile.dart';
import 'component/list_toggle_tile_no_sub.dart';

class AlramSettingPage extends StatelessWidget {
  const AlramSettingPage({super.key});

  static const routeName = '/mypage/setting/alram';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AlramSettingState(context: context)),
      ],
      builder: (context, _) {
        return const AlramSettingPage();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoingAppBar(
        title: '알림설정',
        imagePath: 'asset/image/arrow_left.png',
        onTap: () => Navigator.pop(context),
      ),
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Column(
          children: [
            ListToggleTileNoSub(listName: '전체 알림'),
            ListToggleTile(listName: '신규 공지 알림', subText: '빠른 공지 확인을 위해\n알림 ON을 유지해주세요!'),
            ListToggleTile(listName: '미션 리마인드 알림', subText: '매일 오전 8시, 미션에 대한\n리마인드 알림을 드릴게요!'),
            ListToggleTileNoSub(listName: '불 던지기 알림'),
            Spacer(),
            _NextBtn(),
            SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}

class _NextBtn extends StatelessWidget {
  const _NextBtn({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 353,
      height: 62,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: grayScaleGrey500,
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          '완료',
          style: TextStyle(
            color: grayScaleGrey300,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
