import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../const/color/colors.dart';
import '../../utils/text_field/outlined_text_field.dart';
import 'link_auth_state.dart';

class LinkAuthPage extends StatelessWidget {
  static const routeName = '/missions/create/link';

  const LinkAuthPage({super.key});

  static route(BuildContext context) {
    final Map<String, dynamic> data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final int teamId = data['teamId'] as int;
    final int missionId = data['missionId'] as int;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LinkAuthState(
              context: context, teamId: teamId, missionId: missionId),
          lazy: false,
        ),
      ],
      builder: (context, _) {
        return const LinkAuthPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayScaleGrey900,
      appBar: renderAppBar(context: context, title: '링크로 인증하기'),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 34.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '링크를 첨부하여\n미션을 인증해주세요!',
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
          maxLines: 1,
          labelText: '미션 인증글 작성',
          hintText: '미션을 인증할 수 있는 링크를 첨부해주세요.',
          onChanged: (value) => context.read<LinkAuthState>().updateTextField(),
          controller: context.read<LinkAuthState>().textController,
          onClearButtonPressed: () =>
              context.read<LinkAuthState>().clearTextField(),
        ),
      ],
    );
  }
}

class _NextBtn extends StatelessWidget {
  const _NextBtn();

  @override
  Widget build(BuildContext context) {
    final categoryState = Provider.of<LinkAuthState>(context);

    return SizedBox(
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
                categoryState.submit();
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
