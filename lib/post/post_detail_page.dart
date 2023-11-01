import 'package:flutter/material.dart';
import 'package:moing_flutter/board/component/icon_text_button.dart';
import 'package:moing_flutter/const/style/elevated_button.dart';
import 'package:moing_flutter/model/comment/comment_model.dart';
import 'package:moing_flutter/model/post/post_detail_model.dart';
import 'package:moing_flutter/model/response/get_all_comments_response.dart';
import 'package:moing_flutter/post/component/comment_card.dart';
import 'package:moing_flutter/post/post_detail_state.dart';

import 'package:provider/provider.dart';

import '../const/color/colors.dart';

class PostDetailPage extends StatelessWidget {
  static const routeName = '/post/detail';

  const PostDetailPage({Key? key}) : super(key: key);

  static route(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    final int teamId = arguments?['teamId'];
    final int boardId = arguments?['boardId'];

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PostDetailState(
            context: context,
            teamId: teamId,
            boardId: boardId,
          ),
        ),
      ],
      builder: (context, _) {
        return const PostDetailPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final PostDetailData? postDetailData =
        context.watch<PostDetailState>().postData;

    return Scaffold(
      backgroundColor: grayScaleGrey900,
      appBar: renderAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 26.0),
                      if (postDetailData?.isNotice ?? false) _renderNoticeTag(),
                      const SizedBox(height: 12.0),
                      Text(
                        postDetailData?.title ?? '',
                        style: const TextStyle(
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
                            Text(
                              postDetailData?.writerNickName ?? '',
                              style: const TextStyle(
                                color: grayScaleGrey400,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            if (postDetailData?.writerIsLeader ?? false)
                              Image.asset(
                                'asset/image/icon_crown.png',
                                width: 14.0,
                                height: 14.0,
                              ),
                            const Spacer(),
                            Text(
                              postDetailData?.createdDate ?? '',
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: grayBlack8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        postDetailData?.content ?? '',
                        style: const TextStyle(
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
                Expanded(child: _renderCommentScrollBody(context: context)),
                Container(
                  color: grayScaleGrey700,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    child: _CommentsInputWidget(),
                  ),
                ),
              ],
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
      actions: [
        IconButton(
          onPressed: () {
            showPostControlBottomSheet(context: context);
          },
          icon: const Icon(Icons.more_vert),
        )
      ],
    );
  }

  void showPostControlBottomSheet({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      backgroundColor: grayScaleGrey600,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      builder: (_) {
        final screenHeight = MediaQuery.of(context).size.height;
        return SizedBox(
          height: screenHeight * 0.30,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IconTextButton(
                  onPressed: () {
                    context.read<PostDetailState>().navigatePostUpdatePage();
                  },
                  icon: 'asset/image/icon_edit.png',
                  text: '게시글 수정하기',
                ),
                IconTextButton(
                  onPressed: () {
                    context.read<PostDetailState>().deletePost();
                  },
                  icon: 'asset/image/icon_delete.png',
                  text: '게시글 삭제하기',
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: defaultButtonStyle,
                  child: const Text('닫기'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _renderCommentScrollBody({required BuildContext context}) {
    AllCommentData? allCommentData =
        context.watch<PostDetailState>().allCommentData;
    List<CommentData> commentList = allCommentData?.commentBlocks ?? [];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 8.0,
        ),
        child: Column(
          children: commentList.map((CommentData comment) {
            return CommentCard(commentData: comment);
          }).toList(),
        ),
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
          child: _renderTextField(context: context),
        ),
        const SizedBox(width: 8.0),
        _renderSendButton(context: context),
      ],
    );
  }

  Widget _renderTextField({required BuildContext context}) {
    return TextField(
      controller: context.watch<PostDetailState>().commentController,
      onChanged: (value) => context.read<PostDetailState>().updateTextField(),
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

  Widget _renderSendButton({required BuildContext context}) {
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
        onPressed: context.watch<PostDetailState>().postCreateComment,
      ),
    );
  }
}
