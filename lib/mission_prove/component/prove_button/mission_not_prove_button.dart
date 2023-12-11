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
      child: WhiteButton(
          onPressed: () => context.read<MissionProveState>().showModal('mission'),
          text: '미션 인증하기'),
    );
  }
}
