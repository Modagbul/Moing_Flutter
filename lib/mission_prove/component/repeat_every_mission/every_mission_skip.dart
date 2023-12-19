import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class EveryMissionSkip extends StatelessWidget {
  final int index;
  const EveryMissionSkip({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var watchState = context.watch<MissionProveState>();

    return Column(
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
              SizedBox(height: 56),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  watchState.everyMissionList![index].archive,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: bodyTextStyle.copyWith(
                      color: grayScaleGrey200, fontWeight: FontWeight.w500),
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
      ],
    );
  }
}
