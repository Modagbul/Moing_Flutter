import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text_field.dart';
import 'package:moing_flutter/make_group/component/warning_dialog.dart';
import 'package:moing_flutter/post/post_create_state.dart';
import 'package:moing_flutter/utils/text_field/outlined_text_field.dart';
import 'package:provider/provider.dart';

class PostCreatePage extends StatelessWidget {
  static const routeName = '/post/create';

  const PostCreatePage({Key? key}) : super(key: key);

  static route(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    final int teamId = arguments as int;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => PostCreateState(context: context, teamId: teamId)),
      ],
      builder: (context, _) {
        return const PostCreatePage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const header = '게시글 제목과 내용을 입력해 주세요.';

    return Scaffold(
      backgroundColor: grayScaleGrey900,
      appBar: _renderAppBar(context),
      body: GestureDetector(
        onTap: () {

          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32.0),
                  _renderHeader(header: header),
                  const SizedBox(height: 52.0),
                  const _PostInfoTextFields(),
                  const SizedBox(height: 85.0),
                  const _NoticeCheckContainer(),
                  const SizedBox(height: 32.0),
                  const _PostCreateButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _renderAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: grayScaleGrey900,
      elevation: 0.0,
      title: const Text('게시글 작성하기'),
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  WarningDialog(
                    title: '게시글 작성을 멈추시겠어요?',
                    content: '나가시면 입력하신 내용을 잃게 됩니다',
                    onConfirm: () {
                      Navigator.of(context).pop(true);
                    },
                    onCanceled: () {
                      Navigator.of(context).popUntil(
                          (route) => route.settings.name == '/post/main');
                    },
                    leftText: '나가기',
                    rightText: '계속 진행하기',
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  _renderHeader({required String header}) {
    return Text(
      header,
      style: const TextStyle(
        color: grayScaleGrey100,
        fontSize: 21.0,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
    );
  }
}

class _PostInfoTextFields extends StatelessWidget {
  const _PostInfoTextFields();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedTextField(
          maxLength: 15,
          labelText: '제목',
          hintText: '15자 이내의 제목을 적어주세요',
          counterText:
              '(${context.watch<PostCreateState>().titleController.text.length}/15)',
          onChanged: (value) =>
              context.read<PostCreateState>().updateTextField(),
          controller: context.read<PostCreateState>().titleController,
          onClearButtonPressed: () =>
              context.read<PostCreateState>().clearTitleTextField(),
          inputTextStyle: inputTextFieldStyle.copyWith(fontSize: 16.0),
        ),
        const SizedBox(height: 40.0),
        OutlinedTextField(
          maxLength: 300,
          maxLines: 10,
          labelText: '내용',
          hintText: '공지할 내용을 적어주세요',
          counterText:
              '(${context.watch<PostCreateState>().contentController.text.length}/300)',
          onChanged: (value) =>
              context.read<PostCreateState>().updateTextField(),
          controller: context.read<PostCreateState>().contentController,
          inputTextStyle: inputTextFieldStyle.copyWith(fontSize: 16.0),
        ),
      ],
    );
  }
}

class _NoticeCheckContainer extends StatelessWidget {
  const _NoticeCheckContainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: grayScaleGrey600,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Image.asset(
              context.watch<PostCreateState>().isCheckedNotice
                  ? 'asset/image/icon_check_box_active.png'
                  : 'asset/image/icon_check_box_default.png',
              width: 24.0,
              height: 24.0,
            ),
            onPressed: context.read<PostCreateState>().toggleCheckedNotice,
          ),
          const Text(
            '공지사항으로 변경하기',
            style: TextStyle(
              color: grayScaleGrey100,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}

class _PostCreateButton extends StatelessWidget {
  const _PostCreateButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: context.watch<PostCreateState>().isButtonEnabled
          ? context.read<PostCreateState>().requestCreatePost
          : null,
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
      child: const Text('업로드 하기'),
    );
  }
}
