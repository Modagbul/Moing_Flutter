import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/component/repeat_every_mission/every_mission_profile.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class EveryMissionProved extends StatelessWidget {
  const EveryMissionProved({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final missionProveState = context.watch<MissionProveState>();

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return renderContainer(index: index, context: context, isRepeated: missionProveState.isRepeated);
          },
          childCount: context.watch<MissionProveState>().everyMissionList!.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 172 / 191,
        ),
      ),
    );
  }

  Widget renderContainer({
    required int index,
    required BuildContext context,
    required bool isRepeated,
  }) {
    TextStyle ts = bodyTextStyle.copyWith(
        fontWeight: FontWeight.w500, color: grayScaleGrey200);

    if (context.watch<MissionProveState>().everyMissionList![index].status == 'SKIP') {
      return GestureDetector(
        onTap: () {
          context.read<MissionProveState>().getMissionDetailContent(index);
        },
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 155,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: grayScaleGrey700,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isRepeated)
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
                              '${context.watch<MissionProveState>().everyMissionList![index].count}',
                              style: bodyTextStyle.copyWith(color: grayScaleGrey400),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, right: 8),
                        child: GestureDetector(
                          onTap: () async {
                            int archiveId = context.read<MissionProveState>().everyMissionList![index].archiveId;
                            String heartStatus = context.read<MissionProveState>().everyMissionList![index].heartStatus;
                            await context.read<MissionProveState>().likePressed(index: index, archiveId: archiveId, heartStatus: heartStatus);
                          },
                          child: Image.asset(
                            context.watch<MissionProveState>().everyMissionList![index].heartStatus == "true"
                                ? 'asset/image/icon_click_like.png'
                            : 'asset/image/icon_nonclick_like.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      context.watch<MissionProveState>().everyMissionList![index].archive,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: bodyTextStyle.copyWith(color: grayScaleGrey200, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 12),
                    child: Text(
                      '미션을 건너뛰었어요',
                      style: bodyTextStyle.copyWith(color: grayScaleGrey400),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            EveryMissionProfile(index: index),
          ],
        ),
      );
    }
    /// 사진 인증
    if (context.watch<MissionProveState>().everyMissionList![index].way ==
        'PHOTO' &&
        context
            .watch<MissionProveState>()
            .everyMissionList![index]
            .status ==
            'COMPLETE') {
      return Stack(
        children: [
          GestureDetector(
            onTap: () {
              context.read<MissionProveState>().getMissionDetailContent(index);
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    context
                        .watch<MissionProveState>()
                        .everyMissionList![index]
                        .archive,
                    fit: BoxFit.cover,
                    width: 172,
                    height: 155,
                  ),
                ),
                SizedBox(height: 4),
                EveryMissionProfile(index: index),
              ],
            ),
          ),
          if (isRepeated)
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
                  '${context.watch<MissionProveState>().everyMissionList![index].count}',
                  style: bodyTextStyle.copyWith(color: grayScaleGrey400),
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: () async {
                int archiveId = context.read<MissionProveState>().everyMissionList![index].archiveId;
                String heartStatus = context.read<MissionProveState>().everyMissionList![index].heartStatus;
                await context.read<MissionProveState>().likePressed(index: index, archiveId: archiveId, heartStatus: heartStatus);
              },
              child: Image.asset(
                context.watch<MissionProveState>().everyMissionList![index].heartStatus == "true"
                    ? 'asset/image/icon_click_like.png'
                    : 'asset/image/icon_nonclick_like.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      );
    }
    /// 텍스트 인증
    else if (context.watch<MissionProveState>().everyMissionList![index].way == 'TEXT' &&
        context.watch<MissionProveState>().everyMissionList![index].status == 'COMPLETE') {
      return GestureDetector(
        onTap: () {
          context.read<MissionProveState>().getMissionDetailContent(index);
        },
        child: Column(
          children: [
            Container(
              height: 155,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: grayScaleGrey700,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isRepeated)
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
                              '${context.watch<MissionProveState>().everyMissionList![index].count}',
                              style: bodyTextStyle.copyWith(color: grayScaleGrey400),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, right: 8),
                        child: GestureDetector(
                          onTap: () async {
                            int archiveId = context.read<MissionProveState>().everyMissionList![index].archiveId;
                            String heartStatus = context.read<MissionProveState>().everyMissionList![index].heartStatus;
                            await context.read<MissionProveState>().likePressed(index: index, archiveId: archiveId, heartStatus: heartStatus);
                          },
                          child: Image.asset(
                            context.watch<MissionProveState>().everyMissionList![index].heartStatus == "true"
                                ? 'asset/image/icon_click_like.png'
                                : 'asset/image/icon_nonclick_like.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final String text = context
                          .watch<MissionProveState>()
                          .everyMissionList![index]
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
                          padding: const EdgeInsets.only(left: 12.0, right: 12),
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
                          padding: const EdgeInsets.only(left: 12.0, right: 12),
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
            SizedBox(height: 4),
            EveryMissionProfile(index: index),
          ],
        ),
      );
    }
    /// 링크 인증
    else {
      return GestureDetector(
        onTap: () {
          context.read<MissionProveState>().getMissionDetailContent(index);
        },
        child: Column(
          children: [
            Container(
              height: 155,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: grayScaleGrey700,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isRepeated)
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
                            '${context.watch<MissionProveState>().everyMissionList![index].count}',
                            style: bodyTextStyle.copyWith(color: grayScaleGrey400),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 20),
                        child: LayoutBuilder(
                          builder:
                              (BuildContext context, BoxConstraints constraints) {
                            final String text = context
                                .watch<MissionProveState>()
                                .everyMissionList![index]
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
                          Image.asset(
                            'asset/image/icon_link_white.png',
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
            ),
            SizedBox(height: 4),
            EveryMissionProfile(index: index),
          ],
        ),
      );
    }
  }
}
