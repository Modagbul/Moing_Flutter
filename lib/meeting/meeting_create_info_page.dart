import 'package:flutter/material.dart';
import 'package:moing_flutter/const/style/elevated_button.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/const/style/text_field.dart';
import 'package:moing_flutter/meeting/meeting_create_info_state.dart';
import 'package:provider/provider.dart';

import '../components/outlined_text_field.dart';

class MeetingCreateInfoPage extends StatelessWidget {
  static const routeName = '/meeting/create/info';

  const MeetingCreateInfoPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => MeetingCreateInfoState(context: context)),
      ],
      builder: (context, _) {
        return const MeetingCreateInfoPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                _Title(),
                SizedBox(height: 40.0),
                _InfoTextFields(),
                _NavButtons(),
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
    return Column(
      children: [
        OutlinedTextField(
          maxLength: 10,
          labelText: '소모임 이름',
          hintText: '최대 10자',
          onChanged: (value) =>
              context.read<MeetingCreateInfoState>().updateTextField(),
          controller: context.read<MeetingCreateInfoState>().nameController,
          onClearButtonPressed: () =>
              context.read<MeetingCreateInfoState>().clearNameTextField(),
          inputTextStyle: inputTextFieldStyle.copyWith(fontSize: 16.0),
        ),
        OutlinedTextField(
          maxLength: 300,
          maxLines: 10,
          labelText: '소모임을 소개해주세요',
          counterText:
              '(${context.watch<MeetingCreateInfoState>().introduceController.text.length}/300)',
          hintText: '활동 목적과 계획을 포함해 작성해주세요',
          onChanged: (value) =>
              context.read<MeetingCreateInfoState>().updateTextField(),
          controller:
              context.read<MeetingCreateInfoState>().introduceController,
          onClearButtonPressed: () =>
              context.read<MeetingCreateInfoState>().clearIntroduceTextField(),
        ),
        OutlinedTextField(
          maxLength: 100,
          maxLines: 10,
          labelText: '모임장의 각오 한마디',
          counterText:
              '(${context.watch<MeetingCreateInfoState>().resolutionController.text.length}/100)',
          hintText: '자유롭게 작성해주세요',
          onChanged: (value) =>
              context.read<MeetingCreateInfoState>().updateTextField(),
          controller:
              context.read<MeetingCreateInfoState>().resolutionController,
          onClearButtonPressed: () =>
              context.read<MeetingCreateInfoState>().clearResolutionTextField(),
        ),
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
            style: defaultButtonStyle,
            onPressed: () {},
            child: const Text('이전으로'),
          ),
        ),
        const SizedBox(width: 4.0),
        Expanded(
          child: ElevatedButton(
            style: activedButtonStyle,
            onPressed: () {},
            child: const Text('다음으로'),
          ),
        ),
      ],
    );
  }
}
