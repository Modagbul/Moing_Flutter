import 'package:flutter/material.dart';
import 'package:moing_flutter/mypage/component/list_toggle_tile.dart';
import 'package:moing_flutter/utils/app_bar/moing_app_bar.dart';
import 'package:provider/provider.dart';

import '../const/color/colors.dart';
import 'alarm_setting_state.dart';
import 'component/list_toggle_tile_no_sub.dart';

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
    var alarmSettingState = context.watch<AlarmSettingState>();

    if (alarmSettingState.isTotalAlarmOn == null) {
      return const CircularProgressIndicator();
    }

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
            ListToggleTileNoSub(
              listName: '전체 알림',
              initialValue: context.watch<AlarmSettingState>().isTotalAlarmOn!,
              onToggle: (value) => context.read<AlarmSettingState>().changeAllAlarms(value),
            ),
            ListToggleTile(
              listName: '신규 공지 알림',
              subText: '빠른 공지 확인을 위해\n알림 ON을 유지해주세요!',
              initialValue: context.watch<AlarmSettingState>().isNewUploadPushOn!,
              onToggle: (value) => context.read<AlarmSettingState>().changeNewAlarm(value),
            ),
            ListToggleTile(
              listName: '미션 리마인드 알림',
              subText: '매일 오전 8시, 미션에 대한\n리마인드 알림을 드릴게요!',
              initialValue: context.watch<AlarmSettingState>().isRemindPushOn!,
              onToggle: (value) => context.read<AlarmSettingState>().changeRemindAlarm(value),
            ),
            ListToggleTileNoSub(
              listName: '불 던지기 알림',
              initialValue: context.watch<AlarmSettingState>().isFirePushOn!,
              onToggle: (value) => context.read<AlarmSettingState>().changeFireAlarm(value),
            ),
            const Spacer(),
            const _NextBtn(),
            const SizedBox(height: 32.0),
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
    final alarmSettingsState =
        Provider.of<AlarmSettingState>(context, listen: false);

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
