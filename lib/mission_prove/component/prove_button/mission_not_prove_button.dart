import 'package:flutter/material.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:moing_flutter/missions/create/skip_mission_page.dart';
import 'package:moing_flutter/utils/button/black_button.dart';
import 'package:moing_flutter/utils/button/white_button.dart';
import 'package:provider/provider.dart';

class MissionNotProveButton extends StatelessWidget {
  const MissionNotProveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Column(
        children: [
          BlackButton(
            onPressed: context.read<MissionProveState>().missionSkip,
            text: '이번 미션 건너뛰기',
            borderSide: false,
          ),
          SizedBox(height: 8),
          WhiteButton(
              onPressed: context.read<MissionProveState>().submit,
              text: '미션 인증하기'
          ),
        ],
      ),
    );
  }
}
