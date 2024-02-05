import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/home/home_screen_state.dart';
import 'package:moing_flutter/model/response/get_team_mission_photo_list_response.dart';
import 'package:provider/provider.dart';
import 'package:speech_balloon/speech_balloon.dart';

import '../../model/response/group_team_response.dart';

class HomeCardScroll extends StatelessWidget {
  const HomeCardScroll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TeamMissionPhotoData> teamMissionPhotoList =
        context.watch<HomeScreenState>().teamMissionPhotoList;
    List<TeamBlock> teamList = context.watch<HomeScreenState>().teamList;
    PageController pageController = PageController(
      viewportFraction: 0.9,
    );

    return SizedBox(
      width: double.infinity,
      height: 356,
      child: PageView.builder(
          controller: pageController,
          pageSnapping: true,
          scrollDirection: Axis.horizontal,
          physics: const PageScrollPhysics(),
          itemCount: context.watch<HomeScreenState>().teamList.length,
          itemBuilder: (context, index) {
            TeamBlock team = context.watch<HomeScreenState>().teamList[index];

            TeamMissionPhotoData? photoData = teamMissionPhotoList.firstWhere(
              (element) => element.teamId == team.teamId,
              orElse: () => TeamMissionPhotoData(teamId: 0, photo: []),
            );

            return GestureDetector(
              onTap: () {
                context.read<HomeScreenState>().teamPressed(team.teamId);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  width: double.infinity,
                  height: 356,
                  decoration: BoxDecoration(
                    color: grayScaleGrey900,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 36.0,
                      right: 16.0,
                      left: 16.0,
                      bottom: 20.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipOval(
                              child: teamList[index].profileImgUrl != null &&
                                      teamList[index].profileImgUrl.isNotEmpty
                                  ? Image.network(
                                      teamList[index].profileImgUrl,
                                      width: 52.0,
                                      height: 52.0,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return CircularProgressIndicator();
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
                                        return SvgPicture.asset(
                                          'asset/icons/group_basic_image.svg',
                                          width: 52.0,
                                          height: 52.0,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : SvgPicture.asset(
                                      'asset/icons/group_basic_image.svg',
                                      width: 52.0,
                                      height: 52.0,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(width: 9.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${team.duration.toString()}일',
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w600,
                                    color: grayScaleGrey100,
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Row(
                                  children: [
                                    Text(
                                      '#${context.read<HomeScreenState>().convertCategoryName(category: team.category)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.0,
                                        color: grayScaleGrey300,
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    const Text(
                                      '하며 함께 불태운 시간',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.0,
                                        color: grayScaleGrey400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        photoData != null
                            ? photoData.photo.isNotEmpty
                                ? SizedBox(
                                    height: 54,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: photoData.photo.length > 5
                                          ? 5
                                          : photoData.photo.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              child: Image.network(
                                                photoData.photo[index],
                                                fit: BoxFit.cover,
                                                width: 54,
                                                height: 54,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  } else {
                                                    return const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  grayScaleGrey500),
                                                          strokeWidth: 2.0,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                : const SizedBox(height: 54)
                            : const SizedBox(height: 54),
                        //위치 좌측으로, 1초 이후 사라지게
                        (context.watch<HomeScreenState>().newCreated == "new" &&
                                index == 0)
                            ? const Column(
                                children: [
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  SpeechBalloon(
                                    color: coralGrey500,
                                    width: 180,
                                    height: 34,
                                    borderRadius: 24,
                                    nipLocation: NipLocation.bottom,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 8.0,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '새 모임이 추가되었어요',
                                          style: TextStyle(
                                            color: grayScaleWhite,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                ],
                              )
                            : const SizedBox(
                                height: 64.0,
                              ),
                        Container(
                          height: 96,
                          decoration: BoxDecoration(
                            color: grayScaleGrey600,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: (context
                                              .watch<HomeScreenState>()
                                              .newCreated ==
                                          "new" &&
                                      index == 0)
                                  ? coralGrey500
                                  : Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 21.0, top: 19),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'asset/icons/home_card_fire.svg',
                                      width: 45,
                                      height: 56,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        team.levelOfFire.toString(),
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        team.teamName,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                          color: grayScaleGrey100,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'asset/icons/home_card_user.svg',
                                            width: 14,
                                            height: 14,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            '${team.numOfMember.toString()}명',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.0,
                                              color: grayScaleGrey550,
                                            ),
                                          ),
                                          const SizedBox(width: 12.0),
                                          SvgPicture.asset(
                                            'asset/icons/mission_single_clock.svg',
                                            width: 14,
                                            height: 14,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            '시작 ${team.startDate}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.0,
                                              color: grayScaleGrey550,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
