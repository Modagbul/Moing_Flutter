import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/create/missions_create_state.dart';
import 'package:provider/provider.dart';

class MissionsFooter extends StatelessWidget {
  const MissionsFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bottomSheetPressed(context),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 100),
        child: Container(
          width: 222,
          height: 54,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewPadding.bottom),
          decoration: BoxDecoration(
            color: coralGrey500,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '이런 미션은 어때요?',
                style: buttonTextStyle.copyWith(color: Colors.white),
              ),
              SizedBox(
                width: 8,
              ),
              Image.asset(
                'asset/image/icon_arrow_circle_up.png',
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void bottomSheetPressed(BuildContext context) {
    TextStyle ts = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 20,
      color: grayScaleGrey100
    );

    final List<String> textList = [
      '매일 물 2L 마시기',
      '매일 아침 이불정리하기',
      '오전 7시 기상 인증하기',
      '모닝페이지 작성하기',
      '하루 계획 세우기',
      '일어나자마자 양치하기',
      '휴대폰 6시간 이하 쓰기',
    ];

    print('버튼 클릭');
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            height: 391,
            decoration: const BoxDecoration(
              color: grayScaleGrey600,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 34,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('#생활습관을 개선하는', style: ts),
                      Text(' 인증미션 추천', style: ts.copyWith(color: grayScaleGrey400)),
                      SizedBox(width: 44),
                      Icon(Icons.close,
                      size: 28,
                      color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 32),
                  GridView.builder(
                    itemCount: textList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                      return Text(
                          textList[index]
                      );
                      }),
                ],
              ),
            )
          );
        });
  }
}
