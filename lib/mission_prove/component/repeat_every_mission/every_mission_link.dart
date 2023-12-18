import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class EveryMissionLink extends StatelessWidget {
  final int index;
  const EveryMissionLink({required this.index, Key? key}) : super(key: key);

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
          Padding(
              padding:
              const EdgeInsets.only(left: 12, right: 12, top: 55),
              child: LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints constraints) {
                  final String text = state.everyMissionList![index].archive;
                  final TextStyle textStyle = bodyTextStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      color: grayScaleGrey400);
                  final TextSpan textSpan =
                  TextSpan(text: text, style: textStyle);
                  final TextPainter textPainter = TextPainter(
                    text: textSpan,
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                  );

                  textPainter.layout(maxWidth: constraints.maxWidth);
                  // 텍스트 길이가 8자 이상이면서 실제 레이아웃 상에서 넘칠 경우
                  if (text.length > 7 || textPainter.didExceedMaxLines) {
                    return Text(
                      text,
                      style: textStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  } else {
                    return Text(
                      text,
                      style: textStyle,
                      maxLines: 1,
                    );
                  }
                },
              ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'asset/icons/icon_link_white.svg',
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 8),
                Text(
                  '바로보기',
                  style: bodyTextStyle.copyWith(color: grayScaleGrey100),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
