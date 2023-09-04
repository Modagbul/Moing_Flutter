import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              width: 335,
              height: 356,
              decoration: BoxDecoration(
                color: grayScaleGrey900,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 36.0, left: 26.0),
                    child: Column(
                      children: [
                        Row(
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
                            SizedBox(width: 9.0,),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '32시간',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w600,
                                    color: grayScaleGrey100,
                                  ),
                                ),
                                SizedBox(height: 6.0,),
                                Row(
                                  children: [
                                    Text(
                                      '#독서',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                        color: grayScaleGrey300,
                                      ),
                                    ),
                                    SizedBox(width: 4.0,),
                                    Text(
                                      '하며 함께 불태운 시간',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.0,
                                        color: grayScaleGrey400,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30.0,),
                        Row(
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
                            SizedBox(width: 2,),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.asset(
                                'asset/image/black.jpeg',
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 2,),ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.asset(
                                'asset/image/black.jpeg',
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 2,),ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.asset(
                                'asset/image/black.jpeg',
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 2,),ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.asset(
                                'asset/image/black.jpeg',
                                width: 54,
                                height: 54,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 2,),
                          ],
                        ),
                        SizedBox(height: 64.0,),
                      ],
                    ),
                  ),
                  Container(
                    width: 302,
                    height: 96,
                    decoration: BoxDecoration(
                      color: grayScaleGrey600,
                      borderRadius: BorderRadius.circular(32),
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
                                  '9',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 21,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  '모닥모닥불',
                                  style: TextStyle(
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
                                    SizedBox(width: 4.0,),
                                    Text(
                                      '9명',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: grayScaleGrey550,
                                      ),
                                    ),
                                    SizedBox(width: 12.0,),
                                    Image.asset(
                                      'asset/image/clock.png',
                                    ),
                                    SizedBox(width: 4.0,),
                                    Text(
                                      '시작 2023.04.05',
                                      style: TextStyle(
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
            SizedBox(width: 12.0,),
            Container(
              width: 335,
              height: 356,
              decoration: BoxDecoration(
                color: grayScaleGrey900,
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            SizedBox(width: 12.0,),
            Container(
              width: 335,
              height: 356,
              decoration: BoxDecoration(
                color: grayScaleGrey900,
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ],
        ),
    );
  }
}
