import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class MoingAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String? title;
  final String imagePath;
  final Function onTap;
  final double spacing;

  const MoingAppBar({super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    this.spacing = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0,top: 12.0,bottom: 12.0,),
            child: GestureDetector(
              onTap: () => onTap(),
              child: Image.asset(imagePath),
            ),
          ),
          SizedBox(width: spacing,),
          Text(
            title ?? '',
            style: title != null
                ? const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: grayScaleGrey300,
            )
                : null,
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize {
    return const Size.fromHeight(40.0);
  }
}
