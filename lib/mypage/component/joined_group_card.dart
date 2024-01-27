import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/model/response/get_my_page_data_response.dart';

class JoinedGroupCard extends StatelessWidget {
  final TeamBlock teamBlock;

  const JoinedGroupCard({super.key, required this.teamBlock});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: teamBlock.profileImgUrl != null &&
                    teamBlock.profileImgUrl.isNotEmpty
                ? Image.network(
                    teamBlock.profileImgUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return SvgPicture.asset(
                        'asset/icons/group_basic_image.svg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : SvgPicture.asset(
                    'asset/icons/group_basic_image.svg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 12.0),
          Container(
            width: 65,
            height: 44,
            alignment: Alignment.topCenter,
            child: Text(
              teamBlock.teamName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: grayScaleWhite,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
