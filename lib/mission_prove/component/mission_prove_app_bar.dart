import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';

class MissionProveAppBar extends StatelessWidget {
  const MissionProveAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle ts = contentTextStyle.copyWith(
      color: grayScaleGrey300,
      fontWeight: FontWeight.w600,
    );

    return Container(
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
              child: Text('미션내용', style: ts,)),
          SizedBox(width: 32),
          GestureDetector(
              onTap: () {
                print('더보기 클릭');
              },
              child: Text('더보기', style: ts,)),
        ],
      ),
    );
  }
}
