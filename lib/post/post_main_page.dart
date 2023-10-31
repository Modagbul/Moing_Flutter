import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/elevated_button.dart';
import 'package:moing_flutter/model/response/get_all_posts_response.dart';
import 'package:moing_flutter/post/component/notice_card.dart';
import 'package:moing_flutter/post/component/post_card.dart';
import 'package:moing_flutter/post/post_main_state.dart';
import 'package:provider/provider.dart';

class PostMainPage extends StatelessWidget {
  static const routeName = '/post/main';

  const PostMainPage({super.key});

  static route(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    final int teamId = arguments as int;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PostMainState(
            context: context,
            teamId: teamId,
          ),
        ),
      ],
      builder: (context, _) {
        return const PostMainPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    NoticeData? postData = context.watch<PostMainState>().postData;

    return Scaffold(
      backgroundColor: grayScaleGrey900,
      appBar: renderAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            (postData?.noticeNum == 0 && postData?.notNoticeNum == 0)
                ? const Center(
                    child: Text(
                      '아직 게시글이 없어요,\n첫 게시글을 올려보세요!',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: grayScaleGrey400,
                      ),
                    ),
                  )
                : const Column(
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
                onPressed: context.read<PostMainState>().navigatePostCreatePage,
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
    NoticeData? postData = context.watch<PostMainState>().postData;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 5.0,
          ),
          child: _renderNoticeHeader(noticeNum: postData?.noticeNum ?? 0),
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: _renderNoticeScrollBody(context: context),
        ),
      ],
    );
  }

  Widget _renderNoticeHeader({required int noticeNum}) {
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

  Widget _renderNoticeScrollBody({required BuildContext context}) {
    NoticeData? postData = context.read<PostMainState>().postData;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: postData?.noticeBlocks
                .map((notice) => NoticeCard(
                      commentNum: notice.commentNum,
                      content: notice.content,
                      nickName: notice.writerNickName,
                      title: notice.title,
                    ))
                .toList() ??
            [],
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
          const SizedBox(height: 24.0),
          Expanded(child: _renderPostScrollBody(context: context)),
        ],
      ),
    );
  }

  Widget _renderPostHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '게시글',
          style: TextStyle(
            color: grayScaleGrey400,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '날짜순',
          style: TextStyle(
            color: grayScaleGrey400,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _renderPostScrollBody({required BuildContext context}) {
    NoticeData? postData = context.watch<PostMainState>().postData;
    return ListView.builder(
      itemCount: postData?.notNoticeBlocks.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: postData?.notNoticeBlocks
                  .map((post) => PostCard(
                        commentNum: post.commentNum,
                        content: post.content,
                        nickName: post.writerNickName,
                        title: post.title,
                      ))
                  .toList() ??
              [],
        );
      },
    );
  }
}
