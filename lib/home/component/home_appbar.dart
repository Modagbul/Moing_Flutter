import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBar extends StatelessWidget {
  final String notificationCount;
  final void Function() onTap;

  const HomeAppBar({
    required this.notificationCount,
    required this.onTap,
    super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            'asset/icons/home_moing_logo.svg',
            width: 80,
            height: 32,
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTap,
            child: SvgPicture.asset(
              'asset/icons/home_notification.svg',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}
