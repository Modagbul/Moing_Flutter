import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';

class MoingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String imagePath;
  final Function onTap;

  const MoingAppBar({
    super.key,
    this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(imagePath, width: 24.0, height: 24.0),
        onPressed: () => onTap(),
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title ?? '',
          style: title != null
              ? const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: grayScaleGrey300,
                )
              : null,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
