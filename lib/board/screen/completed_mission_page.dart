import 'package:flutter/material.dart';
import 'package:moing_flutter/board/component/board_completed_mission_card.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import 'completed_mission_state.dart';

class CompletedMissionPage extends StatelessWidget {

  static const routeName = '/board/mission/completed';

  const CompletedMissionPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => CompletedMissionState(context: context)),
      ],
      builder: (context, _) {
        return const CompletedMissionPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40.0,
            ),
            BoardCompletedMissionCard(),
            const Spacer(),
            _BottomButton(),
          ],
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed: () {}, // 임시
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(
                const Size(137, 51)),
            backgroundColor:
            MaterialStateProperty.all<Color>(grayScaleGrey100),
            shape:
            MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(32.0), // borderRadius 설정
              ),
            ),
          ),
          child: const Text(
            '만들기 +',
            style: TextStyle(
              color: grayScaleGrey700,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}