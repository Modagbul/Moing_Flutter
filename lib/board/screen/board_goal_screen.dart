import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:moing_flutter/board/board_main_state.dart';
import 'package:moing_flutter/board/screen/board_goal_state.dart';
import 'package:moing_flutter/board/component/board_goal_bottom_sheet.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/utils/fire_level/fire_level.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class BoardGoalScreen extends StatelessWidget {
  static const routeName = '/board/main/goal';

  const BoardGoalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final int level =
        context.watch<BoardMainState>().teamFireLevelData?.level ?? 0;
    final int score =
        context.watch<BoardMainState>().teamFireLevelData?.score ?? 0;
    final String category =
        (context.watch<BoardMainState>().teamInfo?.category ?? '');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BoardGoalState(
            context: context,
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: grayScaleGrey900,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.01),
                        _buildRandomMessageContainer(
                          level: level,
                          category: category,
                        ),
                        _buildFireImageContainer(
                          level: level,
                          category: category,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        _buildFireLevelContainer(
                          screenWidth: screenWidth,
                          level: level,
                          context: context,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        _buildFireLevelProgressBar(
                          screenWidth: screenWidth,
                          score: score,
                        ),
                      ],
                    ),
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
      ),
    );
  }

  Widget _buildRandomMessageContainer({
    required int level,
    required String category,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: grayScaleGrey600,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          FireLevel.convertLevelToMessage(
            level: level,
            category: category,
          ),
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: grayScaleWhite,
          ),
        ),
      ),
    );
  }

  Widget _buildFireImageContainer({
    required int level,
    required String category,
  }) {
    return Lottie.asset(
      FireLevel.convertLevelToGraphicPath(
        level: level,
        category: category,
      ),
      width: 180.0,
      height: 180.0,
    );
  }

  Widget _buildFireLevelContainer({
    required double screenWidth,
    required int level,
    required BuildContext context,
  }) {
    return Container(
      width: screenWidth * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: grayScaleGrey600,
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'asset/image/icon_fire_level.png',
                width: 52.0,
                height: 52.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  level.toString(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              FireLevel.convertLevelToName(level: level),
              style: const TextStyle(
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
            onPressed: context.read<BoardMainState>().getTeamFireLevel,
          ),
        ],
      ),
    );
  }

  Widget _buildFireLevelProgressBar({
    required double screenWidth,
    required int score,
  }) {
    return SizedBox(
      width: screenWidth * 0.65,
      child: LinearPercentIndicator(
        animation: true,
        lineHeight: 30.0,
        animationDuration: 2000,
        percent: score * 0.01,
        barRadius: const Radius.circular(24.0),
        backgroundColor: grayScaleGrey600,
        progressColor: coralGrey500,
        center: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Text(
              'Level up!',
              style: TextStyle(
                color: grayScaleGrey550,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
