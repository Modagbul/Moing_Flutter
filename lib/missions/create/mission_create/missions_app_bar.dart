import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';

class MissionAppBar extends StatelessWidget {
  const MissionAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      child: Row(
        children: [
          Icon(
            Icons.close,
            color: Colors.white,
          ),
          SizedBox(width: 32),
          Text('신규미션 만들기',
              style: buttonTextStyle.copyWith(color: grayScaleGrey300)),
          Spacer(),
          Text('만들기', style: buttonTextStyle.copyWith(color: grayScaleGrey500)),
        ],
      ),
    );
  }
}
