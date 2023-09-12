import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class HomeMyMeeting extends StatelessWidget {
  final String meetingCount;

  const HomeMyMeeting({
    required this.meetingCount,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          '내 모임',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: grayScaleGrey400,
          ),
        ),
        const SizedBox(width: 12.0,),
        Text(
          meetingCount,
          style: const TextStyle(
            color: coralGrey600,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
