import 'package:flutter/material.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class EveryMissionPhoto extends StatelessWidget {
  final int index;
  const EveryMissionPhoto({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MissionProveState>();
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            state.everyMissionList![index].archive,
            fit: BoxFit.cover,
            width: 172,
            height: 155,
          ),
        ),
      ],
    );
  }
}
