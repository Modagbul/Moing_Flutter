import 'package:flutter/material.dart';
import 'package:moing_flutter/mypage/component/alarm_setting.dart';
import 'package:moing_flutter/utils/app_bar/moing_app_bar.dart';
import 'package:provider/provider.dart';

import '../const/color/colors.dart';
import 'alarm_setting_state.dart';

class AlarmSettingPage extends StatelessWidget {
  const AlarmSettingPage({super.key});

  static const routeName = '/mypage/setting/alarm';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AlarmSettingState(context: context)),
      ],
      builder: (context, _) {
        return const AlarmSettingPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoingAppBar(
        title: '알림설정',
        imagePath: 'asset/icons/arrow_left.svg',
        onTap: () => Navigator.pop(context),
      ),
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 12),
              AlarmComponent(title: '전체 알림',),
              SizedBox(height: 32),
              AlarmComponent(title: '신규 업로드 알림', height: 66, subTitle: '빠른 공지, 미션 확인을 위해\n알림 ON을 유지해주세요!',),
              SizedBox(height: 32),
              AlarmComponent(title: '미션 리마인드 알림', height: 66, subTitle: '매일 오후 8시, 미션에 대한\n리마인드 알림을 드릴게요!',),
              SizedBox(height: 32),
              AlarmComponent(title: '불 던지기 알림',),
              const Spacer(),
              _NextBtn(context: context),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextBtn extends StatelessWidget {
  final BuildContext context;
  const _NextBtn({required this.context, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alarmSettingsState = context.watch<AlarmSettingState>();

    return SizedBox(
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
          alarmSettingsState.saveAlarmSettings();
          Navigator.of(context).pop();
        },
        child: const Text(
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
