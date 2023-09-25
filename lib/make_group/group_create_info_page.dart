import 'package:flutter/material.dart';
import 'package:moing_flutter/const/style/elevated_button.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/const/style/text_field.dart';
import 'package:moing_flutter/make_group/group_create_info_state.dart';
import 'package:provider/provider.dart';

import '../utils/text_field/outlined_text_field.dart';

class GroupCreateInfoPage extends StatelessWidget {
  static const routeName = '/meeting/create/info';

  const GroupCreateInfoPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => GroupCreateInfoState(context: context)),
      ],
      builder: (context, _) {
        return const GroupCreateInfoPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const _Title(),
                SizedBox(height: screenHeight * 0.04),
                const _InfoTextFields(),
                const _NavButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '어떤 소모임을 만드시나요?',
          style: headerTextStyle,
        ),
        SizedBox(height: 12.0),
        Text(
          '소모임의 기본 정보를 작성해주세요',
          style: bodyTextStyle,
        ),
      ],
    );
  }
}

class _InfoTextFields extends StatelessWidget {
  const _InfoTextFields();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedTextField(
          maxLength: 10,
          labelText: '소모임 이름',
          hintText: '최대 10자',
          onChanged: (value) =>
              context.read<GroupCreateInfoState>().updateTextField(),
          controller: context.read<GroupCreateInfoState>().nameController,
          onClearButtonPressed: () =>
              context.read<GroupCreateInfoState>().clearNameTextField(),
          inputTextStyle: inputTextFieldStyle.copyWith(fontSize: 16.0),
        ),
        SizedBox(height: screenHeight * 0.04),
        OutlinedTextField(
          maxLength: 300,
          maxLines: 10,
          labelText: '소모임을 소개해주세요',
          counterText:
              '(${context.watch<GroupCreateInfoState>().introduceController.text.length}/300)',
          hintText: '활동 목적과 계획을 포함해 작성해주세요',
          onChanged: (value) =>
              context.read<GroupCreateInfoState>().updateTextField(),
          controller: context.read<GroupCreateInfoState>().introduceController,
          onClearButtonPressed: () =>
              context.read<GroupCreateInfoState>().clearIntroduceTextField(),
        ),
        SizedBox(height: screenHeight * 0.04),
        OutlinedTextField(
          maxLength: 100,
          maxLines: 10,
          labelText: '모임장의 각오 한마디',
          counterText:
              '(${context.watch<GroupCreateInfoState>().resolutionController.text.length}/100)',
          hintText: '자유롭게 작성해주세요',
          onChanged: (value) =>
              context.read<GroupCreateInfoState>().updateTextField(),
          controller: context.read<GroupCreateInfoState>().resolutionController,
          onClearButtonPressed: () =>
              context.read<GroupCreateInfoState>().clearResolutionTextField(),
        ),
        SizedBox(height: screenHeight * 0.04),
      ],
    );
  }
}

class _NavButtons extends StatelessWidget {
  const _NavButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            style: darkButtonStyle,
            onPressed: () {},
            child: const Text('이전으로'),
          ),
        ),
        const SizedBox(width: 4.0),
        Expanded(
          child: ElevatedButton(
            style: brightButtonStyle,
            onPressed: context.read<GroupCreateInfoState>().nextPressed,
            child: const Text('다음으로'),
          ),
        ),
      ],
    );
  }
}