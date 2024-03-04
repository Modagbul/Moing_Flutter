import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class MissionContentAndRule extends StatelessWidget {
  const MissionContentAndRule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MissionProveState>();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => context.read<MissionProveState>().showModal('content'),
            child: Container(
              height: 40,
              color: Colors.transparent,
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_outlined,
                  color: coralGrey500,
                  size: 24,),
                  const SizedBox(width: 8),
                  Text('미션 설명',
                  style: bodyTextStyle.copyWith(color: grayScaleGrey200)
                  ),
                  const Spacer(),
                  const Icon(Icons.keyboard_arrow_down_outlined,
                  color: Colors.white,
                  size: 24,
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
          SizedBox(height: state.isRepeated ? 8 : 12),
        ],
      );
  }
}
