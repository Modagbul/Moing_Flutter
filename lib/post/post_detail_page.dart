import 'package:flutter/material.dart';
import 'package:moing_flutter/post/post_detail_state.dart';
import 'package:provider/provider.dart';

import '../const/color/colors.dart';

class PostDetailPage extends StatelessWidget {
  static const routeName = '/post/detail';

  const PostDetailPage({Key? key}) : super(key: key);

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => PostDetailState(context: context)),
      ],
      builder: (context, _) {
        return const PostDetailPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const title = '4월에 같이 읽을 책 추천 댓글로 남기기';
    const nickName = '뮹뮹';
    const dateCreated = '03/23 23:32';
    const content =
        '여러분, 벌써 4월이 찾아왔어요 ..\n이번 달에 읽을 책을 같이 정해봅시다! 댓글로 한 권씩 책 추천 해주세요!\n저는 ‘스즈메의 문단속\'에 한 표 던지겠습니다!\n 하하저는 ‘스즈메의 문단속\'에 한 표 던지겠습니다!\n 하하저는 ‘스즈메의 문단속\'에 한 표 던지겠습니다! 하하';
    return Scaffold(
      backgroundColor: grayScaleGrey900,
      appBar: renderAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 26.0),
                        _renderNoticeTag(),
                        const SizedBox(height: 12.0),
                        const Text(
                          title,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: grayScaleGrey300,
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: [
                              Container(
                                width: 20.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  color: grayScaleGrey500,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              const Text(
                                nickName,
                                style: TextStyle(
                                  color: grayScaleGrey400,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Image.asset(
                                'asset/image/icon_crown.png',
                                width: 14.0,
                                height: 14.0,
                              ),
                              const Spacer(),
                              const Text(
                                dateCreated,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: grayBlack8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        const Text(
                          content,
                          style: TextStyle(
                            color: grayBlack3,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 40.0),
                      ],
                    ),
                  ),
                  Container(
                    height: 8.0,
                    decoration: const BoxDecoration(color: grayScaleGrey600),
                  ),
                  const SingleChildScrollView(
                    child: Text('dd'),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: grayScaleGrey700,
                child: const Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: _CommentsInputWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderNoticeTag() {
    return Row(
      children: [
        Image.asset(
          'asset/image/icon_solar_pin_bold.png',
          width: 20.0,
          height: 20.0,
        ),
        const SizedBox(width: 4.0),
        const Text(
          '공지사항',
          style: TextStyle(
            color: coralGrey500,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  PreferredSizeWidget renderAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: grayScaleGrey900,
      elevation: 0.0,
      title: const Text('게시글'),
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _CommentsInputWidget extends StatelessWidget {
  const _CommentsInputWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _renderTextField(),
        ),
        const SizedBox(width: 8.0),
        _renderSendButton(),
      ],
    );
  }

  Widget _renderTextField() {
    return TextField(
      maxLines: 1,
      decoration: InputDecoration(
        filled: true,
        fillColor: grayScaleGrey600,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 16.0,
        ),
      ),
      style: const TextStyle(
        color: grayScaleGrey100,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: grayScaleGrey100,
    );
  }

  Widget _renderSendButton() {
    return Container(
      decoration: BoxDecoration(
        color: grayScaleGrey600,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(6.0),
      child: IconButton(
        icon: Image.asset(
          'asset/image/icon_message.png',
          width: 24.0,
          height: 24.0,
        ),
        onPressed: () {
          // 버튼 클릭 시 수행할 동작
        },
      ),
    );
  }
}
