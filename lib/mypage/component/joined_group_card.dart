import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/model/response/get_my_page_data_response.dart';

class JoinedGroupCard extends StatelessWidget {
  final TeamBlock teamBlock;

  const JoinedGroupCard({super.key, required this.teamBlock});

  @override
  Widget build(BuildContext context) {
    String imageAsset = '';

    print(teamBlock.category);
    switch(teamBlock.category) {
      case 'SPORTS':
        break;
      case 'HABIT':
        break;
      case 'TEST':
        break;
      case 'STUDY':
        break;
      case 'READING':
        break;
      case 'ETC':
        break;
    }
    return Column(
      children: [
        Image.asset(
          'asset/image/icon_book.png',
          width: 80,
          height: 80,
        ),
        const SizedBox(height: 12.0),
        Text(
          teamBlock.teamName,
          style: const TextStyle(
            color: grayScaleWhite,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
