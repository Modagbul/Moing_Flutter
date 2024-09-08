import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/fix_group/fix_group_state.dart';
import 'package:moing_flutter/make_group/component/warning_dialog.dart';
import 'package:moing_flutter/utils/text_field/outlined_text_field.dart';
import 'package:provider/provider.dart';

class FixGroupPage extends StatelessWidget {
  static const routeName = '/group/fix';

  const FixGroupPage({super.key});

  static route(BuildContext context) {
    final int teamId = ModalRoute.of(context)?.settings.arguments as int;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FixGroupState(context: context, teamId: teamId)),
      ],
      builder: (context, _) {
        return const FixGroupPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FixGroupState>();

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
              onTap: context.read<FixGroupState>().savePressed,
              child: Text(
                '저장',
                style: buttonTextStyle.copyWith(
                  color: state.isSuccess ? Colors.white : grayScaleGrey500,
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
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 34,
                  ),
                  Text(
                    '소모임의\n기본 정보를 수정할 수 있어요',
                    style: headerTextStyle.copyWith(
                        color: grayScaleGrey100, height: 1.3),
                  ),
                  const SizedBox(
                    height: 72,
                  ),
                  OutlinedTextField(
                    maxLength: 10,
                    labelText: '소모임 이름',
                    onChanged: (value) =>
                        context.read<FixGroupState>().updateTextField(),
                    controller: context.read<FixGroupState>().nameController,
                    inputTextStyle:
                        contentTextStyle.copyWith(color: grayBlack2),
                    onClearButtonPressed:
                        context.read<FixGroupState>().clearNameTextField,
                  ),
                  const SizedBox(
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
                    controller:
                        context.read<FixGroupState>().introduceController,
                    inputTextStyle: bodyTextStyle.copyWith(color: grayBlack2),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () =>
                        context.read<FixGroupState>().imageUpload(context),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 205,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32.0),
                            child: _buildImage(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
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
                  const SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: Text(
                      '소모임의 대표 사진은 홈 화면에서의 썸네일로 적용되어요.',
                      style: bodyTextStyle.copyWith(color: grayBlack8),
                    ),
                  ),
                  const SizedBox(
                    height: 124,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (context.watch<FixGroupState>().avatarFile != null) {
      return Image.file(
        File(context.watch<FixGroupState>().avatarFile!.path),
        fit: BoxFit.cover,
      );
    } else if (context.watch<FixGroupState>().getProfileImageUrl != null &&
        !context
            .watch<FixGroupState>()
            .getProfileImageUrl!
            .startsWith('asset/')) {
      return CachedNetworkImage(
        imageUrl: context.watch<FixGroupState>().getProfileImageUrl!,
        fit: BoxFit.cover,
      );
    } else {
      return _defaultImg(context);
    }
  }

  Widget _defaultImg(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Center(
            child: SvgPicture.asset(
              'asset/icons/photo_default_img.svg',
            ),
          ),
        ),
      ],
    );
  }
}
