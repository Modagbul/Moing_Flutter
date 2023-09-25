import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/main/alarm/alarm_list.dart';
import 'package:moing_flutter/main/alarm/alarm_state.dart';
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
    final List<Alarm> alarmList = context.watch<AlarmState>().alarmList;

    return Scaffold(
      appBar: MoingAppBar(
        title: '알림 모아보기',
        imagePath: 'asset/image/arrow_left.png',
        onTap: () => Navigator.pop(context),
      ),
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 24,),
              Expanded(
                child: ListView.builder(
                  itemCount: alarmList.length + 1,
                  itemExtent: 108,
                  itemBuilder: (context, position) {
                    if (position < alarmList.length) {
                      final Alarm alarm = alarmList[position];
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          print('눌렀다!');
                        }, // 해당 페이지로 이동
                        child: Card(
                          color: grayScaleGrey900,
                          margin: EdgeInsets.zero,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: grayScaleGrey400,
                                      ),
                                    ),
                                    SizedBox(height: 8,),
                                    Flexible(
                                      child: Text(
                                        alarmList![position].title!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: grayScaleGrey100,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 268,
                                      child: Text(
                                        alarmList![position].content!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: grayScaleGrey400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    alarmList![position].time!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: grayScaleGrey550,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                   else {
                     return SizedBox(height: 40,);
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only( bottom: 40.0),
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
