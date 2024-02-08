import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/login/sign_up/sign_up_state.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  static const routeName = '/sign/up';

  const SignUpPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpState(context: context)),
      ],
      builder: (context, _) {
        return const SignUpPage();
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 68.0),
                      _Title(),
                      SizedBox(height: 88.0),
                      _NicknameTextField(),
                    ],
                  ),
                ),
              ),
              _NicknameCheckButton(),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

// 사용자 닉네임 입력 안내
class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: grayScaleGrey600,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Text(
            '처음 오셨군요, 반가워요',
            style: TextStyle(
              color: grayScaleGrey550,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        const Text(
          '사용할 닉네임을 입력해주세요',
          style: TextStyle(
            color: grayScaleGrey200,
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// 닉네임 입력 텍스트 필드
class _NicknameTextField extends StatelessWidget {
  const _NicknameTextField();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          autofocus: true,
          maxLength: 10,
          style: const TextStyle(
            color: grayScaleGrey100,
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            counterStyle: const TextStyle(
              height: 0.2,
            ),
            suffixIcon:
                context.watch<SignUpState>().nicknameController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        color: grayScaleGrey550,
                        onPressed: () =>
                            context.read<SignUpState>().clearNickname(),
                      )
                    : null,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.watch<SignUpState>().nicknameColor,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: context.watch<SignUpState>().nicknameColor),
            ),
          ),
          controller: context.read<SignUpState>().nicknameController,
          onChanged: (_) => context.read<SignUpState>().updateNickname(),
        ),
        Text(
          context.watch<SignUpState>().nicknameInfo,
          style: TextStyle(
            color: context.watch<SignUpState>().nicknameColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

// 닉네임 중복 검사 버튼
class _NicknameCheckButton extends StatelessWidget {
  const _NicknameCheckButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: grayScaleWhite,
        foregroundColor: grayScaleGrey900,
        disabledBackgroundColor: grayScaleGrey700,
        disabledForegroundColor: grayScaleGrey500,
        textStyle: const TextStyle(
          color: grayScaleGrey900,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onPressed: context.watch<SignUpState>().isNicknameValid()
          ? () {
              context.read<SignUpState>().checkNicknameOverlapped(
                    context.read<SignUpState>().nicknameController.text,
                  );
            }
          : null,
      child: Text(context.watch<SignUpState>().nicknameCheckButtonText),
    );
  }
}
