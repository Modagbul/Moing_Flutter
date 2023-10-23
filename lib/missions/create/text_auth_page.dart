import 'package:flutter/material.dart';
import 'package:moing_flutter/missions/create/text_auth_state.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import '../../utils/text_field/outlined_text_field.dart';

class TextAuthPage extends StatelessWidget {
  static const routeName = '/missions/create/text';

  const TextAuthPage({super.key});

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TextAuthState(context: context),
          lazy: false,
        ),
      ],
      builder: (context, _) {
        return const TextAuthPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: renderAppBar(context: context, title: '텍스트로 인증하기'),
      body: const Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 34.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '인증글을 작성하여\n미션을 인증해주세요!',
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
          labelText: '미션 인증글 작성',
          counterText:
              '(${context.watch<TextAuthState>().textController.text.length}/1000)',
          hintText: '텍스트를 입력하여 미션을 완료하세요.',
          onChanged: (value) => context.read<TextAuthState>().updateTextField(),
          controller: context.read<TextAuthState>().textController,
          onClearButtonPressed: () =>
              context.read<TextAuthState>().clearTextField(),
        ),
      ],
    );
  }
}


class _NextBtn extends StatelessWidget {
  const _NextBtn({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryState = Provider.of<TextAuthState>(context);

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
        onPressed: categoryState.isCategorySelected()
            ? () {
          // 임시로 **
          // categoryState.moveInfoPage();
        }
            : null, // 카테고리가 선택되지 않았다면 버튼은 비활성화 상태가 되어야 함
        child: Text(
          '인증하기',
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