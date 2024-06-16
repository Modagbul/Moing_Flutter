import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/home/home_screen_state.dart';
import 'package:moing_flutter/utils/button/white_button.dart';
import 'package:provider/provider.dart';

class HomeNoCard extends StatelessWidget {
  const HomeNoCard({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle ts = TextStyle(
        fontWeight: FontWeight.w500,
        color: grayScaleGrey400,
        height: 1.7,
        fontSize: 16);

    return DottedBorder(
      borderType: BorderType.RRect,
      color: grayScaleGrey550,
      radius: const Radius.circular(24),
      dashPattern: const [10, 10, 10, 10],
      strokeWidth: 2,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: Container(
          width: double.infinity,
          height: 356,
          color: grayScaleGrey900,
          child: Column(
            children: [
              const Spacer(),
              const Text(
                '모임이 텅 비었어요.\n소모임을 만들어 친구를 초대해보세요.',
                textAlign: TextAlign.center,
                style: ts,
              ),
              const SizedBox(height: 43),
              SizedBox(
                width: 130,
                height: 50,
                child: WhiteButton(
                    onPressed: context.read<HomeScreenState>().makeGroupPressed,
                    text: '모임 만들기'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
