import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';

class MissionFireAppBar extends StatelessWidget {
  const MissionFireAppBar({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Icon(Icons.close, size: 28, color: Colors.white,),
        ),
        const SizedBox(width: 32),
        Text('불 던지기', style: buttonTextStyle.copyWith(color: grayScaleGrey300)),
        Spacer(),
        GestureDetector(
            onTap: (){},
            child: Icon(Icons.more_vert, size: 24, color: grayScaleGrey300)),
      ],
    );
  }
}
