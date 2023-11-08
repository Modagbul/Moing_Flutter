import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class SingleMyMissionNotProved extends StatelessWidget {
  const SingleMyMissionNotProved({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: grayScaleGrey700,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
              child: Text(
                context.watch<MissionProveState>().nobodyText,
                style: contentTextStyle.copyWith(height: 1.4),
                textAlign: TextAlign.center,
              )),
        ),
      ),
    );
  }
}
