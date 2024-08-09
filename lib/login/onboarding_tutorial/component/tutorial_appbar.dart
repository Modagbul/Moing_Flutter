import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../const/color/colors.dart';

class TutorialAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageCount;

  const TutorialAppBar({
    required this.pageCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: grayScaleGrey700,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'asset/icons/icon_fire_app_bar.svg',
            width: 36,
            height: 36,
          ),
          const SizedBox(width: 4.0),
          const Text(
            '모잉 사용법',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12.0),
          Text(
            pageCount,
            style: const TextStyle(
              color: grayScaleGrey400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            '/4',
            style: TextStyle(
              color: grayScaleGrey400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
}
