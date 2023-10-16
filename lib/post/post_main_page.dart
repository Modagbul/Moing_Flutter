import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/elevated_button.dart';
import 'package:moing_flutter/post/component/notice_card.dart';
import 'package:moing_flutter/post/component/post_card.dart';
import 'package:moing_flutter/post/post_main_state.dart';
import 'package:provider/provider.dart';

class PostMainPage extends StatelessWidget {
  static const routeName = '/post/main';

  const PostMainPage({Key? key}) : super(key: key);

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostMainState(context: context)),
      ],
      builder: (context, _) {
        return const PostMainPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayScaleGrey900,
      appBar: renderAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.0),
                _Notice(),
                SizedBox(height: 32.0),
                Expanded(child: _Post()),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {},
                style: brightButtonStyle.copyWith(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('글쓰기 +'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget renderAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: grayScaleGrey900,
      elevation: 0.0,
      title: const Text('게시글 전체보기'),
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

class _Notice extends StatelessWidget {
  const _Notice();

  @override
  Widget build(BuildContext context) {
    const noticeNum = 1;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 5.0,
          ),
          child: _renderNoticeHeader(noticeNum: noticeNum),
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: _renderNoticeScrollBody(context: context),
        ),
      ],
    );
  }

  Widget _renderNoticeHeader({required noticeNum}) {
    return Row(
      children: [
        Image.asset(
          'asset/image/icon_solar_pin_bold.png',
          width: 20.0,
          height: 20.0,
        ),
        const SizedBox(width: 4.0),
        Text(
          '공지사항 $noticeNum',
          style: const TextStyle(
            color: coralGrey500,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }

  Widget _renderNoticeScrollBody({required context}) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          NoticeCard(
            nickName: 'nickName',
            title: 'title',
            content: 'content',
            commentNum: '1',
          ),
          SizedBox(width: 8.0),
          NoticeCard(
            commentNum: '1',
            nickName: 'nickName',
            title: 'title',
            content: 'content',
          ),
        ],
      ),
    );
  }
}

class _Post extends StatelessWidget {
  const _Post();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _renderPostHeader(),
          const SizedBox(height: 12.0),
          Expanded(child: _renderPostScrollBody()),
        ],
      ),
    );
  }

  Widget _renderPostHeader() {
    return const Text(
      '게시글',
      style: TextStyle(
        color: grayScaleGrey400,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _renderPostScrollBody() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        return const Column(
          children: [
            SizedBox(width: 12.0),
            PostCard(
              nickName: 'nickName',
              title: 'title',
              content: 'content',
              commentNum: '1',
            ),
          ],
        );
      },
    );
  }
}
