import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/main/alarm/alarm_list.dart';
import 'package:moing_flutter/main/alarm/alarm_state.dart';
import 'package:moing_flutter/utils/app_bar/moing_app_bar.dart';
import 'package:provider/provider.dart';

class AlarmPage extends StatelessWidget {
  static const routeName = '/alarm';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlarmState(context: context)),
      ],
      builder: (context, _) {
        return AlarmPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Alarm> alarmList = context.watch<AlarmState>().alarmList;

    return Scaffold(
      appBar: MoingAppBar(
        title: '알림 모아보기',
        imagePath: 'asset/image/arrow_left.png',
        onTap: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 24,),
              Expanded(
                child: ListView.builder(
                  itemCount: alarmList.length,
                  itemExtent: 108,
                  itemBuilder: (context, position) {
                    final Alarm alarm = alarmList[position];
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {}, // 해당 페이지로 이동
                      child: Card(
                        color: Colors.transparent,
                        margin: EdgeInsets.zero,
                        // color: Colors.transparent,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32.5),
                              child: Image.asset(
                                alarmList![position].imagePath!,
                                width: 42,
                                height: 42,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alarmList![position].team!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: grayScaleGrey400,
                                    ),
                                  ),
                                  Text(
                                    alarmList![position].title!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: grayScaleGrey100,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                alarmList![position].time!,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: grayScaleGrey550,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 61.0),
                child: Text(
                  '받은 알림은 90일동안 보관해요',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: grayScaleGrey550,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
