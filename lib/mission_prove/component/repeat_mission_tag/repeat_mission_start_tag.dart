import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moing_flutter/const/color/colors.dart';

class RepeatMissionTag extends StatelessWidget {
  const RepeatMissionTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String tagText = '';

    if (now.weekday == DateTime.sunday) {
      tagText = '내일 시작';
    } else {
      int daysToSunday = DateTime.sunday - now.weekday;
      if (daysToSunday > 0) {
        tagText = '${daysToSunday+1}일 후 시작';
      } else if (now.weekday == DateTime.sunday) {
        tagText = '내일 리셋';
      }
    }

    return tagText.isNotEmpty
        ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: coralGrey900,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                SvgPicture.asset(
                  'asset/icons/mission_repeat_timer.svg',
                  width: 16.0,
                  height: 16.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 1.0),
                Text(
                  tagText,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: coralGrey300,
                  ),
                ),
              ],
            ),
          ),
        )
    : const SizedBox.shrink();
  }
}
