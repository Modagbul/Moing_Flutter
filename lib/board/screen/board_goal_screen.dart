import 'package:flutter/material.dart';
import 'package:moing_flutter/board/component/board_goal_bottom_sheet.dart';

class BoardGoalScreen extends StatelessWidget {
  const BoardGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom:0,
              left: 0,
              right: 0,
              child: BoardGoalBottomSheet(),
            ),
          ],
        ),
      ),
    );
  }
}
