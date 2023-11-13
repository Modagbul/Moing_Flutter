import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';

class IntroduceText extends StatelessWidget {
  final String title;
  final String comment;

  const IntroduceText({required this.title, required this.comment, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 100;
    if(title.contains('인증') || title.contains('소통')) {
      width = 72;
    }
    else if (title.contains('키우기')) {
      width = 87;
    }
    else if (title.contains('던지기')) {
      width = 75;
    }

    return Container(
      width: 250,
      height: 125,
      child: Column(
        children: [
          Container(
            width: width,
            height: 25,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: grayScaleGrey600,
            ),
            child: Text(
              title,
              style: bodyTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            comment,
            style: headerTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
