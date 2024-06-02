import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:moing_flutter/utils/image_resize/image_resize.dart';
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
          child: CachedNetworkImage(
            imageUrl: state.everyMissionList![index].archive,
            fit: BoxFit.cover,
            width: 172,
            height: 155,
          ),
        ),
      ],
    );
  }
}
