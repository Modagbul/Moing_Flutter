import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';

class MissionFireAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MissionFireAppBar({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return  AppBar(
      backgroundColor: grayBackground,
      elevation: 0,
      title:   Text('불 던지기', style: buttonTextStyle.copyWith(color: grayScaleGrey300)),
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.close, size: 28, color: Colors.white,),// 뒤로 가기 아이콘
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
