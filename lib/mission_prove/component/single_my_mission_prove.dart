import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class SingleMyMissionProved extends StatelessWidget {
  const SingleMyMissionProved({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: (context.watch<MissionProveState>().missionWay.length > 1 &&
                  context.watch<MissionProveState>().missionWay.contains('링크') &&
                  context.watch<MissionProveState>().myMissionList![0].status == 'COMPLETE')
              ? 192 : 300,
              decoration: BoxDecoration(
                color: grayScaleGrey700,
                borderRadius: BorderRadius.circular(16),
              ),
              child:
              /// 건너뛰기 한 경우
              context.watch<MissionProveState>().myMissionList![0].status == 'SKIP'
            ? Padding(
              padding: const EdgeInsets.only(top: 68.0, left: 16),
              child: Text('건너뛰기했지롱~', style: contentTextStyle.copyWith(color: Colors.white)),
            )
              /// 사진 인증
              : context.watch<MissionProveState>().missionWay.length > 1 &&
                  context.watch<MissionProveState>().missionWay.contains('사진') &&
                  context.watch<MissionProveState>().myMissionList![0].status == 'COMPLETE'
                  ? Stack(
                    children: [
                      ClipRRect(
                borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                context.watch<MissionProveState>().myMissionList![0].archive,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 100, // 이 값을 조절하여 scrim의 높이를 조절하세요
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.5), // 상단이 어둡게 처리됨
                                Colors.transparent,             // 점차 투명해짐
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              /// 텍스트 인증
                  : context.watch<MissionProveState>().missionWay.length > 1 &&
                  context.watch<MissionProveState>().missionWay.contains('텍스트') &&
                  context.watch<MissionProveState>().myMissionList![0].status == 'COMPLETE'
                  ? Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 60, bottom: 24, right: 32),
                    child: Text(context.watch<MissionProveState>().myMissionList![0].archive,
                    style: contentTextStyle.copyWith(color: grayScaleGrey200),),
                  )
              /// 링크 인증
                  : Padding(
                    padding: const EdgeInsets.only(top: 80.0, left: 16, right: 16, bottom: 24),
                    child: Container(
                      width: double.infinity,
                      height: 88,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: grayScaleGrey600,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 12, top: 34, bottom: 34),
                            child: Image.asset(
                              'asset/image/icon_hyperlink.png',
                              color: grayScaleGrey400,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0, top: 25.5, bottom: 4),
                                child: Text('링크 바로가기', style: contentTextStyle.copyWith(color: grayScaleGrey100),),
                              ),
                              Text(
                                context.watch<MissionProveState>().myMissionList![0].archive,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: grayScaleGrey400,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
              ),
                  )
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(top: 24, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      context.watch<MissionProveState>().myRepeatMissionTime[0][0],
                      style: bodyTextStyle.copyWith(
                        color: grayScaleGrey300,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      context.watch<MissionProveState>().myRepeatMissionTime[0][1],
                      style: bodyTextStyle.copyWith(
                        color: grayScaleGrey300,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    DropdownButton<String>(
                      underline: SizedBox.shrink(),
                      style: contentTextStyle.copyWith(color: grayScaleGrey100),
                      dropdownColor: grayScaleGrey500,
                      icon: Icon(
                        Icons.more_vert_outlined,
                        color: grayScaleGrey300,
                      ),
                      iconEnabledColor: Colors.white,
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                            child: Container(
                                padding: EdgeInsets.only(right: 8),
                                alignment: Alignment.centerRight,
                                child: Text('인증 수정하기')),
                            value: 'fix'),
                        DropdownMenuItem(
                            child: Container(
                              padding: EdgeInsets.only(right: 8),
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('다시 인증하기'),
                                  Text(
                                    '기존 인증내역이 취소돼요',
                                    style: bodyTextStyle.copyWith(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            value: 'retry'),
                      ],
                      isDense: true,
                      onChanged: (String? val) {
                        context.read<MissionProveState>().setMission(val);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
