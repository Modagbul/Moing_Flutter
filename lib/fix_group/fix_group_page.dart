import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/fix_group/fix_group_state.dart';
import 'package:moing_flutter/make_group/component/warning_dialog.dart';
import 'package:moing_flutter/utils/text_field/outlined_text_field.dart';
import 'package:provider/provider.dart';

class FixGroupPage extends StatelessWidget {
  static const routeName = '/group/fix';

  static route(BuildContext context) {
    final int teamId = ModalRoute.of(context)?.settings.arguments as int;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FixGroupState(context: context, teamId: teamId)),
      ],
      builder: (context, _) {
        return FixGroupPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayScaleGrey900,
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 10),
            child: GestureDetector(
              /// 목표보드로 이동
              onTap: () {},
              child: Text(
                '저장',
                style: buttonTextStyle.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    WarningDialog(
                      title: '소모임 정보수정을 멈추시겠어요?',
                      content: '나가시면 입력하신 내용을 잃게 됩니다',
                      onConfirm: () {
                        Navigator.of(context).pop();
                      },
                      onCanceled: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      leftText: '나가기',
                      rightText: '계속 진행하기',
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 34,
                ),
                Text(
                  '소모임의\n기본 정보를 수정할 수 있어요',
                  style: headerTextStyle.copyWith(
                      color: grayScaleGrey100, height: 1.3),
                ),
                SizedBox(
                  height: 72,
                ),
                OutlinedTextField(
                  maxLength: 10,
                  labelText: '소모임 이름',
                  onChanged: (value) =>
                      context.read<FixGroupState>().updateTextField(),
                  controller: context.read<FixGroupState>().nameController,
                  inputTextStyle: contentTextStyle.copyWith(color: grayBlack2),
                  onClearButtonPressed:
                      context.read<FixGroupState>().clearNameTextField,
                ),
                SizedBox(
                  height: 48,
                ),
                OutlinedTextField(
                  maxLength: 300,
                  maxLines: 10,
                  labelText: '소모임을 소개해주세요',
                  counterText:
                      '(${context.watch<FixGroupState>().introduceController.text.length}/300)',
                  onChanged: (value) =>
                      context.read<FixGroupState>().updateTextField(),
                  controller: context.read<FixGroupState>().introduceController,
                  inputTextStyle: bodyTextStyle.copyWith(color: grayBlack2),
                  onClearButtonPressed:
                      context.read<FixGroupState>().clearIntroduceTextField,
                ),
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () =>
                      context.read<FixGroupState>().imageUpload(context),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.0),
                          color: grayScaleGrey700,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 255,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32.0),
                          child: (context.watch<FixGroupState>().avatarFile ==
                                      null && context.watch<FixGroupState>().profileImageUrl != null)
                              ? Image.network(
                                  context
                                      .watch<FixGroupState>()
                                      .profileImageUrl!,
                                  fit: BoxFit.cover)
                              : Image.file(
                                  File(context
                                      .watch<FixGroupState>()
                                      .avatarFile!
                                      .path),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: grayScaleGrey700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48),
                        )),
                    onPressed: () =>
                        context.read<FixGroupState>().imageUpload(context),
                    child: Text(
                      '다시 고르기',
                      style: contentTextStyle.copyWith(
                        color: grayScaleGrey100,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  '소모임의 대표 사진은 홈 화면에서의 썸네일로 적용되어요.',
                  style: bodyTextStyle.copyWith(color: grayBlack8),
                ),
                SizedBox(
                  height: 124,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
