import 'package:flutter/material.dart';
import 'package:moing_flutter/board/screen/ongoing_misson_state.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import '../component/board_repeat_mission_card.dart';
import '../component/board_single_mission_card.dart';

class OngoingMissionPage extends StatelessWidget {

  static const routeName = '/board/mission/ongoing';

  const OngoingMissionPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => OngoingMissonState(context: context)),
      ],
      builder: (context, _) {
        return const OngoingMissionPage();
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
              _Title(mainText: '반복 미션', countText: '1'),
              const SizedBox(
                height: 12.0,
              ),
              BoardRepeatMissionCard(),
              const SizedBox(
                height: 40.0,
              ),
              _Title(mainText: '한번 미션', countText: '1'),
              const SizedBox(
                height: 12.0,
              ),
              BoardSingleMissionCard(),
              const Spacer(),
              _BottomButton(),
            ],
        ),
      ),
    );
  }
}


class _Title extends StatelessWidget {
  final String mainText;
  final String countText;

  _Title({
    required this.mainText,
    required this.countText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          mainText,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: grayScaleGrey100,
          ),
        ),
        const SizedBox(
          width: 4.0,
        ),
        Text(
          countText,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: grayScaleGrey400,
          ),
        ),
      ],
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
