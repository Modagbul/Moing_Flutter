import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class SingleMyMissionProved extends StatelessWidget {
  const SingleMyMissionProved({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: grayScaleGrey700,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Image.asset(
                'asset/image/black.jpeg',
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(top: 24, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '23.08.05',
                      style: bodyTextStyle.copyWith(
                        color: grayScaleGrey300,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '21:59',
                      style: bodyTextStyle.copyWith(
                        color: grayScaleGrey300,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      underline: SizedBox.shrink(),
                      style: contentTextStyle.copyWith(color: grayScaleGrey100),
                      dropdownColor: grayScaleGrey500,
                      icon: Icon(
                        Icons.more_vert_outlined,
                        color: grayScaleGrey300,
                      ),
                      iconEnabledColor: Colors.white,
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                            child: Container(
                                padding: EdgeInsets.only(right: 8),
                                alignment: Alignment.centerRight,
                                child: Text('인증 수정하기')),
                            value: 'fix'),
                        DropdownMenuItem(
                            child: Container(
                              padding: EdgeInsets.only(right: 8),
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('다시 인증하기'),
                                  Text(
                                    '기존 인증내역이 취소돼요',
                                    style: bodyTextStyle.copyWith(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            value: 'retry'),
                      ],
                      isDense: true,
                      onChanged: (String? val) {
                        context.read<MissionProveState>().setMission(val);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
