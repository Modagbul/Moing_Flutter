import 'package:flutter/material.dart';
import 'package:moing_flutter/missions/component/skip_dialog.dart';
import 'package:moing_flutter/missions/create/skip_mission_state.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import '../../utils/text_field/outlined_text_field.dart';
import 'link_auth_state.dart';

class SkipMissionPage extends StatelessWidget {
  static const routeName = '/missions/create/skip';

  const SkipMissionPage({super.key});

  static route(BuildContext context) {
    final Map<String, dynamic> data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final int teamId = data['teamId'] as int;
    final int missionId = data['missionId'] as int;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SkipMissionState(context: context, teamId: teamId, missionId: missionId),
          lazy: false,
        ),
      ],
      builder: (context, _) {
        return const SkipMissionPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayScaleGrey900,
      appBar: renderAppBar(context: context, title: '미션 건너뛰기'),
      body: const Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 34.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '이번 미션을 건너뛰시겠어요?\n사유를 작성해주세요',
                style: TextStyle(
                  color: grayScaleGrey100,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 52.0),
            _InfoTextFields(),
            Spacer(),
            _NextBtn(),
            SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget renderAppBar({
    required BuildContext context,
    required String title,
  }) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(title),
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.close), // 뒤로 가기 아이콘
        onPressed: () {
          Navigator.of(context).pop(); // 뒤로 가기 버튼을 누르면 이전 화면으로 돌아갑니다.
        },
      ),
    );
  }
}

class _InfoTextFields extends StatelessWidget {
  const _InfoTextFields();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedTextField(
          maxLength: 1000,
          maxLines: 10,
          labelText: '사유 작성하기',
          hintText:
              '이번 미션을 건너뛰는 적절한 사유를 알려주세요. 작성한 사유는 모든 모임원들에게 공개되니 신중하게 작성해주세요!',
          counterText:
              '(${context.watch<SkipMissionState>().textController.text.length}/50)',
          onChanged: (value) =>
              context.read<SkipMissionState>().updateTextField(),
          controller: context.read<SkipMissionState>().textController,
          onClearButtonPressed: () =>
              context.read<SkipMissionState>().clearTextField(),
        ),
      ],
    );
  }
}

class _NextBtn extends StatelessWidget {
  const _NextBtn({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryState = Provider.of<SkipMissionState>(context);

    return Container(
      width: 353,
      height: 62,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: categoryState.getNextButtonColor(),
          disabledBackgroundColor: grayScaleGrey700,
          disabledForegroundColor: grayScaleGrey500,
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onPressed: categoryState.submit,
        child: Text(
          '사유작성 완료하기',
          style: TextStyle(
            color: categoryState.getNextButtonTextColor(),
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
