import 'package:flutter/material.dart';
import 'package:moing_flutter/mission_prove/component/prove_button/mission_like_count_comment.dart';
import 'package:moing_flutter/mission_prove/mission_prove_state.dart';
import 'package:provider/provider.dart';

class MissionLikeShare extends StatelessWidget {
  const MissionLikeShare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            const SizedBox(height: 16),
            GestureDetector(
              onTap: context.read<MissionProveState>().likePressedToast,
              child: const MissionLikeOrCommentButton(),
            ),
            const SizedBox(height: 160),
          ],
        ),
      ),
    );
  }
}
