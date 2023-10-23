import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class JoinedGroupCard extends StatelessWidget {
  const JoinedGroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'asset/image/icon_book.png',
          width: 80,
          height: 80,
        ),
        const SizedBox(height: 12.0),
        const Text(
          '북시즘',
          style: TextStyle(
            color: grayScaleWhite,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
