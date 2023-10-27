import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';

class MissionEndDate extends StatelessWidget {
  const MissionEndDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 52),
        Text(
          '미션 마감일',
          style: contentTextStyle.copyWith(
              fontWeight: FontWeight.w600, color: grayScaleGrey200),
        ),
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          height: 48,
          child: Row(
            children: [
              Icon(Icons.check_box_rounded, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(
                '반복미션으로 변경하기',
                style: contentTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              padding: EdgeInsets.only(left: 12, ),
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: grayScaleGrey700,
              ),
              child: Text(
                '인증횟수 설정하기',
                style: contentTextStyle.copyWith(color: grayScaleGrey550),
              ),
            ),
            Positioned(
              right: 12, top: 8,bottom: 8,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 111,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: grayScaleGrey500
                    ),
                    child: Text(
                      '10:00',
                      style: contentTextStyle.copyWith(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
