import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class RepeatMyMissionProved extends StatelessWidget {
  const RepeatMyMissionProved({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return renderContainer(index: index, context: context);
          },
          childCount: context.watch<MissionProveState>().myMissionList!.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 172 / 155,
        ),
      ),
    );
  }

  Widget renderContainer({
    required int index,
    required BuildContext context,
  }) {
    var state = context.watch<MissionProveState>();
    int comment = 0;
    if(state.myMissionList != null) comment = state.myMissionList![index].comments ?? 0;
    if (state.myMissionList![index].status == 'SKIP') {
      return GestureDetector(
        onTap: () async {
          await context.read<MissionProveState>().loadMyMissionCommentData(
              context.read<MissionProveState>().myMissionList![index].archiveId);
          context.read<MissionProveState>().getMissionDetailContent(index);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: grayScaleGrey700,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, left: 12),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: grayScaleGrey500,
                      ),
                      child: Center(
                        child: Text(
                          '${state.myMissionList!.length - index}',
                          style: bodyTextStyle.copyWith(color: grayScaleGrey400),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, right: 12),
                    child: missionComment(comment: comment),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  state.myMissionList![index].archive,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: bodyTextStyle.copyWith(color: grayScaleGrey200, fontWeight: FontWeight.w500),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 12),
                child: Text(
                  '미션을 건너뛰었어요',
                  style: bodyTextStyle.copyWith(color: grayScaleGrey400),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (state.myMissionList![index].way == 'PHOTO' &&
        state.myMissionList![index].status == 'COMPLETE') {
      return Stack(
        children: [
          GestureDetector(
            onTap: () async {
              await context.read<MissionProveState>().loadMyMissionCommentData(
                  context.read<MissionProveState>().myMissionList![index].archiveId);
              context.read<MissionProveState>().getMissionDetailContent(index);
            },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 172,
                  height: 155,
                  child: Image.network(
                    state.myMissionList![index].archive,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: grayScaleGrey500,
              ),
              child: Center(
                child: Text(
                  '${state.myMissionList!.length - index}',
                  style: bodyTextStyle.copyWith(color: grayScaleGrey400),
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: missionComment(comment: comment),
          ),
        ],
      );
    }
    // 텍스트인 경우
    else if (context.watch<MissionProveState>().myMissionList![index].way == 'TEXT' &&
        context.watch<MissionProveState>().myMissionList![index].status == 'COMPLETE') {
      return GestureDetector(
        onTap: () async {
          await context.read<MissionProveState>().loadMyMissionCommentData(
              context.read<MissionProveState>().myMissionList![index].archiveId);
          context.read<MissionProveState>().getMissionDetailContent(index);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: grayScaleGrey700,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, left: 12),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: grayScaleGrey500,
                      ),
                      child: Center(
                        child: Text(
                          '${context.watch<MissionProveState>().myMissionList!.length - index}',
                          style: bodyTextStyle.copyWith(color: grayScaleGrey400),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, right: 12),
                    child: missionComment(comment: comment),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final String text = context
                      .watch<MissionProveState>()
                      .myMissionList![index]
                      .archive;
                  final TextStyle textStyle = bodyTextStyle.copyWith(
                      fontWeight: FontWeight.w500, color: grayScaleGrey200);
                  final TextSpan textSpan =
                      TextSpan(text: text, style: textStyle);
                  final TextPainter textPainter = TextPainter(
                    text: textSpan,
                    maxLines: 3,
                    textDirection: TextDirection.ltr,
                  );

                  textPainter.layout(maxWidth: constraints.maxWidth);

                  // overflow 발생 시
                  if (textPainter.didExceedMaxLines) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0),
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
                    );
                  }
                  // 오버플로우 발생 X
                  else {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        text,
                        style: textStyle,
                        maxLines: 3,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    }
    // 링크인 경우
    else {
      return GestureDetector(
        onTap: () async {
          await context.read<MissionProveState>().loadMyMissionCommentData(
              context.read<MissionProveState>().myMissionList![index].archiveId);
          context.read<MissionProveState>().getMissionDetailContent(index);
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: grayScaleGrey700,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 12),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: grayScaleGrey500,
                        ),
                        child: Center(
                          child: Text(
                            '${context.watch<MissionProveState>().myMissionList!.length - index}',
                            style: bodyTextStyle.copyWith(color: grayScaleGrey400),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, right: 12),
                      child: missionComment(comment: comment),
                    ),
                  ],
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 20),
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        final String text = context
                            .watch<MissionProveState>()
                            .myMissionList![index]
                            .archive;
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
                    )),
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
            )),
      );
    }
  }

  Widget missionComment({required int comment}) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: grayScaleGrey500.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
                'asset/icons/message.svg',
                width: 16,
                height: 16,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)
            ),
            const SizedBox(width: 4),
            Text(
              comment > 99 ? '99+' : comment.toString(),
              style: bodyTextStyle.copyWith(color: grayScaleGrey200),
            ),
          ],
        )
    );
  }
}
