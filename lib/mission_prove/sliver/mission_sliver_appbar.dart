import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class MissionSliverAppBar extends StatelessWidget {
  const MissionSliverAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle ts = contentTextStyle.copyWith(
      color: grayScaleGrey300,
      fontWeight: FontWeight.w600,
    );
    return SliverAppBar(
      pinned: true,
      title: Container(
        color: grayBackground,
        height: 56,
        child: Row(
          children: [
            // Image.asset(
            //   'asset/image/arrow_left.png',
            // ),
            Spacer(),
            GestureDetector(
                onTap: context.read<MissionProveState>().showMissionRuleBottomModal,
                child: Text(
                  '미션내용',
                  style: ts,
                )),
            SizedBox(width: 32),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                  onTap: () {
                    print('더보기 클릭');
                  },
                  child: Text(
                    '더보기',
                    style: ts,
                  )),
            ),
          ],
        ),
      ),
      backgroundColor: grayBackground,
    );
  }
}
