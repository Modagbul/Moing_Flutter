import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/main/alarm/alarm_state.dart';
import 'package:moing_flutter/model/response/alarm_model.dart';
import 'package:moing_flutter/utils/app_bar/moing_app_bar.dart';
import 'package:provider/provider.dart';

class AlarmPage extends StatelessWidget {
  static const routeName = '/alarm';

  const AlarmPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlarmState(context: context)),
      ],
      builder: (context, _) {
        return const AlarmPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<AlarmData>? alarmList = context.watch<AlarmState>().alarmList;

    return Scaffold(
      appBar: MoingAppBar(
        title: '알림 모아보기',
        imagePath: 'asset/icons/arrow_left.svg',
        onTap: () => Navigator.pop(context, {'result': true, 'screenIndex': 0}),
      ),
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: alarmList == null
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(grayScaleGrey100),
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: alarmList.length + 1,
                        itemBuilder: (context, position) {
                          if (position < alarmList.length) {
                            final AlarmData alarm = alarmList[position];
                            return Column(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => context.read<AlarmState>().onTapAlarm(index: position), // 해당 페이지로 이동
                                  child: Card(
                                    color: alarm.isRead
                                        ? grayScaleGrey900
                                        : grayScaleGrey600,
                                    margin: EdgeInsets.zero,
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 16.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            context
                                                .read<AlarmState>()
                                                .convertAlarmTypeToImage(
                                                    type: alarm.type),
                                            width: 42,
                                            height: 42,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      alarm.name,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: grayScaleGrey400,
                                                      ),
                                                    ),
                                                    Text(
                                                      alarm.createdDate,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color: grayScaleGrey550,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  alarm.title,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: grayScaleGrey100,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  alarm.body,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: grayScaleGrey400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                              ],
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  '받은 알림은 일주일 동안 보관해요',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: grayScaleGrey550,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
