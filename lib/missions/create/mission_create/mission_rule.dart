import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/create/missions_create_state.dart';
import 'package:moing_flutter/utils/text_field/outlined_text_field.dart';
import 'package:provider/provider.dart';

class MissionRule extends StatelessWidget {
  const MissionRule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 45),
        OutlinedTextField(
          maxLength: 300,
          maxLines: 10,
          hintText: '모임원들에게 미션을 인증할 수 있는 방법을 알려주세요',
          labelText: '미션 내용',
          onChanged: (value) =>
              context.read<MissionCreateState>().updateTextField(),
          controller: context.read<MissionCreateState>().contentController,
          counterText:
          '(${context.watch<MissionCreateState>().contentController.text.length}/300)',
          inputTextStyle: contentTextStyle.copyWith(color: grayBlack2),
          onClearButtonPressed:
          context.read<MissionCreateState>().clearContentTextField,
        ),
      ],
    );
  }
}
