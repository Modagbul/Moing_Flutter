import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/create/missions_create_state.dart';
import 'package:moing_flutter/utils/text_field/outlined_text_field.dart';
import 'package:provider/provider.dart';

class MissionTitleContent extends StatelessWidget {
  const MissionTitleContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '미션 제목',
          style: context.watch<MissionCreateState>().isTitleFocused
              ? bodyTextStyle.copyWith(fontWeight: FontWeight.w500, color: coralGrey200)
          : bodyTextStyle.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 4),
        Stack(
          children: [
            TextField(
              controller: context.read<MissionCreateState>().titleController,
              focusNode: context.watch<MissionCreateState>().titleFocusNode,
              maxLength: 15,
              maxLines: 1,
              style: contentTextStyle.copyWith(color: grayBlack2),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: grayScaleGrey700,
                  contentPadding: EdgeInsets.all(16),
                  hintText: '15자 이내 제목을 입력해주세요',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: coralGrey200),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  suffixIcon: context.read<MissionCreateState>().titleController.text.length > 0
                      ? GestureDetector(
                      onTap: context.read<MissionCreateState>().clearTitleTextField,
                      child: Icon(Icons.close,color: grayBlack7))  // 아이콘이 필요한 경우
                      : null,  // 아이콘이 필요하지 않은 경우
                  hintStyle:
                      contentTextStyle.copyWith(color: grayScaleGrey550)),
            ),
            Positioned(
                right: 12,
                bottom: 0,
                child: Text(
                  '(${context.watch<MissionCreateState>().titleController.text.length}/15)',
                  style: context.watch<MissionCreateState>().titleController.text.length > 0
                      ? bodyTextStyle.copyWith(
                          fontWeight: FontWeight.w500, color: grayBlack7)
                      : bodyTextStyle.copyWith(
                          fontWeight: FontWeight.w500, color: grayScaleGrey550),
                ),
            ),
          ],
        ),
        OutlinedTextField(
          maxLength: 300,
          maxLines: 10,
          hintText: '미션에 대한 설명과 인증 규칙을 적어주세요',
          labelText: '미션 설명',
          onChanged: (value) =>
              context.read<MissionCreateState>().updateTextField(),
          controller: context.watch<MissionCreateState>().contentController,
          counterText:
              '(${context.watch<MissionCreateState>().contentController.text.length}/300)',
          inputTextStyle: contentTextStyle.copyWith(color: grayBlack2),
          // onClearButtonPressed:
          //     context.read<MissionCreateState>().clearContentTextField,
        ),
      ],
    );
  }
}
