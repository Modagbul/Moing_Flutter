import 'package:flutter/material.dart';
import 'package:moing_flutter/board/screen/board_goal_state.dart';
import 'package:moing_flutter/board/component/board_goal_bottom_sheet.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class BoardGoalScreen extends StatelessWidget {
  static const routeName = '/board/main/goal';

  const BoardGoalScreen({
    super.key,
  });

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BoardGoalState(
            context: context,
            isExpanded: false,
          ),
        ),
      ],
      builder: (context, _) {
        return const BoardGoalScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: grayScaleGrey900,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    _buildRandomMessageContainer(),
                    _buildFireImageContainer(),
                    SizedBox(height: screenHeight * 0.01),
                    _buildFireLevelContainer(screenWidth),
                    SizedBox(height: screenHeight * 0.01),
                    _buildFireLevelProgressBar(screenWidth),
                  ],
                ),
              ),
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BoardGoalBottomSheet(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRandomMessageContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: grayScaleGrey600,
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '우리 모임 따뜻하불...(랜덤 메세지 미정)',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: grayScaleWhite,
          ),
        ),
      ),
    );
  }

  Widget _buildFireImageContainer() {
    return Image.asset(
      'asset/image/icon_moing_fire_level_1.png',
      width: 180.0,
      height: 180.0,
    );
  }

  Widget _buildFireLevelContainer(double screenWidth) {
    return Container(
      width: screenWidth * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: grayScaleGrey600,
      ),
      child: Row(
        children: [
          Image.asset(
            'asset/image/icon_fire_level.png',
            width: 52.0,
            height: 52.0,
          ),
          const SizedBox(width: 10.0),
          const Expanded(
            child: Text(
              '아기불꽃',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: grayScaleWhite,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: grayScaleGrey400,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFireLevelProgressBar(double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.65,
      child: LinearPercentIndicator(
        animation: true,
        lineHeight: 30.0,
        animationDuration: 2000,
        percent: 0.7,
        barRadius: const Radius.circular(24.0),
        backgroundColor: grayScaleGrey600,
        progressColor: coralGrey500,
      ),
    );
  }
}
