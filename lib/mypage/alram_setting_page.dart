import 'package:flutter/material.dart';
import 'package:moing_flutter/mypage/component/list_toggle_tile.dart';
import 'package:moing_flutter/mypage/setting_state.dart';
import 'package:moing_flutter/utils/app_bar/moing_app_bar.dart';
import 'package:provider/provider.dart';

import '../const/color/colors.dart';
import 'alram_setting_state.dart';
import 'component/list_custom_tile.dart';
import 'component/list_toggle_tile_no_sub.dart';

class AlramSettingPage extends StatefulWidget {
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
  State<AlramSettingPage> createState() => _AlramSettingPageState();
}

class _AlramSettingPageState extends State<AlramSettingPage> {
  bool isTotalAlarmOn = true;
  bool isNewUploadPushOn = true;
  bool isRemindPushOn = true;
  bool isFirePushOn = true;

  @override
  Widget build(BuildContext context) {
    final alarmSettingsState = Provider.of<AlramSettingState>(context);

    final state = context.watch<AlramSettingState>();

    void handleTotalAlarmToggle(bool isTotalOn) {
      setState(() {
        isTotalAlarmOn = isTotalOn;

        alarmSettingsState.changeAlarmSettings(isTotalOn, isTotalOn, isTotalOn);
      });
    }

    void handleChangeAlarmSettings(bool newUploadPush, bool remindPush, bool firePush) {
      alarmSettingsState.changeAlarmSettings(newUploadPush, remindPush, firePush);
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
              initialValue: isTotalAlarmOn,
              onToggle: (value) {
                handleTotalAlarmToggle(value);
              },
            ),
            ListToggleTile(
              listName: '신규 공지 알림',
              subText: '빠른 공지 확인을 위해\n알림 ON을 유지해주세요!',
              initialValue: state.getAlarmSettings?.data.newUploadPush ?? true,
              onToggle: (value) {
                handleChangeAlarmSettings(
                    value,
                    state.getAlarmSettings?.data.remindPush ?? true,
                    state.getAlarmSettings?.data.firePush ?? true);
              },
            ),
            ListToggleTile(
              listName: '미션 리마인드 알림',
              subText: '매일 오전 8시, 미션에 대한\n리마인드 알림을 드릴게요!',
              initialValue: state.getAlarmSettings?.data.remindPush ?? true,
              onToggle: (value) {
                handleChangeAlarmSettings(
                    value,
                    state.getAlarmSettings?.data.newUploadPush ?? true,
                    state.getAlarmSettings?.data.firePush ?? true);
              },
            ),
            ListToggleTileNoSub(
              listName: '불 던지기 알림',
              initialValue: state.getAlarmSettings?.data.firePush ?? true,
              onToggle: (value) {
                handleChangeAlarmSettings(
                    value,
                    state.getAlarmSettings?.data.remindPush ?? true,
                    state.getAlarmSettings?.data.newUploadPush ?? true);
              },
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
    final alarmSettingsState = Provider.of<AlramSettingState>(context, listen: false);

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
