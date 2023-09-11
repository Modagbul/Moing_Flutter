import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class MoingAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String? title;
  final String imagePath;
  final Function onTap;

  const MoingAppBar({super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      titleSpacing: title != null ? 20.0 : 12.0, // 12가 기본값
      title: Text(
        title ?? '',
        style: title != null
            ? const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: grayScaleGrey300,
              )
            : null,
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0,top: 12.0,bottom: 12.0,),
        child: GestureDetector(
          onTap: () => onTap(),
          child: Image.asset(imagePath),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize {
    return const Size.fromHeight(40.0);
  }
}
