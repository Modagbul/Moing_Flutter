import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/component/repeat_every_mission/every_mission_link.dart';
import 'package:moing_flutter/mission_prove/component/repeat_every_mission/every_mission_photo.dart';
import 'package:moing_flutter/mission_prove/component/repeat_every_mission/every_mission_profile.dart';
import 'package:moing_flutter/mission_prove/component/repeat_every_mission/every_mission_skip.dart';
import 'package:moing_flutter/mission_prove/component/repeat_every_mission/every_mission_text.dart';
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
            return renderContainer(
                index: index,
                context: context,
                isRepeated: missionProveState.isRepeated);
          },
          childCount:
          context.watch<MissionProveState>().everyMissionList!.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 4,
          childAspectRatio: 172 / 196,
        ),
      ),
    );
  }

  Widget renderContainer({
    required int index,
    required BuildContext context,
    required bool isRepeated,
  }) {
    var watchState = context.watch<MissionProveState>();
    var readState = context.read<MissionProveState>();
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            await readState.loadMyMissionCommentData(readState.everyMissionList![index].archiveId);
            readState.getMissionDetailContent(index);
          },
          child: Column(
            children: [
              // 스킵일 때
              if(watchState.everyMissionList![index].status == 'SKIP')
                EveryMissionSkip(index: index),
              if(watchState.everyMissionList![index].status == 'COMPLETE' &&
                  watchState.everyMissionList![index].way == 'PHOTO')
                EveryMissionPhoto(index: index),
              if (watchState.everyMissionList![index].status == 'COMPLETE' &&
                  watchState.everyMissionList![index].way == 'TEXT')
                EveryMissionText(index: index),
              if (watchState.everyMissionList![index].status == 'COMPLETE' &&
                  watchState.everyMissionList![index].way == 'LINK')
                EveryMissionLink(index: index),
              SizedBox(height: 3),
              EveryMissionProfile(index: index),
            ],
          ),
        ),
          Positioned(
            left: 12,
            top: 12,
            child: isRepeated
                ? Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: grayScaleGrey500,
              ),
              child: Center(
                child: Text(
                  '${watchState.everyMissionList![index].count}',
                  style: bodyTextStyle.copyWith(color: grayScaleGrey400),
                ),
              ),
            ) : (watchState.everyMissionList![index].way == 'LINK')
                ? SvgPicture.asset(
              'asset/icons/icon_link_white.svg',
              width: 24,
              height: 24,
              color: grayScaleGrey550,
            ) : (watchState.everyMissionList![index].way == 'TEXT')
             ? SvgPicture.asset(
              'asset/icons/icon_text.svg',
              width: 24,
              height: 24,
              color: grayScaleGrey550,
            ) : SizedBox.shrink(),
          ),
        Positioned(
          right: 4,
          top: 4,
          child: GestureDetector(
            onTap: () async {
              int archiveId = readState.everyMissionList![index].archiveId;
              String heartStatus = readState.everyMissionList![index].heartStatus;
              await readState.likePressed(index: index, archiveId: archiveId, heartStatus: heartStatus);
            },
            child: SvgPicture.asset(
              watchState.everyMissionList![index].heartStatus == "true"
                  ? 'asset/icons/icon_click_like.svg'
                  : 'asset/icons/icon_nonclick_like.svg',
              width: 40,
              height: 40,
            ),
          ),
        ),
      ],
    );
  }
}
