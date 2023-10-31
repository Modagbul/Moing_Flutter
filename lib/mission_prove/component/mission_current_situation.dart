import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';

class MissionCurrentSituation extends StatelessWidget {
  const MissionCurrentSituation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              width: double.infinity,
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                          'asset/image/icon_mission_not_yet.png'
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Image.asset(
                                    'asset/image/icon_clock.png'
                                ),
                              ),
                              SizedBox(width: 4),
                              Text('13시간 11분 후 종료', style: bodyTextStyle,)
                            ],
                          ),
                          SizedBox(height: 12),
                          Text('작업한 내용 인증하기', style: middleTextStyle),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            RoundedProgressBar(
              milliseconds: 1000,
              borderRadius: BorderRadius.circular(24),
              childLeft: Text('3/9명 인증성공',style: bodyTextStyle.copyWith(color: grayScaleGrey100),),
              percent: 40,
              style: RoundedProgressBarStyle(
                colorBorder: Colors.transparent,
                colorProgress: coralGrey500,
                backgroundProgress: grayScaleGrey600,
                widthShadow: 0,
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
