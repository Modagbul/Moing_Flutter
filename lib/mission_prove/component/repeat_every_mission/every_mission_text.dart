import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class EveryMissionText extends StatelessWidget {
  final int index;
  const EveryMissionText({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MissionProveState>();
    return Container(
      width: double.infinity,
      height: 155,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: grayScaleGrey700,
      ),
      child: Column(
        children: [
          const SizedBox(height: 56),
          LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints constraints) {
              final String text = state.everyMissionList![index].archive;
              final TextStyle textStyle = bodyTextStyle.copyWith(
                  fontWeight: FontWeight.w500, color: grayScaleGrey200);
              final TextSpan textSpan = TextSpan(text: text, style: textStyle);
              final TextPainter textPainter = TextPainter(
                text: textSpan,
                maxLines: 3,
                textDirection: TextDirection.ltr,
              );

              textPainter.layout(maxWidth: constraints.maxWidth);
              // overflow 발생 시
              if (textPainter.didExceedMaxLines) {
                return Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: textStyle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '...',
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                );
              }
              // 오버플로우 발생 X
              else {
                return Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      text,
                      style: textStyle,
                      maxLines: 3,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
