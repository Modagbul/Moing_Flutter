import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moing_flutter/const/color/colors.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String notificationCount;
  final void Function() onTapAlarm;
  final void Function() onTapSetting;
  final int screenIndex;

  const MainAppBar({
    required this.notificationCount,
    required this.onTapAlarm,
    required this.onTapSetting,
    required this.screenIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: grayBackground,
      title: SvgPicture.asset(
        'asset/icons/moing_logo.svg',
        width: 80,
        height: 32,
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 21,
              height: 25,
              decoration: const BoxDecoration(
                color: Color(0xffFF6464),
                shape: BoxShape.circle,
              ),
            ),
            Text(
              notificationCount,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onTapAlarm,
          child: SvgPicture.asset(
            'asset/image/icon_notification.svg',
            width: 24.0,
            height: 24.0,
          ),
        ),
        if (screenIndex == 2) const SizedBox(width: 24.0),
        if (screenIndex == 2)
          GestureDetector(
            onTap: onTapSetting,
            child: SvgPicture.asset(
              'asset/image/main_setting.svg',
              width: 24.0,
              height: 24.0,
            ),
          ),
        const SizedBox(width: 20.0),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
