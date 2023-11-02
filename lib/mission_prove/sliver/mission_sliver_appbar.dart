import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';

class MissionSliverAppBar extends StatelessWidget {
  const MissionSliverAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle ts = contentTextStyle.copyWith(
      color: grayScaleGrey300,
      fontWeight: FontWeight.w600,
    );
    return SliverAppBar(
      // // 스크롤 했을때 리스트의 중간에도 AppBar가 내려오게 할 수 있다.
      // floating: true,
      // AppBar 완전 고정
      pinned: true,
      // expandedHeight: 200,
      // collapsedHeight: 150,
      // flexibleSpace: FlexibleSpaceBar(
      //   // 맨 밑에 나온다.
      //   // 실질적으로는 전체 공간을 다 차지한다.
      //   title: Text('FlexibleSpace'),
      //   background: Image.asset(
      //     'asset/img/image_1.jpeg',
      //     fit: BoxFit.cover,
      //   ),
      // ),
      title: Container(
        color: grayBackground,
        height: 56,
        child: Row(
          children: [
            Image.asset(
              'asset/image/arrow_left.png',
            ),
            Spacer(),
            GestureDetector(
                onTap: () {
                  print('미션 내용 클릭');
                },
                child: Text(
                  '미션내용',
                  style: ts,
                )),
            SizedBox(width: 32),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                  onTap: () {
                    print('더보기 클릭');
                  },
                  child: Text(
                    '더보기',
                    style: ts,
                  )),
            ),
          ],
        ),
      ),
      backgroundColor: grayBackground,
    );
  }
}
