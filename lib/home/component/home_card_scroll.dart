import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/home/home_screen_state.dart';
import 'package:provider/provider.dart';
import 'package:speech_balloon/speech_balloon.dart';

import '../../model/response/group_team_response.dart';

class HomeCardScroll extends StatelessWidget {
  const HomeCardScroll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 356,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const PageScrollPhysics(),
          itemCount: context.watch<HomeScreenState>().teamList.length,
          itemBuilder: (context, index) {
            TeamBlock team = context.watch<HomeScreenState>().teamList[index];

            log(context.read<HomeScreenState>().newCreated ?? 'sdd');
            if (context.watch<HomeScreenState>().newCreated == "new" &&
                index == 0 &&
                context.read<HomeScreenState>().onlyOnce) {
              context.read<HomeScreenState>().showNewAddedGroup();
            }

            return GestureDetector(
              onTap: () {
                context.read<HomeScreenState>().teamPressed(team.teamId);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  width: 334,
                  height: 356,
                  decoration: BoxDecoration(
                    color: grayScaleGrey900,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 26.0, top: 36),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 52.0,
                                  height: 52.0,
                                  decoration: BoxDecoration(
                                    color: grayScaleGrey500,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                Image.asset(
                                  'asset/image/category_book.png',
                                  width: 24.0,
                                  height: 24.0,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 9.0,
                            ),
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
                                const SizedBox(
                                  height: 6.0,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '#${team.category}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                        color: grayScaleGrey300,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    const Text(
                                      '하며 함께 불태운 시간',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.0,
                                        color: grayScaleGrey400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// 사진 받아오는 클래스 따로 구현하여 생성할 것
                      Padding(
                        padding: const EdgeInsets.only(left: 26.0, top: 30),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.asset(
                                'asset/image/black.jpeg',
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.asset(
                                'asset/image/black.jpeg',
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.asset(
                                'asset/image/black.jpeg',
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.asset(
                                'asset/image/black.jpeg',
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.asset(
                                'asset/image/black.jpeg',
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                          ],
                        ),
                      ),
                      //위치 좌측으로, 1초 이후 사라지게
                      (context.watch<HomeScreenState>().showNewExpression &&
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
                        width: 302,
                        height: 96,
                        decoration: BoxDecoration(
                          color: grayScaleGrey600,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: (context
                                        .watch<HomeScreenState>()
                                        .showNewExpression &&
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
                                  Image.asset(
                                    'asset/image/fire.png',
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
                              const SizedBox(
                                width: 21,
                              ),
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
                                        Image.asset(
                                          'asset/image/user.png',
                                        ),
                                        const SizedBox(
                                          width: 4.0,
                                        ),
                                        Text(
                                          '${team.numOfMember.toString()}명',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: grayScaleGrey550,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12.0,
                                        ),
                                        Image.asset(
                                          'asset/image/clock.png',
                                        ),
                                        const SizedBox(
                                          width: 4.0,
                                        ),
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
            );
          }),
    );
  }
}
